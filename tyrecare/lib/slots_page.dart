// lib/slots_page.dart
import 'package:flutter/material.dart';

class SlotsPage extends StatefulWidget {
  final String servizioScelto;

  const SlotsPage({super.key, required this.servizioScelto});

  @override
  State<SlotsPage> createState() => _SlotsPageState();
}

class _SlotsPageState extends State<SlotsPage> {
  int? _officinaSelezionata = 0;
  int? _orarioSelezionato;

  final List<Map<String, String>> _officinePartner = [
    {'nome': 'PneusHub Travagliato', 'distanza': '1.2 km da te • Partner Top'},
    {'nome': 'Master Driver Brescia Ovest', 'distanza': '8.5 km da te'},
    {'nome': 'Garage iperGomme Castegnato', 'distanza': '11.0 km da te'},
  ];

  final List<String> _orariDisponibili = [
    '08:30', '09:30', '10:30', '11:30', '14:30', '15:30', '16:30', '17:30'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Disponibilità', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Officine disponibili per: ${widget.servizioScelto}',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),

            // SELEZIONE OFFICINA (Card interattive)
            ...List.generate(_officinePartner.length, (index) {
              final officina = _officinePartner[index];
              final isSelezionata = _officinaSelezionata == index;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF161616),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelezionata ? Colors.redAccent.withOpacity(0.5) : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: ListTile(
                  onTap: () => setState(() => _officinaSelezionata = index),
                  leading: Icon(Icons.location_on, color: isSelezionata ? Colors.redAccent : Colors.grey),
                  title: Text(officina['nome']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text(officina['distanza']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  trailing: isSelezionata ? const Icon(Icons.check_circle, color: Colors.redAccent, size: 20) : null,
                ),
              );
            }),

            const SizedBox(height: 24),
            const Text(
              'Orari disponibili per oggi / domani:',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 12),

            // GRIGLIA DEGLI ORARI (Slot di tempo cliccabili)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2.2,
              ),
              itemCount: _orariDisponibili.length,
              itemBuilder: (context, index) {
                final isSelezionato = _orarioSelezionato == index;
                return GestureDetector(
                  onTap: () => setState(() => _orarioSelezionato = index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelezionato ? Colors.redAccent : const Color(0xFF161616),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelezionato ? Colors.transparent : Colors.grey[800]!,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _orariDisponibili[index],
                        style: TextStyle(
                          color: isSelezionato ? Colors.white : Colors.grey[300],
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const Spacer(),

            // BOTTONE DI CONFERMA FINALE (In linea con lo stile del mockup)
            OutlinedButton(
              onPressed: _orarioSelezionato == null 
                  ? null 
                  : () {
                      _mostraPopupSuccesso(context);
                    },
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: _orarioSelezionato == null ? Colors.grey[800]! : const Color(0xFF4A1519), 
                  width: 1.5
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF0A0A0A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'Conferma Appuntamento',
                style: TextStyle(
                  color: _orarioSelezionato == null ? Colors.grey : Colors.white, 
                  fontWeight: FontWeight.w600, 
                  fontSize: 15
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostraPopupSuccesso(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.greenAccent),
            SizedBox(width: 10),
            Text('Prenotazione Inviata', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        content: Text(
          'Hai prenotato con successo il servizio di "${widget.servizioScelto}" presso "${_officinePartner[_officinaSelezionata!]['nome']}" alle ore ${_orariDisponibili[_orarioSelezionato!]}.',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Chiude il popup
              Navigator.pop(context); // Torna alla schermata principale di prenotazione
            },
            child: const Text('CHIUDI', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}