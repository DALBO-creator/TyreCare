// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'app_theme.dart';
import 'models.dart';
import 'home_page.dart';
import 'check_page.dart';
import 'booking_page.dart';
import 'history_page.dart';
import 'profile_page.dart';
import 'splash_page.dart';
import 'login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var isFirebaseAvailable = true;
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // Firebase is optional for the local demo and for platforms that have not
    // yet been configured through FlutterFire.
    isFirebaseAvailable = false;
  }

  runApp(MyApp(isFirebaseAvailable: isFirebaseAvailable));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.isFirebaseAvailable = true});

  final bool isFirebaseAvailable;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TyreCare',
      debugShowCheckedModeBanner: false,
      theme: tyreCareTheme(),
      home: isFirebaseAvailable
          ? const AuthWrapper()
          : const FirebaseConfigurationPage(),
    );
  }
}

class FirebaseConfigurationPage extends StatelessWidget {
  const FirebaseConfigurationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_outlined,
                color: Colors.redAccent,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'Configurazione Firebase non disponibile',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'L’accesso con account richiede Firebase per questa piattaforma.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const MainContainer(isDemo: true)),
                    );
                  },
                  icon: const Icon(Icons.visibility_outlined),
                  label: const Text('CONTINUA IN MODALITÀ DEMO'),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Configura Firebase con FlutterFire per abilitare accesso e registrazione.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
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
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.redAccent)),
          );
        }
        return snapshot.hasData ? const Initializer() : const LoginPage();
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
        nomeUtente: user?.displayName ?? user?.email?.split('@')[0] ?? 'Utente',
        modelloAuto: 'BMW Serie 3',
        onFinish: () => setState(() => _showSplash = false),
      );
    }
    return const MainContainer();
  }
}

class MainContainer extends StatefulWidget {
  const MainContainer({super.key, this.isDemo = false});

  final bool isDemo;

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _indiceSelezionato = 0;
  final List<Veicolo> _veicoliDisponibili = [
    Veicolo(
      nome: 'BMW Serie 3',
      anno: '2019',
      targa: 'GA123BC',
      chilometriIniziali: '43800',
      immagineUrl:
          'https://images.pngimages.com/download/0b18f8e0d6da7e923e1e9a26372bf9dc.png',
      isPrincipale: true,
      ultimoControllo: TyreInspection(id: 'inspection-1', date: DateTime(2026, 8, 2), workshopName: 'PneusHub Travagliato', mileage: 43800, note: 'Pressioni verificate. Nessuna anomalia rilevata.'),
      antSx: Pneumatico(posizione: 'antSx', pressioneBase: 2.4, usuraBase: 90, temperatura: 28, marca: 'Pirelli', modello: 'Cinturato All Season', misura: '225/45 R17', dot: '1424', battistradaMm: 6.2, condizione: TyreCondition.excellent),
      antDx: Pneumatico(posizione: 'antDx', pressioneBase: 2.5, usuraBase: 95, temperatura: 29, marca: 'Pirelli', modello: 'Cinturato All Season', misura: '225/45 R17', dot: '1424', battistradaMm: 6.0, condizione: TyreCondition.excellent),
      postSx: Pneumatico(posizione: 'postSx', pressioneBase: 2.3, usuraBase: 85, temperatura: 28, marca: 'Pirelli', modello: 'Cinturato All Season', misura: '225/45 R17', dot: '1424', battistradaMm: 5.4, condizione: TyreCondition.excellent),
      postDx: Pneumatico(posizione: 'postDx', pressioneBase: 2.4, usuraBase: 92, temperatura: 28, marca: 'Pirelli', modello: 'Cinturato All Season', misura: '225/45 R17', dot: '1424', battistradaMm: 5.5, condizione: TyreCondition.excellent),
    ),
    Veicolo(
      nome: 'Audi A3',
      anno: '2021',
      targa: 'HD456EF',
      chilometriIniziali: '80000',
      immagineUrl:
          'https://images.pngimages.com/download/0b18f8e0d6da7e923e1e9a26372bf9dc.png',
      isPrincipale: false,
      ultimoControllo: TyreInspection(id: 'inspection-2', date: DateTime(2026, 7, 18), workshopName: 'PneusHub Travagliato', mileage: 80000, note: 'Controllo stagionale completato.'),
      antSx: Pneumatico(posizione: 'antSx', pressioneBase: 2.2, usuraBase: 65, temperatura: 25, marca: 'Michelin', modello: 'Primacy 4', misura: '205/55 R16', dot: '3522', battistradaMm: 3.4, condizione: TyreCondition.monitor),
      antDx: Pneumatico(posizione: 'antDx', pressioneBase: 2.2, usuraBase: 67, temperatura: 25, marca: 'Michelin', modello: 'Primacy 4', misura: '205/55 R16', dot: '3522', battistradaMm: 3.3, condizione: TyreCondition.monitor),
      postSx: Pneumatico(posizione: 'postSx', pressioneBase: 2.1, usuraBase: 60, temperatura: 24, marca: 'Michelin', modello: 'Primacy 4', misura: '205/55 R16', dot: '3522', battistradaMm: 3.1, condizione: TyreCondition.monitor),
      postDx: Pneumatico(posizione: 'postDx', pressioneBase: 2.1, usuraBase: 62, temperatura: 24, marca: 'Michelin', modello: 'Primacy 4', misura: '205/55 R16', dot: '3522', battistradaMm: 3.2, condizione: TyreCondition.monitor),
    ),
  ];

  int _indiceAutoSelezionata = 0;
  Veicolo get _veicoloCorrente => _veicoliDisponibili[_indiceAutoSelezionata];

  final List<Appointment> _appuntamenti = [];

  final List<ServiceRecord> _storicoInterventi = [
    ServiceRecord(id: 'service-1', title: 'Cambio gomme stagionale', date: DateTime(2026, 5, 14), workshopName: 'PneusHub Travagliato', mileage: 43800, note: 'Controllo completo eseguito'),
    ServiceRecord(id: 'service-2', title: 'Controllo sicurezza e bilanciatura', date: DateTime(2026, 4, 22), workshopName: 'Master Driver Brescia Ovest', mileage: 43200),
  ];

  List<Widget> _ottieniPagine() => [
    HomePage(
      veicolo: _veicoloCorrente,
      veicoli: _veicoliDisponibili,
      onAutoCambiata: (targa) => setState(() => _indiceAutoSelezionata = _veicoliDisponibili.indexWhere((item) => item.targa == targa)),
      onTabCambiato: (index) => setState(() => _indiceSelezionato = index),
    ),
    CheckPage(
      veicoli: _veicoliDisponibili,
      indicePrincipale: _indiceAutoSelezionata,
      onVeicoloSelezionato: (index) => setState(() => _indiceAutoSelezionata = index),
    ),
    BookingPage(
      onBookingConfirmed: (request) {
        setState(() {
          _appuntamenti.insert(0, Appointment(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            service: request['service'] as String,
            workshopName: request['workshop'] as String,
            preferredDate: request['preferredDate'] as DateTime,
            preferredTime: request['preferredTime'] as String,
            status: AppointmentStatus.requested,
            note: request['note'] as String,
          ));
        });
      },
    ),
    HistoryPage(records: _storicoInterventi),
    ProfilePage(isDemo: widget.isDemo, appointments: _appuntamenti),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _indiceSelezionato, children: _ottieniPagine()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceSelezionato,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _indiceSelezionato = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Auto'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Prenota'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Storico'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profilo'),
        ],
      ),
    );
  }
}
