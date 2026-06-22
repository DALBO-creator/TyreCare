// lib/main.dart
import 'package:flutter/material.dart';
import 'models.dart';
import 'home_page.dart';
import 'check_page.dart';
import 'booking_page.dart';
import 'wallet_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TyreCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.red),
      home: const MainContainer(),
    );
  }
}

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _indiceSelezionato = 0;
  final double _cashbackGlobale = 150.00; 

  // LA NOSTRA VARIABILE STATO DELLO SLIDER ADESSO È QUI!
  double _kmSimulatiDalloSlider = 0.0;

  final List<Veicolo> _veicoliDisponibili = [
    const Veicolo(
      id: 'veicolo_1',
      nome: 'BMW Serie 3',
      chilometriBase: 43800, // km all'ultimo controllo
      kmUltimoControllo: 43800,
      kmProssimoControlloTarget: 1200, 
      antSx: Pneumatico(modello: 'Pirelli P Zero', pressioneBase: 2.4, usuraIniziale: 90, temperatura: 28),
      antDx: Pneumatico(modello: 'Pirelli P Zero', pressioneBase: 2.5, usuraIniziale: 95, temperatura: 29),
      postSx: Pneumatico(modello: 'Pirelli P Zero', pressioneBase: 2.3, usuraIniziale: 85, temperatura: 28),
      postDx: Pneumatico(modello: 'Pirelli P Zero', pressioneBase: 2.4, usuraIniziale: 92, temperatura: 28),
    ),
    const Veicolo(
      id: 'veicolo_2',
      nome: 'Audi A3',
      chilometriBase: 80000,
      kmUltimoControllo: 80000,
      kmProssimoControlloTarget: 3000,
      antSx: Pneumatico(modello: 'Michelin Pilot Sport', pressioneBase: 2.2, usuraIniziale: 65, temperatura: 25),
      antDx: Pneumatico(modello: 'Michelin Pilot Sport', pressioneBase: 2.2, usuraIniziale: 67, temperatura: 25),
      postSx: Pneumatico(modello: 'Michelin Pilot Sport', pressioneBase: 2.1, usuraIniziale: 60, temperatura: 24),
      postDx: Pneumatico(modello: 'Michelin Pilot Sport', pressioneBase: 2.1, usuraIniziale: 62, temperatura: 24),
    ),
  ];

  int _indiceAutoSelezionata = 0;
  Veicolo get _veicoloCorrente => _veicoliDisponibili[_indiceAutoSelezionata];

  List<Widget> _ottieniPagine() {
    return [
      HomePage(
        veicolo: _veicoloCorrente,
        cashbackAttuale: _cashbackGlobale,
        kmSlider: _kmSimulatiDalloSlider, // <-- Passiamo i km correnti
        listaNomiVeicoli: _veicoliDisponibili.map((v) => v.nome).toList(),
        onAutoCambiata: (nuovoNome) {
          setState(() {
            _indiceAutoSelezionata = _veicoliDisponibili.indexWhere((v) => v.nome == nuevoNome);
            _kmSimulatiDalloSlider = 0.0; // Resettiamo lo slider se cambia auto
          });
        },
      ),
      CheckPage(
        veicolo: _veicoloCorrente,
        kmSlider: _kmSimulatiDalloSlider, // <-- Passiamo i km correnti
        onKmVariati: (nuoviKm) {
          setState(() {
            _kmSimulatiDalloSlider = nuoviKm; // <-- Aggiorna lo stato globale!
          });
        },
      ), 
      const BookingPage(),
      WalletPage(saldoAttuale: _cashbackGlobale), 
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _indiceSelezionato, children: _ottieniPagine()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceSelezionato,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _indiceSelezionato = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Auto'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Prenota'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
        ],
      ),
    );
  }
}