import 'package:fartenbuch/src/features/farten/domain/fahrt.dart';
import 'package:fartenbuch/src/features/farten/presentation/widgets/fahrt_list/ort_row.dart';
import 'package:flutter/material.dart';

class FahrtInfo extends StatelessWidget {
  const FahrtInfo({super.key, required this.fahrt});

  final Fahrt fahrt;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${fahrt.entfernung} km',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(fahrt.datum, style: const TextStyle(fontSize: 14)),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            width: 1,
            color: Colors.grey[300],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrtRow(
                  icon: Icons.location_on,
                  color: Colors.red,
                  adresse: fahrt.ziel,
                ),
                const SizedBox(height: 8),
                OrtRow(
                  icon: Icons.my_location,
                  color: Colors.blue,
                  adresse: fahrt.start,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
