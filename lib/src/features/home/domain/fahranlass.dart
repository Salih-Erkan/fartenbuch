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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon_code_point': iconCodePoint,
      'font_family': fontFamily,
      'font_package': fontPackage,
      // ignore: deprecated_member_use
      'color': color.value,
    };
  }

  factory Fahranlass.fromMap(Map<String, dynamic> map) {
    return Fahranlass(
      id: map['id'],
      name: map['name'],
      iconCodePoint: map['icon_code_point'],
      fontFamily: map['font_family'],
      fontPackage: map['font_package'],
      color: Color(map['color']),
    );
  }
}
