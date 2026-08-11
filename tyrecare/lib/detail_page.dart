import 'package:flutter/material.dart';
import 'models.dart';

/// Technical sheet shown to the customer. Values are read-only because they
/// are certified and updated by the affiliated workshop.
class DetailPage extends StatelessWidget {
  const DetailPage({
    super.key,
    required this.veicolo,
    this.posizioneIniziale = 'antSx',
    this.kmSlider = 0,
    this.transazioni = const [],
  });

  final Veicolo veicolo;
  final String posizioneIniziale;
  // Legacy parameters retained temporarily to avoid breaking old routes.
  final double kmSlider;
  final List<Map<String, dynamic>> transazioni;

  @override
  Widget build(BuildContext context) {
    final inspection = veicolo.ultimoControllo;
    return Scaffold(
      appBar: AppBar(title: const Text('Scheda pneumatici')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _vehicleHeader(),
          const SizedBox(height: 16),
          _inspectionCard(inspection),
          const SizedBox(height: 24),
          const Text('Rilevazioni per ruota', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...veicolo.pneumatici.map(_tyreCard),
          const SizedBox(height: 16),
          const Text(
            'I valori sono rilevati dall’officina durante il controllo. Per aggiornamenti o anomalie, prenota un appuntamento.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _vehicleHeader() => Card(
        color: const Color(0xFF161616),
        child: ListTile(
          leading: const Icon(Icons.directions_car_filled_outlined, color: Colors.redAccent),
          title: Text(veicolo.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('${veicolo.targa} · ${veicolo.chilometriIniziali} km'),
        ),
      );

  Widget _inspectionCard(TyreInspection? inspection) => Card(
        color: const Color(0xFF161616),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: inspection == null
              ? const Text('Nessun controllo certificato disponibile.')
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('ULTIMO CONTROLLO CERTIFICATO', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(inspection.workshopName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  Text('${_date(inspection.date)} · ${inspection.mileage} km', style: const TextStyle(color: Colors.grey)),
                  if (inspection.note.isNotEmpty) ...[const SizedBox(height: 8), Text(inspection.note)],
                ]),
        ),
      );

  Widget _tyreCard(Pneumatico tyre) => Card(
        color: const Color(0xFF161616),
        margin: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(Icons.tire_repair, color: _color(tyre.condizione)),
              const SizedBox(width: 10),
              Expanded(child: Text(_position(tyre.posizione), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              Text(_status(tyre.condizione), style: TextStyle(color: _color(tyre.condizione), fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              SizedBox(width: 38, height: 38, child: Image.asset('assets/cerchioneTyreCare.png', fit: BoxFit.contain)),
            ]),
            const Divider(height: 24),
            _row('Pneumatico', '${tyre.marca} ${tyre.modello}'),
            _row('Misura', tyre.misura),
            _row('Battistrada', '${tyre.battistradaMm.toStringAsFixed(1)} mm'),
            _row('Pressione rilevata', '${tyre.pressioneBase.toStringAsFixed(1)} bar'),
            _row('DOT', tyre.dot),
          ]),
        ),
      );

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(children: [Expanded(child: Text(label, style: const TextStyle(color: Colors.grey))), Text(value)]),
      );
  String _date(DateTime value) => '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
  String _position(String value) => {'antSx': 'Anteriore sinistra', 'antDx': 'Anteriore destra', 'postSx': 'Posteriore sinistra', 'postDx': 'Posteriore destra'}[value] ?? value;
  String _status(TyreCondition value) => value == TyreCondition.excellent ? 'Ottimo' : value == TyreCondition.monitor ? 'Monitorare' : 'Attenzione';
  Color _color(TyreCondition value) => value == TyreCondition.excellent ? Colors.greenAccent : value == TyreCondition.monitor ? Colors.orangeAccent : Colors.redAccent;
}
