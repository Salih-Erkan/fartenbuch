import 'package:fartenbuch/src/features/auth/presentation/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({super.key});

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  @override
  void initState() {
    super.initState();

    // Simulierter Ladeprozess → nach 3 Sekunden zum HomeScreen
    Future.delayed(const Duration(seconds: 7), () {
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        127,
        209,
        48,
      ), // Hintergrundfarbe
      body: SafeArea(
        child: Center(
          child: Lottie.asset(
            'assets/Animationtest.json',
            width: MediaQuery.of(context).size.width * 2,
            height: MediaQuery.of(context).size.width * 2,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
