import 'package:fartenbuch/src/features/farten/domain/adresse.dart';

class Fahrt {
  final String fahrtenanlassId;
  final Adresse start;
  final Adresse ziel;
  final int entfernung;
  final String datum;
  final String abfahrtUhrzeit;
  final String ankunftUhrzeit;
  final int kmStart;
  final int kmEnde;
  final String typ;
  final String firma;
  final String kontakt;

  Fahrt({
    required this.fahrtenanlassId,
    required this.start,
    required this.ziel,
    required this.entfernung,
    required this.datum,
    required this.abfahrtUhrzeit,
    required this.ankunftUhrzeit,
    required this.kmStart,
    required this.kmEnde,
    required this.typ,
    required this.firma,
    required this.kontakt,
  });

  Map<String, dynamic> toMap() {
    return {
      'fahrtenanlass_id': fahrtenanlassId,
      'datum': datum,
      'abfahrt_uhrzeit': abfahrtUhrzeit,
      'ankunft_uhrzeit': ankunftUhrzeit,
      'entfernung': entfernung,
      'km_start': kmStart,
      'km_ende': kmEnde,
      'typ': typ,
      'firma': firma,
      'kontakt': kontakt,
      ...start.toStartMap(),
      ...ziel.toTargetMap(),
    };
  }

  factory Fahrt.fromMap(Map<String, dynamic> map) {
    return Fahrt(
      fahrtenanlassId: map['fahrtenanlass_id'],
      datum: map['datum'],
      abfahrtUhrzeit: map['abfahrt_uhrzeit'],
      ankunftUhrzeit: map['ankunft_uhrzeit'],
      entfernung: map['entfernung'],
      kmStart: map['km_start'],
      kmEnde: map['km_ende'],
      typ: map['typ'],
      firma: map['firma'],
      kontakt: map['kontakt'],
      start: Adresse.fromStartMap(map),
      ziel: Adresse.fromZielMap(map),
    );
  }
}
