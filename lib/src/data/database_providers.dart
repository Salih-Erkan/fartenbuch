import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fartenbuch/src/data/database_repository.dart';
import 'package:fartenbuch/src/data/supabase_database_repository.dart';

final databaseRepositoryProvider = Provider<DatabaseRepository>((ref) {
  return SupabaseDatabaseRepository();
});
