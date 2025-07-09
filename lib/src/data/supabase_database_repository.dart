import 'package:fartenbuch/src/data/database_repository.dart';
import 'package:fartenbuch/src/features/farten/domain/fahrt.dart';
import 'package:fartenbuch/src/features/home/domain/fahranlass.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDatabaseRepository implements DatabaseRepository {
  final supabase = Supabase.instance.client;

  @override
  Future<void> createFahranlass(Fahranlass fahranlass) async {
    await supabase.from('fahranlaesse').insert(fahranlass.toMap());
  }

  @override
  Future<List<Fahranlass>> getFahranlaesse() async {
    final response = await supabase.from('fahranlaesse').select();
    return (response as List).map((e) => Fahranlass.fromMap(e)).toList();
  }

  @override
  Future<void> saveFahrt(Fahrt fahrt) async {
    await supabase.from('fahrten').insert(fahrt.toMap());
  }

  @override
  Future<List<Fahrt>> getFahrten(String fahranlassId) async {
    final response = await supabase
        .from('fahrten')
        .select()
        .eq('fahrtenanlass_id', fahranlassId);

    return (response as List).map((e) => Fahrt.fromMap(e)).toList();
  }
}
