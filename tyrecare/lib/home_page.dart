// lib/home_page.dart
import 'package:flutter/material.dart';
import 'models.dart';

class HomePage extends StatelessWidget {
  final Veicolo veicolo;
  final double cashbackAttuale;
  final double kmSlider; // <-- Nuovo parametro ricevuto dal MainContainer
  final List<String> listaNomiVeicoli;
  final Function(String) onAutoCambiata;

  const HomePage({
    super.key,
    required this.veicolo,
    required this.cashbackAttuale,
    required this.kmSlider,
    required this.listaNomiVeicoli,
    required this.onAutoCambiata,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: veicolo.nome,
            dropdownColor: const Color(0xFF2D2D2D),
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            items: listaNomiVeicoli.map((String nome) {
              return DropdownMenuItem<String>(value: nome, child: Text(nome));
            }).toList(),
            onChanged: (nuovoNome) {
              if (nuovoNome != null) onAutoCambiata(nuovoNome);
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // BOX INFO AUTO DINAMICO
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.directions_car, size: 50, color: Colors.grey),
                    const SizedBox(height: 10),
                    Text(
                      veicolo.nome,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    // Calcola dinamicamente i km totali basandosi sullo slider!
                    Text(
                      '${veicolo.chilometriTotali(kmSlider)} km totali',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // CARD STATO GENERALE (Calcolato con lo slider)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Stato generale pneumatici', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(height: 8),
                      Text(
                        '${veicolo.mediaUsuraGenerale(kmSlider)}%', // Media dinamica!
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const Text('Ottimo stato', style: TextStyle(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFF1E1E1E),
                    child: Icon(Icons.pie_chart_rounded, color: Colors.greenAccent),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // CARD CASHBACK
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet_outlined, color: Colors.amber, size: 28),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Cashback Accumulato', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(
                        '€ ${cashbackAttuale.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // GRIGLIA LOGICA RUOTE CONSUMATE IN DIRETTA
            const Text('Pressione e Usura singole ruote', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _buildCardRuota('Ant. SX', veicolo.antSx),
                _buildCardRuota('Ant. DX', veicolo.antDx),
                _buildCardRuota('Post. SX', veicolo.postSx),
                _buildCardRuota('Post. DX', veicolo.postDx),
              ],
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('PRENOTA UN CONTROLLO', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardRuota(String posizione, Pneumatico pneumatico) {
    // Calcoliamo l'usura specifica per questa ruota in base ai chilometri percorsi
    int usuraCorrente = pneumatico.calcolaUsuraDinamica(kmSlider);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(posizione, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${pneumatico.pressioneBase} bar', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              Icon(
                Icons.circle, 
                size: 10, 
                color: usuraCorrente > 70 ? Colors.greenAccent : (usuraCorrente > 50 ? Colors.orangeAccent : Colors.redAccent)
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Usura: $usuraCorrente%', style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }
}