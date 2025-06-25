import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Merkt sich, ob Map schon einmal angezeigt wurde
final mapInitCacheProvider = StateProvider<bool>((ref) => false);
