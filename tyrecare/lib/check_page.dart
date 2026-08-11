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
      color: const Color(0xFF161616),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: selected ? Colors.redAccent : Colors.transparent),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => onVeicoloSelezionato(index),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              SizedBox(width: 44, height: 34, child: Image.asset('assets/auto.png', fit: BoxFit.contain)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(vehicle.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)), Text('${vehicle.targa} · ${vehicle.anno}', style: const TextStyle(color: Colors.grey))])),
              if (selected) const Chip(label: Text('Selezionato')),
            ]),
            const Divider(height: 24),
            Text(inspection == null ? 'Nessun controllo registrato' : 'Ultimo controllo: ${_date(inspection.date)} · ${inspection.workshopName}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 8),
            Align(alignment: Alignment.centerRight, child: TextButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(veicolo: vehicle))),
              icon: const Icon(Icons.description_outlined),
              label: const Text('SCHEDA TECNICA'),
            )),
          ]),
        ),
      ),
    );
  }

  String _date(DateTime value) => '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
  void _showInfo(BuildContext context) => showDialog(context: context, builder: (_) => const AlertDialog(title: Text('Associazione veicolo'), content: Text('Chiedi alla tua officina affiliata di associare il veicolo al tuo account TyreCare.')));
}
