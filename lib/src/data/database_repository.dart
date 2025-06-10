import 'package:fartenbuch/src/features/farten/domain/fahrt.dart';
import 'package:fartenbuch/src/features/home/domain/fahranlass.dart';

abstract class DatabaseRepository {
  Future<List<Fahrt>> getFahrten();
  Future<List<Fahranlass>> getFahranlaesse();
}
