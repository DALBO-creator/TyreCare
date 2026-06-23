import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Aiuto e supporto', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Come possiamo aiutarti?',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF161616).withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.5),
              ),
              child: Column(
                children: [
                  _buildSupportTile(Icons.chat_bubble_outline_rounded, 'Chat con l\'assistenza', 'Tempo di attesa: 2 min'),
                  _buildDivider(),
                  _buildSupportTile(Icons.email_outlined, 'Inviaci un\'email', 'support@tyrecare.com'),
                  _buildDivider(),
                  _buildSupportTile(Icons.phone_outlined, 'Chiamaci', '+39 02 1234567'),
                  _buildDivider(),
                  _buildSupportTile(Icons.help_outline_rounded, 'Domande frequenti (FAQ)', ''),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Documenti legali',
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
                  _buildSupportTile(Icons.description_outlined, 'Termini e condizioni', ''),
                  _buildDivider(),
                  _buildSupportTile(Icons.lock_outline_rounded, 'Informativa sulla privacy', ''),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.redAccent, size: 22),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)) : null,
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
      onTap: () {},
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.white.withOpacity(0.05), height: 1, indent: 50);
  }
}
