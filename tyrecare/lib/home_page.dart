// lib/home_page.dart
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'models.dart';
import 'detail_page.dart';

class HomePage extends StatelessWidget {
  final Veicolo veicolo;
  final double kmSlider;
  final Function(double) onKmVariati;
  final List<String> listaNomiVeicoli;
  final List<Map<String, dynamic>> transazioni;
  final Function(String) onAutoCambiata;
  final Function(int) onTabCambiato;

  const HomePage({
    super.key,
    required this.veicolo,
    required this.kmSlider,
    required this.onKmVariati,
    required this.listaNomiVeicoli,
    required this.transazioni,
    required this.onAutoCambiata,
    required this.onTabCambiato,
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
              // 1. MODELLO 3D AUTO IN PROSPETTIVA (Contenitore ridotto, Zoom aumentato)
              SizedBox(
                height: 170,
                child: Stack(
                  children: [
                    ModelViewer(
                      backgroundColor: const Color(0xFF1E1E1E),
                      src: 'assets/bmw_m4csl-v1.glb',
                      alt: "Test Modello 3D",
                      autoRotate: true,
                      cameraControls: true,
                      disableZoom: true,
                      autoPlay: true,
                      ar: false,
                      loading: Loading.eager,
                      cameraOrbit: "0deg 75deg 65%", // Inclinazione più alta (75°) e più lontana (65%) per non tagliare il muso
                      minCameraOrbit: "auto 75deg auto", 
                      maxCameraOrbit: "auto 75deg auto", 
                      fieldOfView: "22deg",          // Campo visivo leggermente più ampio
                      interpolationDecay: 400,
                    ),
                    // ICONA 360°
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.threed_rotation,
                          color: Colors.white70,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8), // Ridotto da 12 a 8

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
              const SizedBox(height: 8), // Ridotto da 12 a 8

            // 3. STATO GENERALE PNEUMATICI (MOCKUP STILE ANTEPRIMA)
            Container(
              padding: const EdgeInsets.all(12), // Ridotto padding interno da 16 a 12
              decoration: BoxDecoration(
                color: const Color(0xFF252525),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Stato generale pneumatici', style: TextStyle(color: Colors.grey, fontSize: 13)),
                          const SizedBox(height: 4), // Ridotto da 6 a 4
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text('$mediaUsura', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white)), // Ridotto font da 38 a 34
                              const Text('%', style: TextStyle(fontSize: 18, color: Colors.white)),
                            ],
                          ),
                          const SizedBox(height: 2), // Ridotto da 4 a 2
                          Text(
                            mediaUsura > 70 ? 'Ottimo stato' : (mediaUsura > 50 ? 'Stato medio' : 'Urgente controllo'), 
                            style: TextStyle(color: coloreStatoGenerale, fontWeight: FontWeight.bold, fontSize: 13) // Ridotto font da 14 a 13
                          ),
                        ],
                      ),
                      // Grafico ad anello circolare nativo
                      SizedBox(
                        width: 65, // Ridotto da 75 a 65
                        height: 65,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: 1.0, 
                              strokeWidth: 7, // Ridotto da 8 a 7
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.redAccent),
                            ),
                            CircularProgressIndicator(
                              value: mediaUsura / 100,
                              strokeWidth: 7, // Ridotto da 8 a 7
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(coloreStatoGenerale),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0), // Ridotto da 12 a 10
                    child: Divider(color: Color(0xFF333333), height: 1),
                  ),
                  // INFO CONTROLLI INTEGRATE NELLA CARD
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Ultimo controllo', style: TextStyle(color: Colors.grey, fontSize: 10)), // Ridotto da 11 a 10
                          const SizedBox(height: 2), // Ridotto da 4 a 2
                          const Text('12 Marzo 2024', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)), // Ridotto da 13 a 12
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Prossimo controllo', style: TextStyle(color: Colors.grey, fontSize: 10)),
                          const SizedBox(height: 2),
                          const Text('tra 1.200 km', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12), // Ridotto da 16 a 12

            // 4. PLANCIA TOP-DOWN DIAGNOSTICA CON LED E CARD RETTANGOLARI
            Expanded(
              flex: 4, // Aumentato leggermente il flex per dare respiro alle card
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
                    // Chassis centrale con immagine auto + bagliore gomme
                    Expanded(
                      flex: 3,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // IMMAGINE AUTO TOP-DOWN
                          Opacity(
                            opacity: 0.8,
                            child: Image.asset(
                              'assets/autoHomePage.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          // BAGLIORI GOMME DINAMICI
                          _buildGlowTire(top: 22, left: 6, usura: uAntSx),
                          _buildGlowTire(top: 22, right: 6, usura: uAntDx),
                          _buildGlowTire(bottom: 22, left: 6, usura: uPostSx),
                          _buildGlowTire(bottom: 22, right: 6, usura: uPostDx),
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
              onPressed: () => onTabCambiato(2),
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
          MaterialPageRoute(builder: (context) => DetailPage(veicolo: veicolo, posizioneIniziale: pos, kmSlider: kmSlider, transazioni: transazioni)),
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

  Widget _buildGlowTire({double? top, double? bottom, double? left, double? right, required int usura}) {
    Color c = usura > 70 ? Colors.greenAccent : (usura > 50 ? Colors.orangeAccent : Colors.redAccent);
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Container(
        width: 12,
        height: 20,
        decoration: BoxDecoration(
          color: c.withOpacity(0.4),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: c.withOpacity(0.8),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
        ),
      ),
    );
  }
}