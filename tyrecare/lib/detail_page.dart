import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String posizioneRuota;
  final String usuraAttuale;
  final double chilometriAttuali;
  final String veicoloAttuale; // <-- Nuova variabile per il veicolo attivo

  const DetailPage({
    super.key, 
    required this.posizioneRuota, 
    required this.usuraAttuale,
    required this.chilometriAttuali,
    required this.veicoloAttuale, // <-- Richiesta nel costruttore
  });

@override
  Widget build(BuildContext context) {
    final String marcaGomme = veicoloAttuale.contains('BMW') ? 'Pirelli P Zero' : 'Michelin Pilot Sport';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettaglio pneumatico', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      // Abbiamo aggiunto SingleChildScrollView e rimosso il Spacer() che causava il blocco
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              posizioneRuota.toUpperCase(),
              style: const TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.bold, letterSpacing: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            Container(
              height: 180, // Ridotto leggermente da 200 a 180 per dare più respiro
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2D2D2D),
                border: Border.all(color: Colors.grey[800]!, width: 8),
              ),
              child: const Icon(Icons.album_rounded, size: 100, color: Colors.grey),
            ),
            const SizedBox(height: 25),

            _rigaSpecifica('Modello Pneumatico', marcaGomme),
            _rigaSpecifica('Usura battistrada', usuraAttuale),
            _rigaSpecifica('Pressione attuale', '2.4 bar'),
            _rigaSpecifica('Temperatura', '28 °C'),
            _rigaSpecifica('Chilometri percorsi', '${chilometriAttuali.toInt()} km'),
            
            const SizedBox(height: 30), // Sostituito "Spacer()" con un SizedBox fisso

            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('TORNA ALLA PANORAMICA', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rigaSpecifica(String etichetta, String valore) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(etichetta, style: const TextStyle(color: Colors.grey, fontSize: 15)),
              Text(valore, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: Colors.grey[800], height: 1),
        ],
      ),
    );
  }
}