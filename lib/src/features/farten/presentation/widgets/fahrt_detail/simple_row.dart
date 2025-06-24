import 'package:flutter/material.dart';

class SimpleRow extends StatelessWidget {
  final String label;
  final String value;

  const SimpleRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.black)),
              Text(value, style: const TextStyle(color: Colors.black)),
            ],
          ),
        ),
        const Divider(color: Colors.white24, thickness: 0.5),
      ],
    );
  }
}
