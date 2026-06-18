import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String? selectedDate;
  String? selectedTime;

  final List<Map<String, String>> nearbyShops = [
    {
      'name': 'Gommista Centro',
      'address': 'Via Roma 123, Milano',
      'distance': '1.2 km',
      'rating': '4.8',
    },
    {
      'name': 'Officina Marco',
      'address': 'Corso Buenos Aires 456, Milano',
      'distance': '2.5 km',
      'rating': '4.6',
    },
    {
      'name': 'Auto Service Rossi',
      'address': 'Via Torino 789, Milano',
      'distance': '3.1 km',
      'rating': '4.5',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prenota Controllo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Officine Vicine',
              style: theme.textTheme.displayMedium?.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 12),
            ...nearbyShops.map((shop) => _ShopCard(shop: shop)),
            const SizedBox(height: 24),
            
            Text(
              'Seleziona Data e Ora',
              style: theme.textTheme.displayMedium?.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 12),
            
            // Date Selection
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Seleziona data'),
                subtitle: Text(selectedDate ?? 'Nessuna data selezionata'),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (date != null) {
                    setState(() {
                      selectedDate = '${date.day}/${date.month}/${date.year}';
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
            
            // Time Selection
            Card(
              child: ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Seleziona ora'),
                subtitle: Text(selectedTime ?? 'Nessuna ora selezionata'),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      selectedTime = time.format(context);
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: selectedDate != null && selectedTime != null
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Prenotazione effettuata!'),
                          ),
                        );
                      }
                    : null,
                child: const Text('CONFERMA PRENOTAZIONE'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopCard extends StatelessWidget {
  final Map<String, String> shop;

  const _ShopCard({required this.shop});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    shop['name']!,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        shop['rating']!,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              shop['address']!,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Distanza: ${shop['distance']}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('Prenota'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
