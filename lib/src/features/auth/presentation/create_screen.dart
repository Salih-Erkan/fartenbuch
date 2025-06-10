import 'package:fartenbuch/src/features/auth/presentation/login_screen.dart';
import 'package:fartenbuch/src/features/auth/presentation/verification_screen_acount.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
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
        title: const Text(
          'Konto erstellen',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Registrieren',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const Text(
                'Erstelle ein Konto, um loszulegen!',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),

              TextField(
                decoration: InputDecoration(
                  labelText: 'E-Mail Adresse eingeben',
                  hintText: 'E-Mail Adresse',
                ),
              ),
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

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final pass1 = _passwordController.text;
                    final pass2 = _confirmController.text;
                    if (pass1 == pass2 && pass1.length >= 6) {
                      // Erfolg: Weiterleiten oder speichern
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Registrierung erfolgreich"),
                        ),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const VerificationScreenAccount(),
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
                  child: const Text('Registrieren'),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: const [
                  Expanded(child: Divider(color: Colors.grey)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('oder anmelden mit'),
                  ),
                  Expanded(child: Divider(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 10),
              const SocialSignupRow(),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Du hast noch kein Konto? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Jetzt einloggen",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialSignupRow extends StatelessWidget {
  const SocialSignupRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          SocialIconButton(iconPath: 'assets/icons/google.png'),
          SocialIconButton(iconPath: 'assets/icons/apple.png'),
          SocialIconButton(iconPath: 'assets/icons/facebook.png'),
        ],
      ),
    );
  }
}

class SocialIconButton extends StatelessWidget {
  final String iconPath;

  const SocialIconButton({super.key, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAFF), // helles Violett/Blau
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        onPressed: () {},
        icon: Image.asset(iconPath, width: 35, height: 35),
      ),
    );
  }
}
