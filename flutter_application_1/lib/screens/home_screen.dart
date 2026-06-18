import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('TyreCare'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Benvenuto in TyreCare!',
                      style: theme.textTheme.displayMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'La tua BMW Serie 3 è in ottime condizioni',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Tire Health Status
            Text(
              'Stato Generale Pneumatici',
              style: theme.textTheme.displayMedium?.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.withValues(alpha: 0.1),
                      ),
                      child: Center(
                        child: Text(
                          '87%',
                          style: theme.textTheme.displayLarge?.copyWith(
                            color: Colors.green,
                            fontSize: 36,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Usura media',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _TireStatusItem('ANT SX', '85%'),
                        _TireStatusItem('ANT DX', '85%'),
                        _TireStatusItem('POST SX', '90%'),
                        _TireStatusItem('POST DX', '88%'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Last Maintenance
            Text(
              'Ultimo Controllo',
              style: theme.textTheme.displayMedium?.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '12 Marzo 2024',
                            style: theme.textTheme.bodyLarge,
                          ),
                          Text(
                            'Prossimo: tra 1.200 km',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Call to Action
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {},
                child: const Text('PRENOTA UN CONTROLLO'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TireStatusItem extends StatelessWidget {
  final String label;
  final String percentage;

  const _TireStatusItem(this.label, this.percentage);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Text(
          percentage,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
