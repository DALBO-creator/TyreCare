// lib/detail_page.dart
import 'package:flutter/material.dart';
import 'models.dart';

class DetailPage extends StatefulWidget {
  final Veicolo veicolo;
  final String posizioneIniziale;
  final double kmSlider;
  final List<Map<String, dynamic>> transazioni;

  const DetailPage({
    super.key,
    required this.veicolo,
    required this.posizioneIniziale,
    required this.kmSlider,
    required this.transazioni,
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
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Dettaglio pneumatico',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        centerTitle: true,
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
          indicatorWeight: 2,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // IMMAGINE RUOTA REALISTICA (RIDOTTA PER FAR SALIRE LA CARD)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // GRADIENTE DI SFONDO ULTRA-SMOOTH (LEGGERMENTE PIÙ SCURO)
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 0.8,
                          colors: [
                            const Color(0xFF141414).withValues(alpha: 0.35), // Sfumatura centrale scurita
                            const Color(0xFF0E0E0E).withValues(alpha: 0.15), // Sfumatura intermedia scurita
                            const Color(0xFF0A0A0A), // Sfondo finale
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                    // CERCHIONE ZOOMMATO
                    Image.asset(
                      'assets/cerchioneTyreCare.png',
                      width: MediaQuery.of(context).size.width * 1.05, // Leggermente ridotto lo zoom
                      height: 280, // Ridotta altezza da 380 a 280
                      fit: BoxFit.contain,
                    ),
                  ],
                ),

                // CONTENUTO INFERIORE CON PADDING
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0), // Rimosso padding top per far salire la card
                  child: Column(
                    children: [
                      // CARD PRINCIPALE INFO (STILE LIQUID GLASS)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF161616).withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 0.5),
                        ),
                        child: Column(
                          children: [
                            _buildRigaInfoProgressiva('Usura battistrada', '$usura%', usura / 100, coloreStato),
                            const SizedBox(height: 16),
                            _buildRigaInfoProgressiva('Pressione attuale', '${p.pressioneBase} bar', (p.pressioneBase / 3.0).clamp(0, 1), coloreStato),
                            const SizedBox(height: 16),
                            _buildRigaInfoSemplice('Temperatura', '${p.temperatura} °C'),
                            const SizedBox(height: 16),
                            _buildRigaInfoSemplice('Chilometri percorsi', '${(12500 + widget.kmSlider).toInt()} km'),
                            const SizedBox(height: 16),
                            _buildRigaInfoSemplice('Prossimo controllo consigliato', 'tra 1.200 km'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // BOTTONE STORICO CONTROLLI
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => _mostraStoricoControlli(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFF161616).withValues(alpha: 0.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('STORICO CONTROLLI', 
                            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRigaInfoProgressiva(String titolo, String valore, double progress, Color colore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(titolo, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            Text(valore, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            valueColor: AlwaysStoppedAnimation<Color>(colore),
          ),
        ),
      ],
    );
  }

  Widget _buildRigaInfoSemplice(String titolo, String valore) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(titolo, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(valore, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _mostraStoricoControlli(BuildContext context) {
    // Filtriamo solo i "guadagni" (prenotazioni/interventi) ed escludiamo i riscatti cashback se vogliamo solo lo storico tecnico
    final controlli = widget.transazioni.where((t) => t['isDiscount'] != true && t['tipo'] == 'guadagno').toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0A0A0A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const Text(
                    'Storico controlli',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  if (controlli.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text('Nessun controllo registrato', style: TextStyle(color: Colors.grey)),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: controlli.length,
                        itemBuilder: (context, index) {
                          final c = controlli[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF161616).withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 0.5),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        c['titolo'], 
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        c['officina'], 
                                        style: const TextStyle(color: Colors.grey, fontSize: 11),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  c['data'], 
                                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
