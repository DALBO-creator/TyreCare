import 'package:flutter/material.dart';
import 'home_page.dart';
import 'check_page.dart';
import 'booking_page.dart';
import 'wallet_page.dart';

void main() {
  runApp(const TyrecareApp());
}

class TyrecareApp extends StatelessWidget {
  const TyrecareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tyrecare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        useMaterial3: true,
      ),
      home: const MainContainer(), // <-- Cambiato qui!
    );
  }
}

// Questo è il contenitore principale con la barra di navigazione inferiore
class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _indiceSelezionato = 0;
  
  // 1. Spostiamo la variabile globale dell'auto qui nel padre!
  String _autoGlobale = 'BMW Serie 3';
  final double _cashbackGlobale = 150.00;

  // 2. Usiamo una funzione o un metodo getter per aggiornare le pagine in tempo reale
  List<Widget> _ottieniPagine() {
    return [
      HomePage(
        autoCorrente: _autoGlobale,
        // 2. Passiamo il saldo reale alla Home
        cashbackAttuale: _cashbackGlobale, 
        onAutoCambiata: (nuovaAuto) {
          setState(() {
            _autoGlobale = nuovaAuto;
          });
        },
      ),
      CheckPage(nomeVeicolo: _autoGlobale), 
      const BookingPage(),
      // 3. Passiamo lo stesso identico saldo al Wallet
      WalletPage(saldoAttuale: _cashbackGlobale), 
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Chiamiamo il metodo per generare le pagine con i dati freschi
      body: _ottieniPagine()[_indiceSelezionato],
      
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.blueAccent.withAlpha(51),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _indiceSelezionato,
          backgroundColor: const Color(0xFF1E1E1E),
          elevation: 8,
          onDestinationSelected: (int index) {
            setState(() {
              _indiceSelezionato = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: Colors.blueAccent),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.directions_car_outlined),
              selectedIcon: Icon(Icons.directions_car, color: Colors.blueAccent),
              label: 'Auto',
            ),
            NavigationDestination(
              icon: Icon(Icons.build_circle_outlined),
              selectedIcon: Icon(Icons.build_circle, color: Colors.blueAccent),
              label: 'Prenota',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              selectedIcon: Icon(Icons.account_balance_wallet, color: Colors.blueAccent),
              label: 'Wallet',
            ),
          ],
        ),
      ),
    );
  }
}