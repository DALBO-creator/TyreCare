import 'package:flutter/material.dart';

class MyDataPage extends StatelessWidget {
  const MyDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('I miei dati', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
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
          children: [
            _buildDataCard(
              children: [
                _buildDataTile('Nome', 'Alberto'),
                _buildDivider(),
                _buildDataTile('Cognome', 'Rossi'),
                _buildDivider(),
                _buildDataTile('Email', 'alberto.rossi@email.com'),
                _buildDivider(),
                _buildDataTile('Telefono', '+39 333 1234567'),
              ],
            ),
            const SizedBox(height: 24),
            _buildDataCard(
              children: [
                _buildDataTile('Indirizzo', 'Via Roma 1, Brescia'),
                _buildDivider(),
                _buildDataTile('Città', 'Brescia'),
                _buildDivider(),
                _buildDataTile('CAP', '25100'),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('MODIFICA DATI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161616).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 0.5),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDataTile(String label, String value) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
      subtitle: Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.white.withValues(alpha: 0.05), height: 1, indent: 16, endIndent: 16);
  }
}
