import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'my_data_page.dart';
import 'notifications_page.dart';
import 'app_settings_page.dart';
import 'help_support_page.dart';
import 'auth_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Profilo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.grey),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // SEZIONE INTESTAZIONE (AVATAR E INFO)
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.redAccent.withOpacity(0.5), width: 2),
                    image: const DecorationImage(
                      image: NetworkImage('https://i.pravatar.cc/300'), // Avatar d'esempio
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Alberto Rossi',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'alberto.rossi@email.com',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),

            // LISTA FUNZIONI (STILE LIQUID GLASS)
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF161616).withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.5),
              ),
              child: Column(
                children: [
                  _buildProfileTile(context, Icons.person_outline, 'I miei dati', const MyDataPage()),
                  _buildDivider(),
                  _buildProfileTile(context, Icons.notifications_none_rounded, 'Notifiche', const NotificationsPage()),
                  _buildDivider(),
                  _buildProfileTile(context, Icons.settings_suggest_outlined, 'Impostazioni app', const AppSettingsPage()),
                  _buildDivider(),
                  _buildProfileTile(context, Icons.help_outline_rounded, 'Aiuto e supporto', const HelpSupportPage()),
                  _buildDivider(),
                  _buildProfileTile(context, Icons.logout_rounded, 'Esci', null, color: Colors.redAccent, showArrow: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(BuildContext context, IconData icon, String title, Widget? targetPage, {Color color = Colors.white, bool showArrow = true}) {
    return ListTile(
      leading: Icon(icon, color: color.withOpacity(0.8), size: 22),
      title: Text(title, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: showArrow ? const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14) : null,
      onTap: () {
        if (targetPage != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage));
        } else if (title == 'Esci') {
          // Logica logout (opzionale: mostra dialogo)
          _mostraDialogoLogout(context);
        }
      },
    );
  }

  void _mostraDialogoLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF161616),
        title: const Text('Logout', style: TextStyle(color: Colors.white)),
        content: const Text('Sei sicuro di voler uscire da TyreCare?', style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ANNULLA', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              await AuthService().signOut();
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('ESCI', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.white.withOpacity(0.05), height: 1, indent: 50);
  }
}
