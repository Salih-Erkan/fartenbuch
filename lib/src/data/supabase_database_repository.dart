/*import 'package:fartenbuch/src/features/home/domain/fahranlass.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fartenbuch/src/data/database_repository.dart';
import 'package:fartenbuch/src/features/farten/domain/adresse.dart';
import 'package:fartenbuch/src/features/farten/domain/fahrt.dart';

class SupabaseDatabaseRepository implements DatabaseRepository {
  final supabase = Supabase.instance.client;

  @override
  Future<List<Fahrt>> getFahrten() async {
    final response = await supabase.from('fahrten').select();

    return response.map<Fahrt>((data) {
      return Fahrt(
        start: Adresse(
          ort: data['start_ort'],
          strasse: data['start_strasse'],
          hausnummer: data['start_hausnummer'],
          plz: data['start_plz'],
          lat: (data['start_lat'] as num).toDouble(),
          lng: (data['start_lng'] as num).toDouble(),
        ),
        ziel: Adresse(
          ort: data['ziel_ort'],
          strasse: data['ziel_strasse'],
          hausnummer: data['ziel_hausnummer'],
          plz: data['ziel_plz'],
          lat: (data['ziel_lat'] as num).toDouble(),
          lng: (data['ziel_lng'] as num).toDouble(),
        ),
        entfernung: data['entfernung'],
        datum: data['datum'], // als String akzeptiert (z. B. "2024-04-14")
        beschreibung: data['beschreibung'],
        abfahrtUhrzeit: data['abfahrt_uhrzeit'],
        ankunftUhrzeit: data['ankunft_uhrzeit'],
        kmStart: data['km_start'],
        kmEnde: data['km_ende'],
        typ: data['typ'],
        firma: data['firma'],
        kontakt: data['kontakt'],
      );
    }).toList();
  }

  @override
  Future<List<Fahranlass>> getFahranlaesse() {
    // TODO: implement getFahranlaesse
    throw UnimplementedError();
  }
}
*/
