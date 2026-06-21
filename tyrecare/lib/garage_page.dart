import 'package:flutter/material.dart';

class GaragePage extends StatelessWidget {
  const GaragePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Il mio garage', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Seleziona il veicolo principale:',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),

            // 1. CARD BMW SERIE 3
            _veicoloCard(
              context,
              'BMW Serie 3',
              '2022 • 48.500 km',
              Icons.directions_car_filled,
              Colors.blueAccent,
              true, // È l'auto attualmente attiva
            ),

            const SizedBox(height: 16),

            // 2. CARD AUDI Q3
            _veicoloCard(
              context,
              'Audi Q3',
              '2020 • 32.000 km',
              Icons.car_repair,
              Colors.redAccent,
              false,
            ),

            const SizedBox(height: 30),

            // Pulsante per aggiungere un nuovo veicolo (come nel tuo mockup)
            OutlinedButton.icon(
              onPressed: () {
                print('Aggiungi veicolo premuto');
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Aggiungi veicolo', style: TextStyle(color: Colors.white)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey[700]!),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mini-widget per la scheda del veicolo
  Widget _veicoloCard(BuildContext context, String modello, String info, IconData icona, Color coloreIcona, bool isActive) {
    return InkWell(
      onTap: () {
        // Per ora, quando clicchiamo, torniamo semplicemente indietro passandogli il modello scelto
        Navigator.pop(context, modello);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(16),
          border: isActive ? Border.all(color: Colors.blueAccent, width: 1.5) : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                shape: BoxShape.circle,
              ),
              child: Icon(icona, color: coloreIcona, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    modello,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    info,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
            if (isActive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withAlpha(51),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Principale',
                  style: TextStyle(color: Colors.blueAccent, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}