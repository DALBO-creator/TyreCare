// lib/wallet_page.dart
import 'package:flutter/material.dart';

class WalletPage extends StatelessWidget {
  final double saldoAttuale;
  final List<Map<String, dynamic>> transazioni;

  const WalletPage({
    super.key, 
    required this.saldoAttuale, 
    required this.transazioni,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text('Wallet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // CARD CASHBACK IN STILE MINIMAL PREMIUM
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF252525), // Stesso grigio scuro coerente delle card del mockup
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF4A1519).withOpacity(0.4), // Un leggero accenno del tuo rosso scuro sul bordo
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'CASHBACK ACCUMULATO',
                        style: TextStyle(
                          color: Colors.grey, 
                          fontSize: 11, 
                          fontWeight: FontWeight.bold, 
                          letterSpacing: 1.2
                        ),
                      ),
                      Icon(Icons.stars_rounded, color: Colors.redAccent.withOpacity(0.8), size: 20),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '€ ${saldoAttuale.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 38, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white,
                      letterSpacing: -0.5
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Pronto per essere scalato dal tuo prossimo intervento',
                    style: TextStyle(
                      color: Colors.grey[400], 
                      fontSize: 12, 
                      fontStyle: FontStyle.italic
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            const Text(
              'Attività recente',
              style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),

            // LISTA MOVIMENTI COMPLETAMENTE ALLINEATA AL LOOK DEL MOCKUP
            Expanded(
              child: transazioni.isEmpty 
                ? const Center(child: Text('Nessuna attività recente', style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    itemCount: transazioni.length,
                    itemBuilder: (context, index) {
                      final t = transazioni[index];
                      final isGuadagno = t['tipo'] == 'guadagno';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF252525),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          title: Text(
                            t['titolo'] as String,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              '${t['officina']} • ${t['data']}',
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ),
                          trailing: Text(
                            t['importo'] as String,
                            style: TextStyle(
                              color: isGuadagno ? Colors.greenAccent : Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
