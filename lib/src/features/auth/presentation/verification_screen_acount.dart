import 'package:fartenbuch/src/core/presentation/app_scaffold.dart';
import 'package:fartenbuch/src/features/auth/presentation/accout_created_screen.dart';
import 'package:flutter/material.dart';

class VerificationScreenAccount extends StatefulWidget {
  const VerificationScreenAccount({super.key});

  @override
  State<VerificationScreenAccount> createState() =>
      _VerificationScreenAccountState();
}

class _VerificationScreenAccountState extends State<VerificationScreenAccount> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void handlePaste(String pastedText) {
    final trimmed = pastedText.trim();
    if (trimmed.length >= 4) {
      for (int i = 0; i < 4; i++) {
        _controllers[i].text = trimmed[i];
      }
      _focusNodes[3].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AppScaffold(
      appBar: AppBar(title: const Text('Verifizierung')),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: bottomInset > 0 ? bottomInset : 40,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Gib den Code ein, um fortzufahren.',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.asset('assets/images/verification.png', height: 180),
                    const SizedBox(height: 20),
                    const Text(
                      'Wir haben einen Code an',
                      style: TextStyle(fontSize: 14),
                    ),
                    const Text(
                      'youremail@outlook.com',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('gesendet!', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return SizedBox(
                          width: 60,
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: const TextStyle(fontSize: 24),
                            decoration: const InputDecoration(counterText: ''),
                            onChanged: (value) {
                              if (index == 0 && value.length > 1) {
                                handlePaste(value);
                              } else if (value.isNotEmpty && index < 3) {
                                _focusNodes[index + 1].requestFocus();
                              } else if (value.isEmpty && index > 0) {
                                _focusNodes[index - 1].requestFocus();
                              }
                            },
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final code = _controllers.map((c) => c.text).join();
                          if (code == '1234') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const AccoutCreatedScreen(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Falscher Code')),
                            );
                          }
                        },
                        child: const Text('Weiter'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Code nicht erhalten? '),
                        TextButton(
                          onPressed: () {
                            // Code erneut senden
                          },
                          child: const Text(
                            'Erneut senden',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back, size: 18),
                        label: const Text('Zurück'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
