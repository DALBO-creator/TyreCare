import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'detail_page.dart';
import 'models.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.veicolo,
    required this.veicoli,
    required this.onAutoCambiata,
    required this.onTabCambiato,
  });

  final Veicolo veicolo;
  final List<Veicolo> veicoli;
  final ValueChanged<String> onAutoCambiata;
  final ValueChanged<int> onTabCambiato;

  @override
  Widget build(BuildContext context) {
    final inspection = veicolo.ultimoControllo;
    final tyres = veicolo.pneumatici;
    final minTread = tyres.map((tyre) => tyre.battistradaMm).reduce((a, b) => a < b ? a : b);
    final condition = _conditionFor(minTread);

    return Scaffold(
      appBar: AppBar(
        title: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: veicolo.targa,
            dropdownColor: const Color(0xFF161616),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            items: veicoli.map((item) => DropdownMenuItem(value: item.targa, child: Text('${item.nome} · ${item.targa}'))).toList(),
            onChanged: (value) {
              if (value != null) onAutoCambiata(value);
            },
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('TYRECARE', style: TextStyle(color: Color(0xFFFF646A), fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.6)),
          const SizedBox(height: 6),
          Text('La tua mobilità,\nsempre sotto controllo.', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, height: 1.1)),
          const SizedBox(height: 18),
          _vehicleHero(),
          const SizedBox(height: 22),
          const PremiumSectionTitle('Stato certificato'),
          const SizedBox(height: 8),
          Text(
            inspection == null ? 'In attesa del primo controllo in officina' : 'Aggiornato il ${_date(inspection.date)} da ${inspection.workshopName}',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          _statusCard(context, minTread, condition, inspection),
          const SizedBox(height: 24),
          const PremiumSectionTitle('Pneumatici'),
          const SizedBox(height: 8),
          _tyresOverview(context, tyres),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => onTabCambiato(2),
            icon: const Icon(Icons.calendar_month),
            label: const Text('PRENOTA UN SERVIZIO'),
          ),

        ],
      ),
    );
  }

  Widget _vehicleHero() => Container(
        height: 142,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.surfaceRaised,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Stack(children: [
          Positioned(right: -6, bottom: -12, child: Opacity(opacity: .9, child: Image.asset('assets/auto.png', width: 230, fit: BoxFit.contain))),
          Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.surfaceRaised, AppColors.surfaceRaised.withValues(alpha: .55), Colors.transparent])))),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(veicolo.nome, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('${veicolo.targa} · ${veicolo.chilometraggio} km', style: const TextStyle(color: AppColors.textMuted)),
              const Spacer(),
              const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.verified_outlined, color: AppColors.primaryBright, size: 16), SizedBox(width: 6), Text('Veicolo associato', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))]),
            ]),
          ),
        ]),
      );

  Widget _statusCard(BuildContext context, double tread, _TyreStatus status, TyreInspection? inspection) => Card(
        color: const Color(0xFF161616),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(children: [
            Icon(status.icon, color: status.color, size: 42),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(status.label, style: TextStyle(color: status.color, fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 4),
              Text('Battistrada minimo rilevato: ${tread.toStringAsFixed(1)} mm'),
              if (inspection != null && inspection.note.isNotEmpty) ...[const SizedBox(height: 6), Text(inspection.note, style: const TextStyle(color: Colors.grey))],
            ])),
          ]),
        ),
      );

  Widget _tyresOverview(BuildContext context, List<Pneumatico> tyres) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Row(children: [
              const Expanded(child: Text('Posizione', style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.w700))),
              const SizedBox(
                width: 82,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text('BATTISTRADA', style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: .5)),
                ),
              ),
              const SizedBox(width: 76, child: Text('STATO', textAlign: TextAlign.right, style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: .5))),
            ]),
            const SizedBox(height: 6),
            const Divider(height: 1),
            ...List.generate(tyres.length, (index) {
              final tyre = tyres[index];
              return Column(children: [
                SizedBox(
                  height: 54,
                  child: Row(children: [
                    Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(_position(tyre.posizione), style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text('${tyre.marca} · ${tyre.pressioneBase.toStringAsFixed(1)} bar', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    ])),
                    SizedBox(width: 82, child: Text('${tyre.battistradaMm.toStringAsFixed(1)} mm', textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w700))),
                    SizedBox(width: 76, child: Text(_conditionLabel(tyre.condizione), textAlign: TextAlign.right, style: TextStyle(color: _color(tyre.condizione), fontSize: 12, fontWeight: FontWeight.w800))),
                  ]),
                ),
                if (index < tyres.length - 1) const Divider(height: 1),
              ]);
            }),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(veicolo: veicolo))), child: const Text('VEDI DETTAGLIO')),
            ),
          ]),
        ),
      );

  _TyreStatus _conditionFor(double tread) => tread >= 5 ? const _TyreStatus('Ottimo stato', Colors.greenAccent, Icons.verified_outlined) : tread >= 3 ? const _TyreStatus('Da monitorare', Colors.orangeAccent, Icons.visibility_outlined) : const _TyreStatus('Verifica consigliata', Colors.redAccent, Icons.warning_amber_rounded);
  Color _color(TyreCondition value) => value == TyreCondition.excellent ? Colors.greenAccent : value == TyreCondition.monitor ? Colors.orangeAccent : Colors.redAccent;
  String _conditionLabel(TyreCondition value) => value == TyreCondition.excellent ? 'Ottimo' : value == TyreCondition.monitor ? 'Monitorare' : 'Attenzione';
  String _position(String value) => {'antSx': 'Anteriore sinistra', 'antDx': 'Anteriore destra', 'postSx': 'Posteriore sinistra', 'postDx': 'Posteriore destra'}[value] ?? value;
  String _date(DateTime date) => '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

class _TyreStatus { const _TyreStatus(this.label, this.color, this.icon); final String label; final Color color; final IconData icon; }
