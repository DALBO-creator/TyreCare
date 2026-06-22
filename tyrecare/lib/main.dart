// Porzione corretta da inserire nello stato principale del tuo Main / Navigation Wrapper
import 'package:flutter/material.dart';
import 'models.dart';
import 'home_page.dart';
import 'check_page.dart';

class MainStateWrapper extends StatefulWidget {
  const MainStateWrapper({super.key});

  @override
  State<MainStateWrapper> createState() => _MainStateWrapperState();
}

class _MainStateWrapperState extends State<MainStateWrapper> {
  final double _cashbackGlobale = 35.0;
  double _kmSimulatiDalloSlider = 0.0;
  int _indiceAutoSelezionata = 0;

  final List<Veicolo> _veicoliDisponibili = [
    const Veicolo(
      id: 'veicolo_1',
      nome: 'BMW Serie 3',
      chilometriBase: 43800,
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

  Veicolo get _veicoloCorrente => _veicoliDisponibili[_indiceAutoSelezionata];

  List<Widget> _ottieniPagine() {
    return [
      HomePage(
        veicolo: _veicoloCorrente,
        cashbackAttuale: _cashbackGlobale,
        kmSlider: _kmSimulatiDalloSlider,
        listaNomiVeicoli: _veicoliDisponibili.map((v) => v.nome).toList(),
        onAutoCambiata: (nuovoNome) {
          setState(() {
            _indiceAutoSelezionata = _veicoliDisponibili.indexWhere((v) => v.nome == nuovoNome);
            _kmSimulatiDalloSlider = 0.0; // Reset slider al cambio auto
          });
        },
        onKmVariati: (nuoviKm) {
          setState(() {
            _kmSimulatiDalloSlider = nuoviKm;
          });
        },
      ),
      CheckPage(
        listaVeicoli: _veicoliDisponibili,
        idVeicoloCorrente: _veicoloCorrente.id,
        onAutoSelezionataDalGarage: (nomeSelezionato) {
          setState(() {
            _indiceAutoSelezionata = _veicoliDisponibili.indexWhere((v) => v.nome == nomeSelezionato);
            _kmSimulatiDalloSlider = 0.0;
          });
        },
      ),
      // Puoi inserire qui le altre pagine come WalletPage() e ProfiloPage()
      const Scaffold(body: Center(child: Text('Wallet', style: TextStyle(color: Colors.white)))),
      const Scaffold(body: Center(child: Text('Profilo', style: TextStyle(color: Colors.white)))),
    ];
  }

  int _currentBottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentBottomNavIndex,
        children: _ottieniPagine(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        backgroundColor: const Color(0xFF151515),
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Auto'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profilo'),
        ],
      ),
    );
  }
}