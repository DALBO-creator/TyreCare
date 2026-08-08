// lib/booking_page.dart
import 'package:flutter/material.dart';
import 'workshop_selection_page.dart';

class BookingPage extends StatefulWidget {
  final double cashbackDisponibile;
  final Function(Map<String, dynamic>) onBookingConfirmed;

  const BookingPage({
    super.key, 
    required this.cashbackDisponibile,
    required this.onBookingConfirmed
  });

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
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Prenota un servizio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          tooltip: 'Indietro',
          onPressed: () => Navigator.maybePop(context),
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
              child: Column(
                children: List.generate(_serviziUfficiali.length, (index) {
                  final servizio = _serviziUfficiali[index];
                  final isSelezionato = _indiceServizioSelezionato == index;

                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161616).withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelezionato ? Colors.redAccent.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.08),
                          width: 0.5,
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _indiceServizioSelezionato = index;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Icon(
                                servizio['icona'] as IconData, 
                                color: isSelezionato ? Colors.redAccent : Colors.grey,
                                size: 24,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      servizio['titolo'] as String,
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      servizio['sottotitolo'] as String,
                                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios, 
                                color: Colors.grey, 
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 16),

            // IL BOTTONE SOTTILE PREMIUM "Vedi disponibilità"
            OutlinedButton(
              onPressed: () {
                final servizioScelto = _serviziUfficiali[_indiceServizioSelezionato]['titolo'] as String;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkshopSelectionPage(
                      servizioSelezionato: servizioScelto,
                      cashbackDisponibile: widget.cashbackDisponibile,
                      onBookingConfirmed: widget.onBookingConfirmed,
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF4A1519), width: 1.5), // Bordo rosso scuro sottile come nel mockup
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF0A0A0A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Vedi disponibilità',
                style: TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.w600, 
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
