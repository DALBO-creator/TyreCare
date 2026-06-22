// lib/check_page.dart
import 'package:flutter/material.dart';
import 'models.dart';

class CheckPage extends StatelessWidget {
  final List<Veicolo> listaVeicoli;
  final String idVeicoloCorrente;
  final Function(String) onAutoSelezionataDalGarage;

  const CheckPage({
    super.key,
    required this.listaVeicoli,
    required this.idVeicoloCorrente,
    required this.onAutoSelezionataDalGarage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text('Il mio garage', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
        backgroundColor: const Color(0xFF1E1E1E),
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
        itemCount: listaVeicoli.length + 1,
        itemBuilder: (context, index) {
          if (index == listaVeicoli.length) {
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

          final v = listaVeicoli[index];
          final bool isCorrente = v.id == idVeicoloCorrente;

          return GestureDetector(
            onTap: () => onAutoSelezionataDalGarage(v.nome),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF252525),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isCorrente ? Colors.redAccent.withValues(alpha: 0.5) : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isCorrente)
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
                        Text('${v.anno} • ${v.chilometriBase} km', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 60,
                    child: Opacity(
                      opacity: isCorrente ? 1.0 : 0.5,
                      child: Image.network(v.immagineUrl, fit: BoxFit.contain),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}