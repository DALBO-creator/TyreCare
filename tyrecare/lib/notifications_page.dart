import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _pushEnabled = true;
  bool _emailEnabled = false;
  bool _smsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Notifiche', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preferenze di ricezione',
              style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF161616).withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.5),
              ),
              child: Column(
                children: [
                  _buildSwitchTile('Notifiche Push', 'Ricevi avvisi sullo stato gomme', _pushEnabled, (v) => setState(() => _pushEnabled = v)),
                  _buildDivider(),
                  _buildSwitchTile('Email', 'Ricevi riepiloghi mensili', _emailEnabled, (v) => setState(() => _emailEnabled = v)),
                  _buildDivider(),
                  _buildSwitchTile('SMS', 'Avvisi urgenti per appuntamenti', _smsEnabled, (v) => setState(() => _smsEnabled = v)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeColor: Colors.redAccent,
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.white.withOpacity(0.05), height: 1, indent: 16, endIndent: 16);
  }
}
