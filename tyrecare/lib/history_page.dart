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
                  color: const Color(0xFF161616),
                  child: ListTile(
                    leading: const Icon(Icons.build_circle_outlined, color: Colors.redAccent),
                    title: Text(record.title),
                    subtitle: Text('${_date(record.date)} • ${record.workshopName}\n${record.mileage} km'),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }

  String _date(DateTime date) => '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
