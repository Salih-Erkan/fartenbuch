import 'package:fartenbuch/src/features/farten/domain/fahrt.dart';
import 'package:fartenbuch/src/features/home/domain/fahranlass.dart';

abstract class DatabaseRepository {
  Future<List<Fahrt>> getFahrten(String fahranlassId);
  Future<List<Fahranlass>> getFahranlaesse();
  Future<void> createFahranlass(Fahranlass fahranlass);
  Future<void> saveFahrt(Fahrt fahrt);
}
