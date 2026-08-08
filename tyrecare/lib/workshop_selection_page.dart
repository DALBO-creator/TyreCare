// lib/workshop_selection_page.dart
import 'package:flutter/material.dart';
import 'dart:math';

class WorkshopSelectionPage extends StatefulWidget {
  final String servizioSelezionato;
  final double cashbackDisponibile;
  final Function(Map<String, dynamic>) onBookingConfirmed;

  const WorkshopSelectionPage({
    super.key, 
    required this.servizioSelezionato,
    required this.cashbackDisponibile,
    required this.onBookingConfirmed,
  });

  @override
  State<WorkshopSelectionPage> createState() => _WorkshopSelectionPageState();
}

class _WorkshopSelectionPageState extends State<WorkshopSelectionPage> {
  int? _indiceOfficinaSelezionata;
  DateTime? _dataSelezionata;
  String? _orarioSelezionato;
  bool _usaCashback = false;

  final List<Map<String, String>> _officine = [
    {'nome': 'PneusHub Travagliato', 'indirizzo': 'Via Roma 12, Travagliato'},
    {'nome': 'Master Driver Brescia Ovest', 'indirizzo': 'Via Milano 45, Brescia'},
    {'nome': 'Garage iperGomme Castegnato', 'indirizzo': 'Via Brescia 101, Castegnato'},
  ];

  final List<String> _orariDisponibili = [
    '08:30', '09:30', '10:30', '11:30', '14:30', '15:30', '16:30', '17:30'
  ];

  Future<void> _selezionaData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.redAccent,
              onPrimary: Colors.white,
              surface: Color(0xFF161616),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _dataSelezionata) {
      setState(() {
        _dataSelezionata = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Seleziona Officina', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Officine affiliate Tyrecare',
              style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),

            // LISTA OFFICINE
            ...List.generate(_officine.length, (index) {
              final officina = _officine[index];
              final isSelezionata = _indiceOfficinaSelezionata == index;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF161616),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelezionata ? Colors.redAccent : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: ListTile(
                  onTap: () => setState(() => _indiceOfficinaSelezionata = index),
                  title: Text(officina['nome']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text(officina['indirizzo']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  trailing: Icon(
                    isSelezionata ? Icons.check_circle : Icons.circle_outlined,
                    color: isSelezionata ? Colors.redAccent : Colors.grey,
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),

            // SELEZIONE DATA
            const Text(
              'Quando desideri l\'intervento?',
              style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _selezionaData(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF161616),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 16),
                    Text(
                      _dataSelezionata == null 
                        ? 'Seleziona una data' 
                        : '${_dataSelezionata!.day}/${_dataSelezionata!.month}/${_dataSelezionata!.year}',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // SELEZIONE ORARIO (Solo se la data è selezionata)
            if (_dataSelezionata != null) ...[
              const Text(
                'Orari disponibili',
                style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _orariDisponibili.map((ora) {
                  final isSelezionato = _orarioSelezionato == ora;
                  return InkWell(
                    onTap: () => setState(() => _orarioSelezionato = ora),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelezionato ? Colors.redAccent : const Color(0xFF161616),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        ora,
                        style: TextStyle(
                          color: isSelezionato ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 24),

            // OPZIONE RISCATTO CASHBACK
            if (widget.cashbackDisponibile > 0) ...[
              const Text(
                'Opzioni preventivo',
                style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF161616),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _usaCashback ? Colors.greenAccent.withValues(alpha: 0.5) : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: SwitchListTile(
                  value: _usaCashback,
                  onChanged: (val) => setState(() => _usaCashback = val),
                  activeThumbColor: Colors.greenAccent,
                  title: const Text('Usa il tuo cashback', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text('Saldo disponibile: € ${widget.cashbackDisponibile.toStringAsFixed(2)}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  secondary: const Icon(Icons.stars_rounded, color: Colors.amber),
                ),
              ),
            ],

            const SizedBox(height: 40),

            // BOTTONE PRENOTA
            ElevatedButton(
              onPressed: (_indiceOfficinaSelezionata != null && _dataSelezionata != null && _orarioSelezionato != null)
                  ? () {
                      final randomCashback = 5 + Random().nextInt(6); // 5-10 euro
                      
                      // Se usa cashback, creiamo un movimento di uscita prima di quello di entrata (gestito nel main)
                      if (_usaCashback) {
                        widget.onBookingConfirmed({
                          'titolo': 'Riscatto Cashback preventivo',
                          'officina': _officine[_indiceOfficinaSelezionata!]['nome'],
                          'data': '${_dataSelezionata!.day} ${_ottieniMese(_dataSelezionata!.month)} ${_dataSelezionata!.year}',
                          'importo': '-€ ${widget.cashbackDisponibile.toStringAsFixed(2)}',
                          'tipo': 'speso',
                          'cashbackValue': -widget.cashbackDisponibile,
                          'isDiscount': true,
                        });
                      }

                      final nuovaAttivita = {
                        'titolo': widget.servizioSelezionato,
                        'officina': _officine[_indiceOfficinaSelezionata!]['nome'],
                        'data': '${_dataSelezionata!.day} ${_ottieniMese(_dataSelezionata!.month)} ${_dataSelezionata!.year}',
                        'importo': '+€ ${randomCashback.toStringAsFixed(2)}',
                        'tipo': 'guadagno',
                        'cashbackValue': randomCashback.toDouble(),
                        'isDiscount': false,
                      };
                      
                      widget.onBookingConfirmed(nuovaAttivita);
                      
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: const Color(0xFF161616),
                          title: const Text('Prenotazione Confermata', style: TextStyle(color: Colors.white)),
                          content: Text(
                            _usaCashback 
                              ? 'La tua prenotazione è stata inviata con lo sconto cashback applicato.\n\nHai guadagnato altri € ${randomCashback.toStringAsFixed(2)}!'
                              : 'La tua prenotazione per ${widget.servizioSelezionato} è stata inviata.\n\nHai guadagnato € ${randomCashback.toStringAsFixed(2)} di cashback!',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Chiude dialog
                                Navigator.pop(context); // Torna alla booking page
                              },
                              child: const Text('OK', style: TextStyle(color: Colors.redAccent)),
                            ),
                          ],
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                disabledBackgroundColor: Colors.grey[800],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Prenota e richiedi preventivo',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _ottieniMese(int mese) {
    const mesi = [
      'Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno',
      'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre'
    ];
    return mesi[mese - 1];
  }
}
