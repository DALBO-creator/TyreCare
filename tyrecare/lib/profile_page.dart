import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'app_settings_page.dart';
import 'help_support_page.dart';
import 'my_data_page.dart';
import 'models.dart';
import 'notifications_page.dart';

/// Customer account area. Technical vehicle data is managed by the workshop;
/// the customer can manage only account, communication and privacy preferences.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, this.appointments = const []});
  final List<Appointment> appointments;

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
          _appointmentsSection(context),
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

  Widget _appointmentsSection(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PremiumSectionTitle('I miei appuntamenti'),
        const SizedBox(height: 8),
        Card(
          child: appointments.isEmpty
              ? const ListTile(
                  leading: Icon(Icons.calendar_month_outlined),
                  title: Text('Nessun appuntamento richiesto'),
                  subtitle: Text('Prenota un servizio dalla sezione Prenota.'),
                )
              : Column(
                  children: appointments.map((appointment) => ListTile(
                    leading: const CircleAvatar(backgroundColor: Color(0xFF4A1519), child: Icon(Icons.schedule_outlined, color: Colors.redAccent)),
                    title: Text(appointment.service, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text('${_date(appointment.preferredDate)} · ${appointment.preferredTime}\n${appointment.workshopName}'),
                    isThreeLine: true,
                    trailing: const Text('IN ATTESA', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.w800, fontSize: 10)),
                    onTap: () => _appointmentInfo(context, appointment),
                  )).toList(),
                ),
        ),
      ]);

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

  String _date(DateTime value) => '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
  void _appointmentInfo(BuildContext context, Appointment appointment) => _show(context, 'Richiesta appuntamento', 'Hai richiesto ${appointment.service} per il ${_date(appointment.preferredDate)} alle ${appointment.preferredTime}. L’officina deve ancora confermare l’appuntamento.');
  void _workshopInfo(BuildContext context) => _show(context, 'Officina associata', 'La tua officina può aggiornare controlli, interventi e veicoli associati. Per modificare l’officina di riferimento contatta il supporto TyreCare.');
  void _vehicleInfo(BuildContext context) => _show(context, 'Associazione veicoli', 'Per garantire dati corretti, i veicoli vengono associati al tuo account dall’officina dopo la verifica della targa.');
  void _privacyInfo(BuildContext context) => _show(context, 'Dati e consenso', 'TyreCare visualizza i dati tecnici condivisi dalla tua officina affiliata per offrirti storico, promemoria e richieste di appuntamento.');
  void _show(BuildContext context, String title, String message) => showDialog(context: context, builder: (_) => AlertDialog(title: Text(title), content: Text(message), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('CHIUDI'))]));
}
