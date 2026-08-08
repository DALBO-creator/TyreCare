// lib/check_page.dart
import 'package:flutter/material.dart';
import 'models.dart';

class CheckPage extends StatelessWidget {
  final List<Veicolo> veicoli;
  final int indicePrincipale;
  final Function(int) onVeicoloSelezionato;

  const CheckPage({
    super.key,
    required this.veicoli,
    required this.indicePrincipale,
    required this.onVeicoloSelezionato,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Il mio garage', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.redAccent, size: 26),
            onPressed: () {},
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: veicoli.length + 1,
        itemBuilder: (context, index) {
          if (index == veicoli.length) {
            return Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey[800]!),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Aggiungi veicolo', style: TextStyle(color: Colors.white, fontSize: 14)),
              ),
            );
          }

          final v = veicoli[index];
          final isSelezionato = index == indicePrincipale;

          return GestureDetector(
            onTap: () => onVeicoloSelezionato(index),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              // Padding rimosso a destra e verticale per permettere all'auto di toccare i bordi
              padding: const EdgeInsets.only(left: 16, top: 0, bottom: 0, right: 0),
              decoration: BoxDecoration(
                color: const Color(0xFF161616).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelezionato ? Colors.redAccent.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.08),
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isSelezionato)
                          Container(
                            margin: const EdgeInsets.only(bottom: 6.0),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC62828).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('Principale', style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        Text(v.nome, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('${v.anno} • ${v.chilometriIniziali}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                // Immagine zoomata che tocca i bordi top, bottom e right
                SizedBox(
                  width: 140, // Aumentata larghezza
                  height: 100, // Aumentata altezza per coprire la card
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: Opacity(
                      opacity: 0.9,
                      child: Image.asset(
                        'assets/macchinaGarage.png',
                        fit: BoxFit.cover, // Zoom per riempire il contenitore
                        alignment: Alignment.centerLeft, // Mantiene visibile il muso/fiancata
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
        },
      ),
    );
  }
}