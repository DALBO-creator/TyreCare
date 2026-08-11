import 'package:flutter/material.dart';
import 'models.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key, required this.records});

  final List<ServiceRecord> records;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Storico interventi')),
      body: records.isEmpty
          ? const Center(child: Text('Nessun intervento registrato'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: records.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final record = records[index];
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF4A1519),
                      child: Icon(_serviceIcon(record.title), color: Colors.redAccent),
                    ),
                    title: Text(record.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text('${_date(record.date)} • ${record.workshopName}\n${record.mileage} km'),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
    );
  }

  IconData _serviceIcon(String title) {
    final normalized = title.toLowerCase();
    if (normalized.contains('cambio')) return Icons.autorenew_rounded;
    if (normalized.contains('bilanc') || normalized.contains('sicurezza')) return Icons.verified_outlined;
    if (normalized.contains('riparazione')) return Icons.build_outlined;
    return Icons.receipt_long_outlined;
  }

  String _date(DateTime date) => '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
