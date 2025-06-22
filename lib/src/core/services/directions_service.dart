import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteResult {
  final List<LatLng> route;
  final int distanceInKm;

  RouteResult({required this.route, required this.distanceInKm});
}

class DirectionsService {
  final String apiKey = 'AIzaSyDPZA7CWpRUGN9xU0Cm8qgU19YkZNdbHpY';

  Future<RouteResult> getRouteWithDistance({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey&language=de',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final points = data['routes'][0]['overview_polyline']['points'];
      final route = _decodePolyline(points);

      final distanceInMeters =
          data['routes'][0]['legs'][0]['distance']['value'];
      final distanceInKm = (distanceInMeters / 1000).round();

      return RouteResult(route: route, distanceInKm: distanceInKm);
    } else {
      throw Exception('Directions API request failed');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polylineCoordinates = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polylineCoordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polylineCoordinates;
  }
}
