import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class SplashPage extends StatefulWidget {
  final String? nomeUtente;
  final String modelloAuto;
  final VoidCallback onFinish;

  const SplashPage({
    super.key,
    this.nomeUtente,
    required this.modelloAuto,
    required this.onFinish,
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _dotsController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Controller per l'apparizione del testo
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    // Controller per l'animazione dei 3 puntini
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _fadeController.forward();

    // Simulazione caricamento di 3.5 secondi prima di passare alla Home
    Timer(const Duration(milliseconds: 4000), () {
      if (mounted) widget.onFinish();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  double _getDotOpacity(int index) {
    // Calcola l'opacità basata sul valore del controller e l'indice del puntino
    // Crea un effetto di scorrimento/onda
    double progress = _dotsController.value;
    double offset = index / 3.0;
    double value = math.sin((progress - offset) * 2 * math.pi);
    return (value + 1) / 2; // Normalizza tra 0 e 1
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Sfondo con gradiente radiale premium
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [
                  const Color(0xFF1A1A1A).withValues(alpha: 0.4),
                  const Color(0xFF0A0A0A),
                ],
              ),
            ),
          ),
          
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // LOGO IN ALTO (Stile Liquid Glass con centratura corretta)
                    Container(
                      width: 120, // Dimensione fissa per garantire simmetria perfetta
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFF161616).withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                      ),
                      child: Center(
                        child: Transform.translate(
                          offset: const Offset(1, 0), // Piccolissimo spostamento a destra per correggere il peso visivo
                          child: Image.asset(
                            'assets/logoTyreCare.png',
                            height: 70,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    
                    // MESSAGGIO DI BENVENUTO PERSONALIZZATO
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 24,
                          letterSpacing: -0.8,
                          color: Colors.white,
                        ),
                        children: [
                          const TextSpan(
                            text: "Bentornato in ",
                          ),
                          TextSpan(
                            text: "TyreCare",
                            style: TextStyle(
                              color: Colors.redAccent.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const TextSpan(
                            text: ", ",
                          ),
                          TextSpan(
                            text: widget.nomeUtente ?? "Utente",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // MESSAGGIO AUTO (Aggiornato: è in ottime condizioni)
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(text: "La tua "),
                          TextSpan(
                            text: widget.modelloAuto,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const TextSpan(text: " è in ottime condizioni"),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 80),
                    
                    // ANIMAZIONE 3 PUNTINI BIANCHI (Loading)
                    AnimatedBuilder(
                      animation: _dotsController,
                      builder: (context, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1 + (0.9 * _getDotOpacity(index))),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  if (_getDotOpacity(index) > 0.8)
                                    BoxShadow(
                                      color: Colors.white.withValues(alpha: 0.3),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    )
                                ],
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
