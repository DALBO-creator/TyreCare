import 'package:flutter/material.dart';

class WalletPage extends StatelessWidget {
  final double saldoAttuale;
  const WalletPage({super.key, required this.saldoAttuale});

  @override
  Widget build(BuildContext context) {
    // Dati per il progresso del livello (Gamification)
    const int puntiAttuali = 135;
    const int puntiNecessari = 200;
    const double percentualeProgresso = puntiAttuali / puntiNecessari;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text('Wallet', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. CARD SALDO CASHBACK
    Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Saldo Cashback Accumulato',
            style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Text(
            '€ ${saldoAttuale.toStringAsFixed(2)}', // <-- Sostituito qui!
            style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.greenAccent),
          ),
        ],
      ),
    ),
            
            const SizedBox(height: 20),
            
            // 2. CARD LIVELLI DI FIDELIZZAZIONE
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.withAlpha(40), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.stars_rounded, color: Colors.amber, size: 28),
                          SizedBox(width: 10),
                          Text(
                            'Livello Silver',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withAlpha(30),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'PROSSIMO: GOLD',
                          style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Mancano 65 punti per sbloccare i vantaggi Gold',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  
                  // Barra di Avanzamento Livello
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: const LinearProgressIndicator(
                            value: percentualeProgresso,
                            backgroundColor: Color(0xFF1E1E1E),
                            color: Colors.amber,
                            minHeight: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '$puntiAttuali / $puntiNecessari XP',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(color: Color(0xFF1E1E1E)),
                  ),
                  
                  // Elenco vantaggi attivi e bloccati
                  const Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 18),
                      SizedBox(width: 8),
                      Text('Bonus Cashback attuale: +5%', style: TextStyle(fontSize: 13, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.lock_outline, color: Colors.grey[600], size: 18),
                      SizedBox(width: 8),
                      const Text('Vantaggio Gold: Moltiplicatore Cashback +10%', style: TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 3. SEZIONE TRANSAZIONI RECENTI (Senza Expanded conflittuali)
            const Text(
              'Transazioni Recenti',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            
            ListView.builder(
              itemCount: 5,
              physics: const NeverScrollableScrollPhysics(), // Demanda lo scroll alla SingleChildScrollView del body
              shrinkWrap: true, // Dice alla listview di occupare solo lo spazio verticale dei suoi elementi
              itemBuilder: (context, index) {
                final bool isGuadagno = index % 2 == 0; 
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2D2D),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF1E1E1E),
                      child: Icon(
                        isGuadagno ? Icons.add_card_rounded : Icons.shopping_bag_outlined, 
                        color: isGuadagno ? Colors.greenAccent : Colors.redAccent,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      isGuadagno ? 'Cashback Ricevuto' : 'Riscatto Sconto Officina', 
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text(
                      'Transazione #${index + 1} • +15 XP', 
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    trailing: Text(
                      isGuadagno ? '+€ ${(index + 1) * 5}.00' : '-€ ${(index + 1) * 4}.00',
                      style: TextStyle(
                        color: isGuadagno ? Colors.greenAccent : Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}