import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fartenbuch/src/core/services/directions_service.dart';
import 'package:flutter/material.dart';

class FahrtHelper {
  static Future<void> maybeCalculateRoute({
    required LatLng startLatLng,
    required LatLng zielLatLng,
    required DirectionsService directionsService,
    required void Function(Set<Polyline>) onPolylinesChanged,
    required void Function(LatLngBounds bounds) onCameraUpdate,
    required void Function(String entfernung) onDistanceCalculated,
  }) async {
    final result = await directionsService.getRouteWithDistance(
      origin: startLatLng,
      destination: zielLatLng,
    );

    final polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: result.route,
        color: Colors.blue,
        width: 5,
      ),
    };

    onPolylinesChanged(polylines);
    onDistanceCalculated(result.distanceInKm.toString());

    final swLat = result.route
        .map((p) => p.latitude)
        .reduce((a, b) => a < b ? a : b);
    final swLng = result.route
        .map((p) => p.longitude)
        .reduce((a, b) => a < b ? a : b);
    final neLat = result.route
        .map((p) => p.latitude)
        .reduce((a, b) => a > b ? a : b);
    final neLng = result.route
        .map((p) => p.longitude)
        .reduce((a, b) => a > b ? a : b);

    final bounds = LatLngBounds(
      southwest: LatLng(swLat, swLng),
      northeast: LatLng(neLat, neLng),
    );

    onCameraUpdate(bounds);
  }
}
