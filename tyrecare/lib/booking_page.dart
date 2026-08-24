import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'models.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({
    super.key,
    this.cashbackDisponibile = 0,
    this.onBookingConfirmed,
  });

  // Deprecated compatibility parameters: loyalty is not part of the booking flow.
  final double cashbackDisponibile;
  final Future<void> Function(Map<String, dynamic>)? onBookingConfirmed;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  static const _services = <String>[
    'Controllo pneumatici',
    'Cambio gomme stagionale',
    'Equilibratura',
    'Convergenza',
    'Riparazione pneumatico',
    'Deposito gomme',
  ];
  final _notesController = TextEditingController();
  String _service = _services.first;
  DateTime? _date;
  String? _time;
  bool _isSubmitting = false;
  final String _workshop = 'La Santi Gomme';

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _date != null && _time != null && !_isSubmitting;
    return Scaffold(
      appBar: AppBar(title: const Text('Richiedi un appuntamento')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Prenota in pochi passaggi', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text('Invia una richiesta alla tua officina. La data sarà confermata dall’operatore.', style: TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 24),
          _section('Officina associata', Card(
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              height: 104,
              child: Stack(children: [
                Positioned(right: 0, top: 0, bottom: 0, width: 155, child: Image.asset('assets/officina.png', fit: BoxFit.cover)),
                Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(colors: [const Color(0xFF14161B), const Color(0xFF14161B).withValues(alpha: .82), Colors.transparent])))),
                Positioned(
                  left: 0,
                  top: 0,
                  right: 155,
                  bottom: 0,
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(left: 16, right: 4),
                    leading: const Icon(Icons.storefront_outlined, color: Colors.redAccent),
                    title: Text(_workshop, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Officina affiliata TyreCare'),
                  ),
                ),
              ]),
            ),
          )),
          _section('Servizio richiesto', DropdownButtonFormField<String>(
            initialValue: _service,
            dropdownColor: const Color(0xFF161616),
            items: _services.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
            onChanged: (value) => setState(() => _service = value!),
            decoration: _decoration(),
          )),
          _section('Preferenza di data', InkWell(
            onTap: _pickDate,
            child: InputDecorator(decoration: _decoration(), child: Row(children: [const Icon(Icons.calendar_today_outlined, size: 20), const SizedBox(width: 12), Text(_date == null ? 'Seleziona una data' : _formatDate(_date!))])),
          )),
          if (_date != null) _section('Fascia oraria preferita', Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['09:00', '10:30', '14:30', '16:00', '17:30'].map((item) => ChoiceChip(label: Text(item), selected: _time == item, onSelected: (_) => setState(() => _time = item))).toList(),
          )),
          _section('Note per l’officina', TextField(
            controller: _notesController,
            maxLines: 4,
            maxLength: 300,
            decoration: _decoration().copyWith(hintText: 'Es. vibrazione durante la guida, richiesta controllo pressione…'),
          )),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: canSubmit ? _submit : null,
            child: const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Text('INVIA RICHIESTA')),
          ),
          const SizedBox(height: 12),
          const Text('Riceverai una notifica quando l’officina confermerà o modificherà l’appuntamento.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _section(String title, Widget child) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [PremiumSectionTitle(title), const SizedBox(height: 8), child]),
      );
  InputDecoration _decoration() => const InputDecoration();
  Future<void> _pickDate() async {
    final result = await showDatePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 180)), initialDate: _date ?? DateTime.now().add(const Duration(days: 1)));
    if (result != null) setState(() { _date = result; _time = null; });
  }
  String _formatDate(DateTime value) => '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
  Future<void> _submit() async {
    final selectedDate = _date;
    final selectedTime = _time;
    if (selectedDate == null || selectedTime == null || _isSubmitting) return;

    setState(() => _isSubmitting = true);
    try {
      await widget.onBookingConfirmed?.call({
        'service': _service,
        'workshop': _workshop,
        'preferredDate': selectedDate,
        'preferredTime': selectedTime,
        'note': _notesController.text,
        'status': AppointmentStatus.requested.name,
      });
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Richiesta inviata'),
          content: Text('La richiesta per $_service è stata inviata a $_workshop. Riceverai la conferma dell’officina.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      setState(() {
        _date = null;
        _time = null;
        _notesController.clear();
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossibile inviare la richiesta: $error')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
