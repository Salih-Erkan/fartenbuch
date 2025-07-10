import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fartenbuch/src/data/database_providers.dart';
import 'package:fartenbuch/src/features/farten/domain/fahrt.dart';

final fahrtenProvider = FutureProvider.family<List<Fahrt>, String>((
  ref,
  anlassId,
) async {
  final repo = ref.watch(databaseRepositoryProvider);
  return repo.getFahrten(anlassId);
});
