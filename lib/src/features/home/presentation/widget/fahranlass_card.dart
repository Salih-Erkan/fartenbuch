import 'package:fartenbuch/src/features/farten/presentation/fahrt_list_screen.dart';
import 'package:fartenbuch/src/features/home/domain/fahranlass.dart';
import 'package:flutter/material.dart';

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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FahrtListScreen(fahrtAnlass: cat),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              IconData(
                cat.iconCodePoint,
                fontFamily: cat.fontFamily,
                fontPackage: cat.fontPackage,
              ),
              size: 32,
              color: cat.color,
            ),
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
