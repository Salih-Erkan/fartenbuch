import 'package:fartenbuch/src/data/database_repository.dart';
import 'package:fartenbuch/src/features/farten/domain/adresse.dart';
import 'package:fartenbuch/src/features/farten/domain/fahrt.dart';
import 'package:fartenbuch/src/features/home/domain/fahranlass.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class SupabaseDatabaseRepository implements DatabaseRepository {
  final supabase = Supabase.instance.client;

  @override
  Future<void> createFahranlass(Fahranlass fahranlass) async {
    await supabase.from('fahranlaesse').insert({
      'id': fahranlass.id,
      'name': fahranlass.name,
      'icon_code_point': fahranlass.iconCodePoint,
      'font_family': fahranlass.fontFamily,
      'font_package': fahranlass.fontPackage,
      'color': fahranlass.color.value,
    });
  }

  @override
  Future<List<Fahranlass>> getFahranlaesse() async {
    final response = await supabase.from('fahranlaesse').select();

    return (response as List)
        .map(
          (e) => Fahranlass(
            id: e['id'],
            name: e['name'],
            iconCodePoint: e['icon_code_point'],
            fontFamily: e['font_family'],
            fontPackage: e['font_package'],
            color: Color(e['color']),
          ),
        )
        .toList();
  }

  @override
  Future<void> saveFahrt(Fahrt fahrt) async {
    await supabase.from('fahrten').insert({
      'fahrtenanlass_id': fahrt.fahrtenanlassId,
      'datum': fahrt.datum,
      'abfahrt_uhrzeit': fahrt.abfahrtUhrzeit,
      'ankunft_uhrzeit': fahrt.ankunftUhrzeit,
      'entfernung': fahrt.entfernung,
      'km_start': fahrt.kmStart,
      'km_ende': fahrt.kmEnde,
      'typ': fahrt.typ,
      'firma': fahrt.firma,
      'kontakt': fahrt.kontakt,
      'start_ort': fahrt.start.ort,
      'start_strasse': fahrt.start.strasse,
      'start_hausnummer': fahrt.start.hausnummer,
      'start_plz': fahrt.start.plz,
      'start_lat': fahrt.start.lat,
      'start_lng': fahrt.start.lng,
      'ziel_ort': fahrt.ziel.ort,
      'ziel_strasse': fahrt.ziel.strasse,
      'ziel_hausnummer': fahrt.ziel.hausnummer,
      'ziel_plz': fahrt.ziel.plz,
      'ziel_lat': fahrt.ziel.lat,
      'ziel_lng': fahrt.ziel.lng,
    });
  }

  @override
  Future<List<Fahrt>> getFahrten(String fahranlassId) async {
    final response = await supabase
        .from('fahrten')
        .select()
        .eq('fahrtenanlass_id', fahranlassId);

    return (response as List)
        .map(
          (e) => Fahrt(
            fahrtenanlassId: e['fahrtenanlass_id'],
            datum: e['datum'],
            abfahrtUhrzeit: e['abfahrt_uhrzeit'],
            ankunftUhrzeit: e['ankunft_uhrzeit'],
            entfernung: e['entfernung'],
            kmStart: e['km_start'],
            kmEnde: e['km_ende'],
            typ: e['typ'],
            firma: e['firma'],
            kontakt: e['kontakt'],
            start: Adresse(
              ort: e['start_ort'],
              strasse: e['start_strasse'],
              hausnummer: e['start_hausnummer'],
              plz: e['start_plz'],
              lat: e['start_lat'],
              lng: e['start_lng'],
            ),
            ziel: Adresse(
              ort: e['ziel_ort'],
              strasse: e['ziel_strasse'],
              hausnummer: e['ziel_hausnummer'],
              plz: e['ziel_plz'],
              lat: e['ziel_lat'],
              lng: e['ziel_lng'],
            ),
          ),
        )
        .toList();
  }
}
