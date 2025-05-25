import 'package:fartenbuch/src/features/farten/domain/fahrt.dart';

abstract class DatabaseRepository {
  List<Fahrt> getFahrten();
}
