import 'package:fartenbuch/src/features/auth/presentation/verification_screen_passwort.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text("Passwort vergessen?"),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          spacing: 5,

          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Keine Sorge, wir helfen dir weiter.',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/passwort_vergessen.png',
                    height: 200,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Wir senden dir einen Code, um dein Passwort zurückzusetzen.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            const TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'E-Mail-Adresse',
                labelText: 'E-Mail-Adresse eingeben',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VerificationScreen(),
                    ),
                  );
                },
                child: const Text('Code senden'),
              ),
            ),
            const Spacer(),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pop(context); // zurück zum Login
                },
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Zurück zum Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
