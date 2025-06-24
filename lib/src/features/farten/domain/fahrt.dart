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
}
