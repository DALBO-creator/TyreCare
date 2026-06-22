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
  final List<String> _posizioni = ['Ant. sx', 'Ant. dx', 'Post. sx', 'Post. dx'];

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
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
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
                // IMMAGINE RUOTA REALISTICA IN PRIMO PIANO
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF252525),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.album_outlined, 
                      size: 110, 
                      color: Colors.white70
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // BARRA DI USURA BATTISTRADA PROGRESSIVA
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

                // GRIGLIA SPECIFICHE STRUTTURATA
                _buildRigaSpec('Pressione attuale', '${p.pressioneBase} bar'),
                _buildRigaSpec('Temperatura', '${p.temperatura} °C'),
                _buildRigaSpec('Chilometri percorsi', '${(12500 + widget.kmSlider).toInt()} km'),
                _buildRigaSpec('Prossimo controllo consigliato', 'tra 1.200 km'),
                const SizedBox(height: 30),

                // BOTTONE STORICO CONTROLLI
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