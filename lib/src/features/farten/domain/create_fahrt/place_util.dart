import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

String? _apiKey = dotenv.env['DEIN_GOOGLE_API_KEY'];

class PlaceUtil {
  static Future<List<String>> getSuggestions(String input) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$_apiKey&language=de&components=country:de';
    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body);
    return (json['predictions'] as List)
        .map((p) => p['description'] as String)
        .toList();
  }

  static Future<LatLng?> getLatLngFromDescription(String description) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$description&key=$_apiKey&language=de&components=country:de';
    final res = await http.get(Uri.parse(url));
    final predictions = jsonDecode(res.body)['predictions'];
    if (predictions.isEmpty) return null;

    final placeId = predictions[0]['place_id'];
    final detailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_apiKey';
    final detailsRes = await http.get(Uri.parse(detailsUrl));
    final result = jsonDecode(detailsRes.body)['result'];
    final location = result['geometry']['location'];
    return LatLng(location['lat'], location['lng']);
  }

  static Map<String, String> getAddressComponents(dynamic result) {
    final addressComponents = result['address_components'];

    String getComponent(String type) {
      for (var c in addressComponents) {
        final types = c['types'];
        if (types is List && types.contains(type)) {
          return c['long_name'] ?? '';
        }
      }
      return '';
    }

    return {
      'ort': getComponent('locality'),
      'strasse': getComponent('route'),
      'hausnummer': getComponent('street_number'),
      'plz': getComponent('postal_code'),
    };
  }

  static Future<Map<String, dynamic>?> getPlaceDetails(
    String description,
  ) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$description&key=$_apiKey&language=de&components=country:de';
    final res = await http.get(Uri.parse(url));
    final predictions = jsonDecode(res.body)['predictions'];
    if (predictions.isEmpty) return null;

    final placeId = predictions[0]['place_id'];
    final detailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_apiKey';
    final detailsRes = await http.get(Uri.parse(detailsUrl));
    return jsonDecode(detailsRes.body)['result'];
  }
}
