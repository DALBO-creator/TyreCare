import 'package:flutter/material.dart';
import 'detail_page.dart';
import 'booking_page.dart';

class CheckPage extends StatefulWidget {
  final String nomeVeicolo; // <-- Chiediamo il nome del veicolo corrente

  const CheckPage({super.key, this.nomeVeicolo = 'BMW Serie 3'}); // Default se aperta dal menu in basso

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  double _chilometri = 5000;
  int _percentualeSalute = 100;
  String _statoTesto = 'Nuove';
  Color _coloreStato = Colors.green;

  void _calcolaSaluteGomme(double km) {
    setState(() {
      _chilometri = km;
      double calcolo = 100 - (km / 40000 * 100);
      _percentualeSalute = calcolo.clamp(0, 100).toInt();

      if (_percentualeSalute > 70) {
        _statoTesto = 'Ottimo stato';
        _coloreStato = Colors.green;
      } else if (_percentualeSalute > 40) {
        _statoTesto = 'Stato intermedio';
        _coloreStato = Colors.orange;
      } else {
        _statoTesto = 'Usura critica - Cambiare subito!';
        _coloreStato = Colors.red;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nomeVeicolo, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF2D2D2D),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Quanti km hai fatto dall\'ultimo cambio gomme?',
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${_chilometri.toInt()} km',
                    style: const TextStyle(color: Colors.blueAccent, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _chilometri,
                    min: 0,
                    max: 50000,
                    divisions: 50,
                    activeColor: Colors.blueAccent,
                    inactiveColor: Colors.grey[700],
                    onChanged: (nuovoValore) {
                      _calcolaSaluteGomme(nuovoValore);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Stato generale pneumatici',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$_percentualeSalute%',
                            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            _statoTesto,
                            style: TextStyle(color: _coloreStato, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      Icon(Icons.check_circle_outline, size: 60, color: _coloreStato),
                    ],
                  ),
                  const Divider(color: Colors.grey, height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _infoDate('Ultimo controllo', '12 Marzo 2026'),
                      _infoDate('Prossimo controllo', _percentualeSalute > 40 ? 'Consigliato tra 5.000 km' : 'URGENTE IN OFFICINA'),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(child: _ruotaCard(context, 'Ant. sx', '$_percentualeSalute%', _coloreStato, _chilometri)),
                const SizedBox(width: 16),
                Expanded(child: _ruotaCard(context, 'Ant. dx', '${(_percentualeSalute + 2).clamp(0, 100).toInt()}%', _coloreStato, _chilometri)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _ruotaCard(context, 'Post. sx', '${(_percentualeSalute - 3).clamp(0, 100).toInt()}%', _coloreStato, _chilometri)),
                const SizedBox(width: 16),
                Expanded(child: _ruotaCard(context, 'Post. dx', '${(_percentualeSalute - 1).clamp(0, 100).toInt()}%', _coloreStato, _chilometri)),
              ],
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookingPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'PRENOTA UN CONTROLLO',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoDate(String titolo, String valore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titolo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(valore, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  Widget _ruotaCard(BuildContext context, String posizione, String usura, Color colore, double km) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              posizioneRuota: posizione, 
              usuraAttuale: usura, 
              chilometriAttuali: km,
              veicoloAttuale: widget.nomeVeicolo, // <-- Passiamo il veicolo corrente!
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(posizione, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 12),
            Text(usura, style: TextStyle(color: colore, fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}