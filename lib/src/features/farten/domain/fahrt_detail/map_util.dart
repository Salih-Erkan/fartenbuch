import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fartenbuch/src/core/services/directions_service.dart';

class MapUtil {
  static Future<({List<LatLng> route, int distanceInKm})> getRouteWithDistance({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final directionsService = DirectionsService();
    final result = await directionsService.getRouteWithDistance(
      origin: origin,
      destination: destination,
    );
    return (route: result.route, distanceInKm: result.distanceInKm);
  }

  static LatLngBounds calculateBounds(List<LatLng> points) {
    final swLat = points.map((p) => p.latitude).reduce((a, b) => a < b ? a : b);
    final swLng = points
        .map((p) => p.longitude)
        .reduce((a, b) => a < b ? a : b);
    final neLat = points.map((p) => p.latitude).reduce((a, b) => a > b ? a : b);
    final neLng = points
        .map((p) => p.longitude)
        .reduce((a, b) => a > b ? a : b);

    return LatLngBounds(
      southwest: LatLng(swLat, swLng),
      northeast: LatLng(neLat, neLng),
    );
  }
}
