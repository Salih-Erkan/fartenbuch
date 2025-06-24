import 'package:fartenbuch/src/features/farten/domain/adresse.dart';
import 'package:flutter/material.dart';

class OrtRow extends StatelessWidget {
  const OrtRow({
    super.key,
    required this.icon,
    required this.color,
    required this.adresse,
  });

  final IconData icon;
  final Color color;
  final Adresse adresse;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                adresse.ort,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '${adresse.plz}, ${adresse.strasse} ${adresse.hausnummer}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
