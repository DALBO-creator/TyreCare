import 'package:flutter/material.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  final List<Map<String, String>> vehicles = [
    {
      'model': 'BMW Serie 3',
      'year': '2023',
      'mileage': '12.500 km',
      'tireType': 'Michelin Pilot',
    },
    {
      'model': 'Audi Q3',
      'year': '2021',
      'mileage': '32.500 km',
      'tireType': 'Continental',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Il Mio Garage'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vehicles.length + 1,
        itemBuilder: (context, index) {
          if (index == vehicles.length) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Aggiungi Veicolo'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            );
          }
          
          final vehicle = vehicles[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(vehicle['model']!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('Anno: ${vehicle['year']}'),
                  Text('Km: ${vehicle['mileage']}'),
                  Text('Pneumatici: ${vehicle['tireType']}'),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
