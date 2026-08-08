import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'app_settings_page.dart';
import 'help_support_page.dart';
import 'my_data_page.dart';
import 'notifications_page.dart';

/// Customer account area. Technical vehicle data is managed by the workshop;
/// the customer can manage only account, communication and privacy preferences.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, this.isDemo = true});

  final bool isDemo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profilo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _accountHeader(),
          const SizedBox(height: 24),
          _section(
            'Il mio account',
            [
              _tile(context, Icons.person_outline, 'Dati personali', 'Contatti e informazioni del profilo', const MyDataPage()),
              _tile(context, Icons.notifications_none_rounded, 'Notifiche', 'Appuntamenti, controlli e promemoria', const NotificationsPage()),
            ],
          ),
          const SizedBox(height: 20),
          _section(
            'La mia officina',
            [
              ListTile(
                leading: const Icon(Icons.storefront_outlined, color: Colors.redAccent),
                title: const Text('PneusHub Travagliato'),
                subtitle: const Text('Officina affiliata di riferimento'),
                trailing: const Icon(Icons.verified_outlined, color: Colors.greenAccent),
                onTap: () => _workshopInfo(context),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.car_repair_outlined),
                title: const Text('Associazione veicoli'),
                subtitle: const Text('Gestita dall’officina affiliata'),
                trailing: const Icon(Icons.info_outline, size: 20),
                onTap: () => _vehicleInfo(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _section(
            'Privacy e assistenza',
            [
              _tile(context, Icons.tune_outlined, 'Impostazioni app', 'Lingua, unità di misura e preferenze', const AppSettingsPage()),
              _tile(context, Icons.help_outline_rounded, 'Aiuto e supporto', 'Contatta TyreCare o la tua officina', const HelpSupportPage()),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Dati e consenso'),
                subtitle: const Text('Come vengono utilizzati i tuoi dati'),
                onTap: () => _privacyInfo(context),
              ),
            ],
          ),
          if (isDemo) ...[
            const SizedBox(height: 24),
            const Card(
              color: Color(0xFF161616),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(children: [
                  Icon(Icons.visibility_outlined, color: Colors.orangeAccent),
                  SizedBox(width: 12),
                  Expanded(child: Text('Stai usando la modalità demo. I dati mostrati non sono collegati al gestionale dell’officina.', style: TextStyle(color: Colors.grey))),
                ]),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _accountHeader() => Card(
        color: const Color(0xFF161616),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(children: [
            const CircleAvatar(radius: 30, backgroundColor: Color(0xFF4A1519), child: Icon(Icons.person, size: 34, color: Colors.white)),
            const SizedBox(width: 16),
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Il tuo account TyreCare', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              SizedBox(height: 4),
              Text('I tuoi veicoli e controlli in un unico posto', style: TextStyle(color: Colors.grey)),
            ])),
          ]),
        ),
      );

  Widget _section(String title, List<Widget> children) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PremiumSectionTitle(title),
        const SizedBox(height: 8),
        Card(color: const Color(0xFF161616), child: Column(children: children)),
      ]);

  Widget _tile(BuildContext context, IconData icon, String title, String subtitle, Widget page) => ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      );

  void _workshopInfo(BuildContext context) => _show(context, 'Officina associata', 'La tua officina può aggiornare controlli, interventi e veicoli associati. Per modificare l’officina di riferimento contatta il supporto TyreCare.');
  void _vehicleInfo(BuildContext context) => _show(context, 'Associazione veicoli', 'Per garantire dati corretti, i veicoli vengono associati al tuo account dall’officina dopo la verifica della targa.');
  void _privacyInfo(BuildContext context) => _show(context, 'Dati e consenso', 'TyreCare visualizza i dati tecnici condivisi dalla tua officina affiliata per offrirti storico, promemoria e richieste di appuntamento.');
  void _show(BuildContext context, String title, String message) => showDialog(context: context, builder: (_) => AlertDialog(title: Text(title), content: Text(message), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('CHIUDI'))]));
}
