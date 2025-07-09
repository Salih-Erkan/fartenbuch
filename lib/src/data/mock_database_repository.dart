import 'package:fartenbuch/src/data/database_repository.dart';
import 'package:fartenbuch/src/features/farten/domain/adresse.dart';
import 'package:fartenbuch/src/features/farten/domain/fahrt.dart';
import 'package:fartenbuch/src/features/home/domain/fahranlass.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MockDatabaseRepository implements DatabaseRepository {
  final List<Fahrt> fahrten = [
    Fahrt(
      fahrtenanlassId: '1',
      start: Adresse(
        ort: 'Berlin',
        strasse: 'Alexanderplatz',
        hausnummer: '1',
        plz: '10178',
        lat: 52.50936830037417,
        lng: 13.376094568311604,
      ),
      ziel: Adresse(
        ort: 'Potsdam',
        strasse: 'Friedrich-Ebert-Str.',
        hausnummer: '5',
        plz: '14467',
        lat: 51.52935346311071,
        lng: 7.487049997086014,
      ),
      entfernung: 54,
      datum: '14.04.2024',
      abfahrtUhrzeit: '08:00',
      ankunftUhrzeit: '08:30',
      kmStart: 12600,
      kmEnde: 12654,
      typ: 'Geschäftlich',
      firma: 'Musterfirma Berlin',
      kontakt: 'Max Mustermann',
    ),
    Fahrt(
      fahrtenanlassId: '2',
      start: Adresse(
        ort: 'Dortmund',
        strasse: 'Hansaplatz',
        hausnummer: '5',
        plz: '44145',
        lat: 51.44857008265837,
        lng: 7.568364794266259,
      ),
      ziel: Adresse(
        ort: 'Schwerte',
        strasse: 'Friedrich-Ebert-Str.',
        hausnummer: '5',
        plz: '14467',
        lat: 51.52131014237037,
        lng: 7.45960645455965,
      ),
      entfernung: 14,
      datum: '19.04.2024',
      abfahrtUhrzeit: '09:00',
      ankunftUhrzeit: '10:20',
      kmStart: 12800,
      kmEnde: 12880,
      typ: 'Geschäftlich',
      firma: 'Tech Solutions GmbH',
      kontakt: 'John Doe',
    ),
    Fahrt(
      fahrtenanlassId: '1',
      start: Adresse(
        ort: 'Berlin',
        strasse: 'Alexanderplatz',
        hausnummer: '1',
        plz: '10178',
        lat: 52.4000,
        lng: 13.0500,
      ),
      ziel: Adresse(
        ort: 'Essen',
        strasse: 'Musterfeld-Ebert-Str.',
        hausnummer: '7',
        plz: '14467',
        lat: 52.5219,
        lng: 13.4132,
      ),
      entfernung: 67,
      datum: '14.05.2024',
      abfahrtUhrzeit: '13:15',
      ankunftUhrzeit: '14:45',
      kmStart: 13000,
      kmEnde: 13067,
      typ: 'Privat',
      firma: 'Universität Berlin',
      kontakt: 'Lisa Müller',
    ),
  ];

  final List<Fahranlass> _fahranleasse = [
    Fahranlass(
      id: '1',
      name: 'Arbeit',
      iconCodePoint: FontAwesomeIcons.briefcase.codePoint,
      fontFamily: 'FontAwesomeSolid',
      fontPackage: 'font_awesome_flutter',
      color: Colors.indigo,
    ),
    Fahranlass(
      id: '2',
      name: 'Einkauf',
      iconCodePoint: FontAwesomeIcons.cartShopping.codePoint,
      fontFamily: 'FontAwesomeSolid',
      fontPackage: 'font_awesome_flutter',
      color: Colors.pink,
    ),
    Fahranlass(
      id: '3',
      name: 'Freizeit',
      iconCodePoint: FontAwesomeIcons.ticket.codePoint,
      fontFamily: 'FontAwesomeSolid',
      fontPackage: 'font_awesome_flutter',
      color: Colors.cyan,
    ),
    Fahranlass(
      id: '4',
      name: 'Familie',
      iconCodePoint: FontAwesomeIcons.houseUser.codePoint,
      fontFamily: 'FontAwesomeSolid',
      fontPackage: 'font_awesome_flutter',
      color: Colors.green,
    ),
  ];

  @override
  Future<void> createFahranlass(Fahranlass fahranlass) async {
    _fahranleasse.add(fahranlass);
  }

  @override
  Future<List<Fahranlass>> getFahranlaesse() async {
    return _fahranleasse;
  }

  @override
  Future<void> saveFahrt(Fahrt fahrt) async {
    fahrten.add(fahrt);
  }

  @override
  Future<List<Fahrt>> getFahrten(String fahranlassId) async {
    return fahrten
        .where((fahrt) => fahrt.fahrtenanlassId == fahranlassId)
        .toList();
  }
}
