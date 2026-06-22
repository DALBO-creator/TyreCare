// lib/detail_page.dart
import 'package:flutter/material.dart';
import 'models.dart';

class DetailPage extends StatefulWidget {
  final Veicolo veicolo;
  final String posizioneIniziale;
  final double kmSlider;

  const DetailPage({
    super.key,
    required this.veicolo,
    required this.posizioneIniziale,
    required this.kmSlider,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _posizioni = ['ant. sx', 'ant. dx', 'post. sx', 'post. dx'];

  @override
  void initState() {
    super.initState();
    int indexIniziale = _posizioni.indexOf(widget.posizioneIniziale.toLowerCase());
    if (indexIniziale == -1) indexIniziale = 0;
    _tabController = TabController(length: 4, vsync: this, initialIndex: indexIniziale);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Pneumatico _getPneumaticoDaPosizione(String pos) {
    switch (pos) {
      case 'ant. dx': return widget.veicolo.antDx;
      case 'post. sx': return widget.veicolo.postSx;
      case 'post. dx': return widget.veicolo.postDx;
      default: return widget.veicolo.antSx;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text('Dettaglio pneumatico', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          indicatorColor: Colors.redAccent,
          labelColor: Colors.redAccent,
          unselectedLabelColor: Colors.grey,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          tabs: _posizioni.map((pos) => Tab(text: pos.toUpperCase())).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _posizioni.map((pos) {
          Pneumatico p = _getPneumaticoDaPosizione(pos);
          int usura = p.calcolaUsuraDinamica(widget.kmSlider);
          Color coloreStato = usura > 70 ? Colors.greenAccent : (usura > 50 ? Colors.orangeAccent : Colors.redAccent);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 180,
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        'https://images.unsplash.com/photo-1580273916550-e323be2ae537?q=80&w=400&auto=format&fit=crop', 
                        fit: BoxFit.contain,
                      ),
                      Positioned(
                        top: 60,
                        left: 110,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.redAccent.withOpacity(0.8), blurRadius: 8, spreadRadius: 2)],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                const Text('Usura battistrada', style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: usura / 100,
                          minHeight: 6,
                          backgroundColor: Colors.grey[800],
                          valueColor: AlwaysStoppedAnimation<Color>(coloreStato),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('$usura%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 24),

                _buildRigaSpec('Modello copertura', p.modello),
                _buildRigaSpec('Pressione attuale', '${p.pressioneBase} bar'),
                _buildRigaSpec('Temperatura esercizio', '${p.temperatura} °C'),
                _buildRigaSpec('Chilometri totali', '${(widget.veicolo.chilometriBase + widget.kmSlider).toInt()} km'),
                _buildRigaSpec('Target prossimo controllo', 'tra ${widget.veicolo.kmProssimoControlloTarget} km'),
                const SizedBox(height: 30),

                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[800]!),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('STORICO CONTROLLI', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRigaSpec(String titolo, String valore) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[900]!, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titolo, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(valore, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}