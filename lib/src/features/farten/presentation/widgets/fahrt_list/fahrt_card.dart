import 'package:fartenbuch/src/features/farten/domain/fahrt.dart';
import 'package:fartenbuch/src/features/farten/presentation/fahrt_detail_screen.dart';
import 'package:fartenbuch/src/features/farten/presentation/widgets/fahrt_list/fahrt_info.dart';
import 'package:flutter/material.dart';

class FahrtCard extends StatelessWidget {
  const FahrtCard({super.key, required this.context, required this.fahrt});

  final BuildContext context;
  final Fahrt fahrt;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FahrtDetailScreen(fahrt: fahrt)),
        );
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FahrtInfo(fahrt: fahrt),
        ),
      ),
    );
  }
}
