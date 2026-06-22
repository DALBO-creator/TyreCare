// lib/home_page.dart
import 'package:flutter/material.dart';
import 'models.dart';
import 'detail_page.dart';

class HomePage extends StatelessWidget {
  final Veicolo veicolo;
  final double cashbackAttuale;
  final double kmSlider;
  final List<String> listaNomiVeicoli;
  final Function(String) onAutoCambiata;
  final Function(double) onKmVariati;

  const HomePage({
    super.key,
    required this.veicolo,
    required this.cashbackAttuale,
    required this.kmSlider,
    required this.listaNomiVeicoli,
    required this.onAutoCambiata,
    required this.onKmVariati,
  });

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
        title: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: veicolo.nome,
            dropdownColor: const Color(0xFF252525),
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
            items: listaNomiVeicoli.map((String nome) {
              return DropdownMenuItem<String>(
                value: nome,
                child: Text(nome),
              );
            }).toList(),
            onChanged: (nuovoNome) {
              if (nuovoNome != null) onAutoCambiata(nuovoNome);
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. MODELLO 3D AUTO COMPATTO
            SizedBox(
              height: 130,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(veicolo.immagineUrl, fit: BoxFit.contain),
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

            // 2. SLIDER DEI CHILOMETRI
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
                        const Text('Simulazione:', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        Text('${kmSlider.toInt()} km', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
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
                      onChanged: onKmVariati,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 3. STATO SALUTE GENERALE
            Container(
              padding: const EdgeInsets.all(14),
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
                      const Text('Stato salute pneumatici', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text('$mediaUsura', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                          const Text('%', style: TextStyle(fontSize: 14, color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(mediaUsura > 70 ? 'Ottimo stato' : (mediaUsura > 50 ? 'Stato medio' : 'Urgente controllo'), 
                              style: TextStyle(color: coloreStatoGenerale, fontWeight: FontWeight.bold, fontSize: 12)),
                          const SizedBox(width: 4),
                          Icon(Icons.circle, size: 6, color: coloreStatoGenerale),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      value: mediaUsura / 100,
                      strokeWidth: 5,
                      backgroundColor: Colors.grey[800],
                      valueColor: AlwaysStoppedAnimation<Color>(coloreStatoGenerale),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),

            // 4. CHASSIS TOP-DOWN + CARD RIQUADRI
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF252525),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        _buildCardTire(context, 'Ant. sx', veicolo.antSx, uAntSx),
                        const SizedBox(height: 30),
                        _buildCardTire(context, 'Post. sx', veicolo.postSx, uPostSx),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 170,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 110,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[800]!, width: 1.5),
                            ),
                          ),
                          _buildNeon(top: 15, left: 1, usura: uAntSx),
                          _buildNeon(top: 15, right: 1, usura: uAntDx),
                          _buildNeon(bottom: 15, left: 1, usura: uPostSx),
                          _buildNeon(bottom: 15, right: 1, usura: uPostDx),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        _buildCardTire(context, 'Ant. dx', veicolo.antDx, uAntDx),
                        const SizedBox(height: 30),
                        _buildCardTire(context, 'Post. dx', veicolo.postDx, uPostDx),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

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
      ),
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
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pos, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${p.pressioneBase} bar', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                Icon(Icons.circle, size: 6, color: c),
              ],
            ),
            const SizedBox(height: 2),
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