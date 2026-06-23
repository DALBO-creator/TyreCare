// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models.dart';
import 'home_page.dart';
import 'check_page.dart';
import 'booking_page.dart';
import 'wallet_page.dart';
import 'profile_page.dart';
import 'splash_page.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Nota: Firebase richiede la configurazione specifica per piattaforma (google-services.json / GoogleService-Info.plist)
  // Se non l'hai ancora fatta, questa riga darà errore.
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Firebase non inizializzato: assicurati di aver aggiunto i file di configurazione.");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TyreCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A0A0A),
          elevation: 0,
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.redAccent)));
        }
        if (snapshot.hasData) {
          return const Initializer();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}

class Initializer extends StatefulWidget {
  const Initializer({super.key});

  @override
  State<Initializer> createState() => _InitializerState();
}

class _InitializerState extends State<Initializer> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (_showSplash) {
      return SplashPage(
        nomeUtente: user?.displayName ?? user?.email?.split('@')[0] ?? "Utente",
        modelloAuto: "BMW Serie 3", // Modello principale
        onFinish: () {
          setState(() {
            _showSplash = false;
          });
        },
      );
    }
    return const MainContainer();
  }
}

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _indiceSelezionato = 0;
  double _cashbackGlobale = 150.00; 
  double _kmSimulatiDalloSlider = 0.0;

  final List<Map<String, dynamic>> _transazioniWallet = [
    {
      'titolo': 'Cambio gomme stagionale',
      'officina': 'PneusHub Travagliato',
      'data': '14 Maggio 2026',
      'importo': '+€ 15.00',
      'tipo': 'guadagno'
    },
    {
      'titolo': 'Controllo sicurezza & Bilanciatura',
      'officina': 'Master Driver Brescia Ovest',
      'data': '22 Aprile 2026',
      'importo': '+€ 8.50',
      'tipo': 'guadagno'
    },
    {
      'titolo': 'Riscatto Buono Sconto',
      'officina': 'Garage iperGomme Castegnato',
      'data': '10 Marzo 2026',
      'importo': '-€ 20.00',
      'tipo': 'speso'
    },
  ];

  final List<Veicolo> _veicoliDisponibili = [
    Veicolo(
      nome: 'BMW Serie 3',
      anno: '2019',
      chilometriIniziali: '43800',
      immagineUrl: 'https://images.pngimages.com/download/0b18f8e0d6da7e923e1e9a26372bf9dc.png',
      isPrincipale: true,
      antSx: Pneumatico(posizione: 'antSx', pressioneBase: 2.4, usuraBase: 90, temperatura: 28),
      antDx: Pneumatico(posizione: 'antDx', pressioneBase: 2.5, usuraBase: 95, temperatura: 29),
      postSx: Pneumatico(posizione: 'postSx', pressioneBase: 2.3, usuraBase: 85, temperatura: 28),
      postDx: Pneumatico(posizione: 'postDx', pressioneBase: 2.4, usuraBase: 92, temperatura: 28),
    ),
    Veicolo(
      nome: 'Audi A3',
      anno: '2021',
      chilometriIniziali: '80000',
      immagineUrl: 'https://images.pngimages.com/download/0b18f8e0d6da7e923e1e9a26372bf9dc.png',
      isPrincipale: false,
      antSx: Pneumatico(posizione: 'antSx', pressioneBase: 2.2, usuraBase: 65, temperatura: 25),
      antDx: Pneumatico(posizione: 'antDx', pressioneBase: 2.2, usuraBase: 67, temperatura: 25),
      postSx: Pneumatico(posizione: 'postSx', pressioneBase: 2.1, usuraBase: 60, temperatura: 24),
      postDx: Pneumatico(posizione: 'postDx', pressioneBase: 2.1, usuraBase: 62, temperatura: 24),
    ),
  ];

  int _indiceAutoSelezionata = 0;
  Veicolo get _veicoloCorrente => _veicoliDisponibili[_indiceAutoSelezionata];

  List<Widget> _ottieniPagine() {
    return [
      HomePage(
        veicolo: _veicoloCorrente,
        kmSlider: _kmSimulatiDalloSlider,
        listaNomiVeicoli: _veicoliDisponibili.map((v) => v.nome).toList(),
        transazioni: _transazioniWallet,
        onAutoCambiata: (nuovoNome) {
          setState(() {
            _indiceAutoSelezionata = _veicoliDisponibili.indexWhere((v) => v.nome == nuovoNome);
            _kmSimulatiDalloSlider = 0.0; // Resettiamo la simulazione se cambia auto
          });
        },
        onKmVariati: (nuoviKm) {
          setState(() {
            _kmSimulatiDalloSlider = nuoviKm;
          });
        },
        onTabCambiato: (index) {
          setState(() {
            _indiceSelezionato = index;
          });
        },
      ),
      CheckPage(
        veicoli: _veicoliDisponibili,
        indicePrincipale: _indiceAutoSelezionata,
        onVeicoloSelezionato: (index) {
          setState(() {
            _indiceAutoSelezionata = index;
            _kmSimulatiDalloSlider = 0.0; // Reset simulazione
          });
        },
      ), 
      BookingPage(
        cashbackDisponibile: _cashbackGlobale,
        onBookingConfirmed: (nuovaAttivita) {
          setState(() {
            _transazioniWallet.insert(0, {
              'titolo': nuovaAttivita['titolo'],
              'officina': nuovaAttivita['officina'],
              'data': nuovaAttivita['data'],
              'importo': nuovaAttivita['importo'],
              'tipo': nuovaAttivita['tipo'],
              'isDiscount': nuovaAttivita['isDiscount'] ?? false,
            });
            _cashbackGlobale += nuovaAttivita['cashbackValue'] as double;
            if (_transazioniWallet.length > 5) {
              _transazioniWallet.removeLast();
            }
          });
        },
      ),
      WalletPage(
        saldoAttuale: _cashbackGlobale,
        transazioni: _transazioniWallet,
      ),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _indiceSelezionato, children: _ottieniPagine()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceSelezionato,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0A0A0A),
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _indiceSelezionato = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Auto'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Prenota'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profilo'),
        ],
      ),
    );
  }
}
