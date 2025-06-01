import 'package:fartenbuch/src/features/farten/domain/fahrt.dart';

abstract class DatabaseRepository {
  Future<List<Fahrt>> getFahrten();
}
