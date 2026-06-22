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