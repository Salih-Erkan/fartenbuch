import 'package:fartenbuch/src/features/auth/presentation/password_changed_screen.dart';
import 'package:fartenbuch/src/features/auth/presentation/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  bool _passwordVisible1 = false;
  bool _passwordVisible2 = false;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Passwort setzen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Erstelle ein neues Passwort.',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            Image.asset('assets/images/set_password.png', height: 180),
            const SizedBox(height: 40),

            // Neues Passwort
            TextField(
              controller: _passwordController,
              obscureText: !_passwordVisible1,
              decoration: InputDecoration(
                labelText: 'Passwort eingeben',
                hintText: 'Passwort',
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible1
                        ? FontAwesomeIcons.eyeSlash
                        : FontAwesomeIcons.eye,
                    size: 16,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible1 = !_passwordVisible1;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Passwort bestätigen
            TextField(
              controller: _confirmController,
              obscureText: !_passwordVisible2,
              decoration: InputDecoration(
                labelText: 'Passwort bestätigen',
                hintText: 'Passwort',
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible2
                        ? FontAwesomeIcons.eyeSlash
                        : FontAwesomeIcons.eye,
                    size: 16,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible2 = !_passwordVisible2;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final pass1 = _passwordController.text;
                  final pass2 = _confirmController.text;
                  if (pass1 == pass2 && pass1.length >= 6) {
                    // Erfolg: Weiterleiten oder speichern
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Passwort gesetzt")),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PasswordChangedScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Passwörter stimmen nicht überein"),
                      ),
                    );
                  }
                },
                child: const Text('Passwort zurücksetzen'),
              ),
            ),
            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                'Später setzen?',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
