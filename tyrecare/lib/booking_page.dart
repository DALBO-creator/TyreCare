import 'package:flutter/material.dart';
import 'slots_page.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  // Teniamo traccia del servizio selezionato tramite l'indice della lista
  int _indiceServizioSelezionato = 0;

  // Struttura dati ufficiale presa dal tuo mockup
  final List<Map<String, dynamic>> _serviziUfficiali = [
    {
      'titolo': 'Cambio gomme stagionale',
      'sottotitolo': 'Estive / Invernali',
      'icona': Icons.published_with_changes_rounded,
    },
    {
      'titolo': 'Controllo sicurezza',
      'sottotitolo': 'Controllo completo pneumatici',
      'icona': Icons.gpp_good_outlined,
    },
    {
      'titolo': 'Equilibratura',
      'sottotitolo': 'Bilanciamento ruote',
      'icona': Icons.incomplete_circle_rounded, // Un'icona tecnica che ricorda la centratura (o Icons.incomplete_circle)
    },
    {
      'titolo': 'Convergenza',
      'sottotitolo': 'Allineamento ruote',
      'icona': Icons.sync_alt_rounded,
    },
    {
      'titolo': 'Riparazione pneumatici',
      'sottotitolo': 'Riparazione e sostituzione',
      'icona': Icons.build_circle_outlined,
    },
    {
      'titolo': 'Deposito gomme',
      'sottotitolo': 'Custodia stagionale',
      'icona': Icons.grid_view_rounded,
    },
    {
      'titolo': 'Intervento su strada',
      'sottotitolo': 'Assistenza h24',
      'icona': Icons.car_repair_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text('Prenota un servizio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Cosa desideri prenotare?',
              style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),

            // LA LISTA DEI SERVIZI PRESI DAL MOCKUP
            Expanded(
              child: ListView.builder(
                itemCount: _serviziUfficiali.length,
                itemBuilder: (context, index) {
                  final servizio = _serviziUfficiali[index];
                  final isSelezionato = _indiceServizioSelezionato == index;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF252525), // Grigio scuro coerente con lo sfondo delle card
                      borderRadius: BorderRadius.circular(12),
                      // Se è selezionato, mostriamo un leggero bordo di feedback primario
                      border: Border.all(
                        color: isSelezionato ? Colors.redAccent.withOpacity(0.5) : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      onTap: () {
                        setState(() {
                          _indiceServizioSelezionato = index;
                        });
                      },
                      leading: Icon(
                        servizio['icona'] as IconData, 
                        color: isSelezionato ? Colors.redAccent : Colors.grey,
                        size: 24,
                      ),
                      title: Text(
                        servizio['titolo'] as String,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Text(
                        servizio['sottotitolo'] as String,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios, 
                        color: Colors.grey, 
                        size: 14,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // IL BOTTONE SOTTILE PREMIUM "Vedi disponibilità"
            OutlinedButton(
              onPressed: () {
                // RECUPERIAMO IL TESTO DEL SERVIZIO SELEZIONATO
                final servizioScelto = _serviziUfficiali[_indiceServizioSelezionato]['title'] ?? 
                                       _serviziUfficiali[_indiceServizioSelezionato]['titolo'];
                
                // NAVIGHIAMO SULLA SLOTSPAGE PASSANDO IL SERVIZIO
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SlotsPage(servizioScelto: servizioScelto),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF4A1519), width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Vedi disponibilità',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}