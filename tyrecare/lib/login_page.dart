import 'package:flutter/material.dart';
import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
        child: Column(
          children: [
            // LOGO
            Image.asset('assets/logoTyreCare.png', height: 80),
            const SizedBox(height: 40),
            
            Text(
              isLogin ? 'Accedi a TyreCare' : 'Crea un account',
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              isLogin ? 'Inserisci le tue credenziali per continuare' : 'Registrati per iniziare a monitorare la tua auto',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 40),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  // EMAIL FIELD
                  _buildTextField(
                    hint: 'Email',
                    icon: Icons.email_outlined,
                    onChanged: (val) => setState(() => email = val),
                    validator: (val) => val!.isEmpty ? 'Inserisci un\'email' : null,
                  ),
                  const SizedBox(height: 20),
                  
                  // PASSWORD FIELD
                  _buildTextField(
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    onChanged: (val) => setState(() => password = val),
                    validator: (val) => val!.length < 6 ? 'Password di almeno 6 caratteri' : null,
                  ),
                  
                  const SizedBox(height: 20),
                  if (error.isNotEmpty)
                    Text(error, style: const TextStyle(color: Colors.redAccent, fontSize: 14)),
                  
                  const SizedBox(height: 30),
                  
                  // BOTTONE LOGIN/REGISTRAZIONE
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: loading ? null : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => loading = true);
                          try {
                            if (isLogin) {
                              await _auth.signInWithEmailAndPassword(email, password);
                            } else {
                              await _auth.registerWithEmailAndPassword(email, password);
                            }
                          } catch (e) {
                            setState(() {
                              error = 'Credenziali non valide o errore di rete';
                              loading = false;
                            });
                          }
                        }
                      },
                      child: loading 
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(isLogin ? 'ACCEDI' : 'REGISTRATI', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // SWITCH LOGIN / REGISTER
                  TextButton(
                    onPressed: () => setState(() {
                      isLogin = !isLogin;
                      error = '';
                    }),
                    child: Text(
                      isLogin ? 'Non hai un account? Registrati' : 'Hai già un account? Accedi',
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    required Function(String) onChanged,
    required String? Function(String?) validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: TextFormField(
        obscureText: isPassword,
        onChanged: onChanged,
        validator: validator,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: Colors.grey, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
