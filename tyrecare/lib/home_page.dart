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
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: veicolo.nome,
            dropdownColor: const Color(0xFF1A1A1A),
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
        backgroundColor: const Color(0xFF0A0A0A),
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0), // Padding verticale azzerato per alzare tutto
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. LOGO TYRECARE (Sostituito al modello 3D)
              SizedBox(
                height: 120, // Altezza intermedia per bilanciare lo spazio
                child: Center(
                  child: Image.asset(
                    'assets/logoTyreCare.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 6), // Ridotto da 8 a 6

              // 2. SLIDER DEI CHILOMETRI INTEGRATO CON CURA
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF161616).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.5),
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
                        inactiveColor: const Color(0xFF2A2A2A),
                        onChanged: (newValue) => onKmVariati(newValue),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6), // Ridotto da 8 a 6

            // 3. STATO GENERALE PNEUMATICI (MOCKUP STILE ANTEPRIMA)
            Container(
              padding: const EdgeInsets.all(12), // Ridotto padding interno da 16 a 12
              decoration: BoxDecoration(
                color: const Color(0xFF161616).withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.5),
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
                    child: Divider(color: Color(0xFF1F1F1F), height: 1),
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
            const SizedBox(height: 8), // Ridotto da 12 a 8

            // 4. PLANCIA TOP-DOWN DIAGNOSTICA (Layout a Stack per angoli e auto grande)
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0A0A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    // IMMAGINE AUTO CENTRALE (Più grande delle card)
                    Center(
                      child: SizedBox(
                        width: 270, // Aumentata ulteriormente la dimensione dell'auto
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity: 0.9,
                              child: Image.asset(
                                'assets/autoHomePage.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            // BAGLIORI GOMME (Avvicinati alla carrozzeria per massima precisione)
                            _buildGlowTire(top: 51, left: 95, usura: uAntSx),
                            _buildGlowTire(top: 51, right: 98, usura: uAntDx),
                            _buildGlowTire(bottom: 43, left: 95, usura: uPostSx),
                            _buildGlowTire(bottom: 43, right: 98, usura: uPostDx),
                          ],
                        ),
                      ),
                    ),
                    // CARD AI 4 ANGOLI (Posizionamento distanziato per evitare sovrapposizioni)
                    Positioned(top: 22, left: 16, child: _buildCardTire(context, 'Ant. sx', veicolo.antSx, uAntSx)),
                    Positioned(top: 22, right: 16, child: _buildCardTire(context, 'Ant. dx', veicolo.antDx, uAntDx)),
                    Positioned(bottom: 22, left: 16, child: _buildCardTire(context, 'Post. sx', veicolo.postSx, uPostSx)),
                    Positioned(bottom: 22, right: 16, child: _buildCardTire(context, 'Post. dx', veicolo.postDx, uPostDx)),
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
        width: 82, 
        height: 90, // Aumentata dimensione per ospitare il mini grafico
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A).withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.12), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(pos, style: const TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.w500)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${p.pressioneBase}', style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, height: 1.1)),
                const Text('bar', style: TextStyle(color: Colors.grey, fontSize: 8)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$usuraDinamica%', style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.bold)),
                // Mini grafico ad anello al posto del puntino
                SizedBox(
                  width: 14,
                  height: 14,
                  child: Stack(
                    children: [
                      CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent.withOpacity(0.2)),
                      ),
                      CircularProgressIndicator(
                        value: usuraDinamica / 100,
                        strokeWidth: 2,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(c),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlowTire({double? top, double? bottom, double? left, double? right, required int usura}) {
    Color c = usura > 70 ? Colors.greenAccent : (usura > 50 ? Colors.orangeAccent : Colors.redAccent);
    bool isLeft = left != null;
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: CustomPaint(
        size: const Size(3, 24), // Molto più sottile e slanciato
        painter: _TireGlowPainter(color: c, isLeft: isLeft),
      ),
    );
  }
}

class _TireGlowPainter extends CustomPainter {
  final Color color;
  final bool isLeft;

  _TireGlowPainter({required this.color, required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final Path path = Path();
    double curveIntensity = 2.0;

    if (isLeft) {
      // Curva verso l'interno (destra) per le gomme di sinistra )
      path.moveTo(0, 0);
      path.quadraticBezierTo(curveIntensity, size.height / 2, 0, size.height);
      path.lineTo(size.width, size.height);
      path.quadraticBezierTo(size.width + curveIntensity, size.height / 2, size.width, 0);
    } else {
      // Curva verso l'interno (sinistra) per le gomme di destra (
      path.moveTo(size.width, 0);
      path.quadraticBezierTo(size.width - curveIntensity, size.height / 2, size.width, size.height);
      path.lineTo(0, size.height);
      path.quadraticBezierTo(-curveIntensity, size.height / 2, 0, 0);
    }
    path.close();

    canvas.drawPath(path, paint);

    // Nucleo più luminoso
    final Paint corePaint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
    canvas.drawPath(path, corePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
