import 'package:flutter/material.dart';

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Impostazioni app', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
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
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF161616).withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.5),
              ),
              child: Column(
                children: [
                  _buildSettingTile(Icons.language_rounded, 'Lingua', 'Italiano'),
                  _buildDivider(),
                  _buildSettingTile(Icons.straighten_rounded, 'Unità di misura', 'Bar / Celsius'),
                  _buildDivider(),
                  _buildSettingTile(Icons.security_rounded, 'Privacy e Sicurezza', ''),
                  _buildDivider(),
                  _buildSettingTile(Icons.info_outline_rounded, 'Versione app', '1.0.0 (Build 42)'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey, size: 22),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value.isNotEmpty) Text(value, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
        ],
      ),
      onTap: () {},
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.white.withOpacity(0.05), height: 1, indent: 50);
  }
}
