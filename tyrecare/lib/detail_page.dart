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
        title: const Text('Dettaglio Sensore', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.redAccent,
          labelColor: Colors.redAccent,
          unselectedLabelColor: Colors.grey,
          tabs: _posizioni.map((pos) => Tab(text: pos.toUpperCase())).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _posizioni.map((pos) {
          Pneumatico p = _getPneumaticoDaPosizione(pos);
          int usura = p.calcolaUsuraDinamica(widget.kmSlider);

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(color: Color(0xFF252525), shape: BoxShape.circle),
                    child: const Icon(Icons.album_outlined, size: 100, color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Modello: ${p.modello}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(color: Colors.grey),
                const SizedBox(height: 10),
                _buildInfoRow('Pressione:', '${p.pressioneBase} bar'),
                _buildInfoRow('Temperatura:', '${p.temperatura}°C'),
                _buildInfoRow('Usura Battistrada:', '$usura%'),
                _buildInfoRow('Stato Sensore:', 'Attivo / Sincronizzato'),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}