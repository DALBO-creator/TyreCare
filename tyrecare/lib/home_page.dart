// lib/home_page.dart
import 'package:flutter/material.dart';
import 'models.dart';
import 'detail_page.dart';

class HomePage extends StatelessWidget {
  final Veicolo veicolo;
  final double kmSlider;
  final Function(double) onKmVariati;
  final List<String> listaNomiVeicoli;
  final Function(String) onAutoCambiata;

  const HomePage({
    super.key,
    required this.veicolo,
    required this.kmSlider,
    required this.onKmVariati,
    required this.listaNomiVeicoli,
    required this.onAutoCambiata,
  });

  @override
  Widget build(BuildContext context) {
    // Calcolo usura media per il grafico circolare ad anello
    int uAntSx = veicolo.antSx.calcolaUsuraDinamica(kmSlider);
    int uAntDx = veicolo.antDx.calcolaUsuraDinamica(kmSlider);
    int uPostSx = veicolo.postSx.calcolaUsuraDinamica(kmSlider);
    int uPostDx = veicolo.postDx.calcolaUsuraDinamica(kmSlider);
    int mediaUsura = ((uAntSx + uAntDx + uPostSx + uPostDx) / 4).round();

    Color coloreStatoGenerale = mediaUsura > 70 
        ? Colors.greenAccent 
        : (mediaUsura > 50 ? Colors.orangeAccent : Colors.redAccent);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: veicolo.nome,
            dropdownColor: const Color(0xFF2D2D2D),
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
            isDense: true,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
            items: listaNomiVeicoli.map((String nome) {
              return DropdownMenuItem<String>(
                value: nome,
                child: Row(
                  children: [
                    const Text('La tua ', style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white)),
                    Text(nome),
                  ],
                ),
              );
            }).toList(),
            onChanged: (nuovoNome) {
              if (nuovoNome != null) onAutoCambiata(nuovoNome);
            },
          ),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. MODELLO 3D AUTO IN PROSPETTIVA (USA EXPANDED PER ADATTARSI)
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: 0.9,
                      child: Image.network(
                        'https://images.pngimages.com/download/0b18f8e0d6da7e923e1e9a26372bf9dc.png', 
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 8,
                      child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.threed_rotation, color: Colors.grey, size: 12),
                          SizedBox(width: 4),
                          Text('360°', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 2. SLIDER DEI CHILOMETRI INTEGRATO CON CURA
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF252525),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Simulazione chilometri:', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        Text('${kmSlider.toInt()} km', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Slider(
                      value: kmSlider,
                      min: 0,
                      max: 15000,
                      divisions: 150,
                      activeColor: Colors.redAccent,
                      inactiveColor: Colors.grey[800],
                      onChanged: (newValue) => onKmVariati(newValue),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 3. STATO GENERALE PNEUMATICI (MOCKUP STILE ANTEPRIMA)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF252525),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Stato generale pneumatici', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text('$mediaUsura', style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white)),
                          const Text('%', style: TextStyle(fontSize: 20, color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mediaUsura > 70 ? 'Ottimo stato' : (mediaUsura > 50 ? 'Stato medio' : 'Urgente controllo'), 
                        style: TextStyle(color: coloreStatoGenerale, fontWeight: FontWeight.bold, fontSize: 14)
                      ),
                    ],
                  ),
                  // Grafico ad anello circolare nativo
                  SizedBox(
                    width: 75,
                    height: 75,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: 1.0, // Rosso come base per far vedere che non è pieno
                          strokeWidth: 8,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                        ),
                        CircularProgressIndicator(
                          value: mediaUsura / 100,
                          strokeWidth: 8,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(coloreStatoGenerale),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // INFO CONTROLLI (Sotto la card stato generale)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ultimo controllo', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 4),
                    const Text('12 Marzo 2024', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Prossimo controllo', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 4),
                    const Text('tra 1.200 km', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 4. PLANCIA TOP-DOWN DIAGNOSTICA CON LED E CARD RETTANGOLARI
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF252525),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    // Colonna SX
                    Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCardTire(context, 'Ant. sx', veicolo.antSx, uAntSx),
                          _buildCardTire(context, 'Post. sx', veicolo.postSx, uPostSx),
                        ],
                      ),
                    ),
                    // Chassis centrale + Neon
                    Expanded(
                      flex: 3,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 45,
                            height: 100,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[800]!, width: 1.5),
                            ),
                          ),
                          _buildNeon(top: 8, left: 2, usura: uAntSx),
                          _buildNeon(top: 8, right: 2, usura: uAntDx),
                          _buildNeon(bottom: 8, left: 2, usura: uPostSx),
                          _buildNeon(bottom: 8, right: 2, usura: uPostDx),
                        ],
                      ),
                    ),
                    // Colonna DX
                    Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCardTire(context, 'Ant. dx', veicolo.antDx, uAntDx),
                          _buildCardTire(context, 'Post. dx', veicolo.postDx, uPostDx),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // POLISHED ACTION BUTTON RED
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC62828),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('PRENOTA UN CONTROLLO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5)),
            )
          ],
        ),
      )),
    );
  }

  Widget _buildCardTire(BuildContext context, String pos, Pneumatico p, int usuraDinamica) {
    Color c = usuraDinamica > 70 ? Colors.greenAccent : (usuraDinamica > 50 ? Colors.orangeAccent : Colors.redAccent);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailPage(veicolo: veicolo, posizioneIniziale: pos, kmSlider: kmSlider)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pos, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${p.pressioneBase} bar', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                Icon(Icons.circle, size: 6, color: c),
              ],
            ),
            Text('$usuraDinamica%', style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildNeon({double? top, double? bottom, double? left, double? right, required int usura}) {
    Color c = usura > 70 ? Colors.greenAccent : (usura > 50 ? Colors.orangeAccent : Colors.redAccent);
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Container(
        width: 4,
        height: 16,
        decoration: BoxDecoration(
          color: c,
          borderRadius: BorderRadius.circular(1),
          boxShadow: [BoxShadow(color: c.withOpacity(0.6), blurRadius: 6, spreadRadius: 1)],
        ),
      ),
    );
  }
}