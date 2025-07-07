import 'package:flutter/material.dart';

class Fahranlass {
  final String id;
  final String name;
  final int iconCodePoint;
  final String fontFamily;
  final String fontPackage;
  final Color color;

  Fahranlass({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    required this.fontFamily,
    required this.fontPackage,
    required this.color,
  });

  IconData get icon =>
      IconData(iconCodePoint, fontFamily: fontFamily, fontPackage: fontPackage);
}
