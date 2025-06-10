import 'package:fartenbuch/src/features/home/domain/fahranlass.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FahranlassCard extends StatelessWidget {
  const FahranlassCard({super.key, required this.context, required this.cat});

  final BuildContext context;
  final Fahranlass cat;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cat.color.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cat.color.withAlpha(40),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // TODO: Fahranlass auswählen/speichern
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Ausgewählt: ${cat.name}')));
        },
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(cat.icon, size: 32, color: cat.color),
            const SizedBox(height: 10),
            Text(
              cat.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
