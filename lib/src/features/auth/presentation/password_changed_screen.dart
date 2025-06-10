import 'package:fartenbuch/src/features/home/presentation/fahr_anlass_screen.dart';
import 'package:flutter/material.dart';

class PasswordChangedScreen extends StatelessWidget {
  const PasswordChangedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Passwort geändert'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Passwort erfolgreich geändert!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 60),
            Image.asset('assets/images/password_changed.png', height: 180),
            const SizedBox(height: 30),
            const Text(
              'Dein Passwort wurde erfolgreich zurückgesetzt',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 15),

            const Text(
              'Erfolgreich!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Alles zurücksetzen und zur Welcome-Seite springen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => FahranlassScreen()),
                    (route) => false,
                  );
                },
                child: const Text('Weiter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
