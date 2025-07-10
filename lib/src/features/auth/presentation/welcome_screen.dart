import 'package:fartenbuch/src/features/auth/presentation/create_screen.dart';
import 'package:fartenbuch/src/features/auth/presentation/login_screen.dart';
import 'package:fartenbuch/src/features/auth/presentation/widget/guest_info_sheet.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Wilkommen',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Melde dich an oder registriere dich, um fortzufahren',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 40),

              Image.asset('assets/images/start_bild.png', height: 200),
              const SizedBox(height: 40),

              const Text(
                'Fahrtenbuch',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Behalte den Überblick über deine Fahrten – mit PDF-Export für Steuer, Arbeitgeber oder eigene Nachweise.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Jetzt einloggen',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      const SizedBox(width: 15),
                      const Icon(
                        FontAwesomeIcons.apple,
                        color: Colors.white,
                        size: 17,
                      ),
                      const SizedBox(width: 7),
                      const Icon(
                        FontAwesomeIcons.google,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 7),
                      const Icon(
                        FontAwesomeIcons.facebook,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Registrieren Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateAccountScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Jetzt registrieren',
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,

                      builder: (context) {
                        return const GuestInfoSheet();
                      },
                    );
                  },
                  child: const Text(
                    'Als Gast fortfahren?',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
