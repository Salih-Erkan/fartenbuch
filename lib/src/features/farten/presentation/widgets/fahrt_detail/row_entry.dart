import 'package:flutter/material.dart';

class RowEntry extends StatelessWidget {
  final String titleLeft, valueLeft, subtitleLeft;
  final String titleRight, valueRight, subtitleRight;

  const RowEntry({
    super.key,
    required this.titleLeft,
    required this.valueLeft,
    required this.subtitleLeft,
    required this.titleRight,
    required this.valueRight,
    required this.subtitleRight,
  });

  @override
  Widget build(BuildContext context) {
    final styleTitle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
    final styleValue = const TextStyle(color: Colors.black, fontSize: 16);
    final styleSubtitle = const TextStyle(color: Colors.black, fontSize: 13);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titleLeft, style: styleTitle),
                const SizedBox(height: 4),
                Text(valueLeft, style: styleValue),
                if (subtitleLeft.isNotEmpty)
                  Text(subtitleLeft, style: styleSubtitle),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(titleRight, style: styleTitle),
                const SizedBox(height: 4),
                Text(valueRight, style: styleValue, textAlign: TextAlign.end),
                if (subtitleRight.isNotEmpty)
                  Text(
                    subtitleRight,
                    style: styleSubtitle,
                    textAlign: TextAlign.end,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
