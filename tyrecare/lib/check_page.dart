import 'package:flutter/material.dart';
import 'detail_page.dart';
import 'models.dart';

/// Garage is retained as the customer’s vehicle archive, not as a duplicate
/// dashboard. It is the place to select a vehicle and open its certified data.
class CheckPage extends StatelessWidget {
  const CheckPage({
    super.key,
    required this.veicoli,
    required this.indicePrincipale,
    required this.onVeicoloSelezionato,
  });

  final List<Veicolo> veicoli;
  final int indicePrincipale;
  final ValueChanged<int> onVeicoloSelezionato;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('I miei veicoli')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('I dati tecnici e i controlli sono aggiornati dalle officine affiliate.', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          ...List.generate(veicoli.length, (index) => _vehicleCard(context, veicoli[index], index == indicePrincipale, index)),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _showInfo(context),
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('RICHIEDI ASSOCIAZIONE VEICOLO'),
          ),
        ],
      ),
    );
  }

  Widget _vehicleCard(BuildContext context, Veicolo vehicle, bool selected, int index) {
    final inspection = vehicle.ultimoControllo;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: selected ? Colors.redAccent : const Color(0xFF2A2E37)),
      ),
      child: InkWell(
        onTap: () => onVeicoloSelezionato(index),
        child: SizedBox(
          height: 180,
          child: Stack(children: [
            Positioned(right: -14, bottom: -15, child: Opacity(opacity: .55, child: Image.asset('assets/auto.png', width: 245, fit: BoxFit.contain))),
            Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(colors: [const Color(0xFF14161B), const Color(0xFF14161B).withValues(alpha: .82), Colors.transparent])))),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  const Icon(Icons.directions_car_filled_outlined, color: Colors.redAccent, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(vehicle.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                  if (selected) const Chip(label: Text('Selezionato')),
                ]),
                const SizedBox(height: 4),
                Text('${vehicle.targa} · ${vehicle.anno}', style: const TextStyle(color: Colors.grey)),
                const Spacer(),
                SizedBox(width: 190, child: Text(inspection == null ? 'Nessun controllo registrato' : 'Controllo: ${_date(inspection.date)}\n${inspection.workshopName}', style: const TextStyle(color: Colors.grey, fontSize: 12))),
                const SizedBox(height: 8),
                TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: Colors.redAccent, padding: EdgeInsets.zero),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(veicolo: vehicle))),
                  icon: const Icon(Icons.description_outlined, size: 18),
                  label: const Text('SCHEDA TECNICA'),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  String _date(DateTime value) => '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
  void _showInfo(BuildContext context) => showDialog(context: context, builder: (_) => const AlertDialog(title: Text('Associazione veicolo'), content: Text('Chiedi alla tua officina affiliata di associare il veicolo al tuo account TyreCare.')));
}
