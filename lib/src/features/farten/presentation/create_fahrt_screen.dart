import 'package:fartenbuch/src/core/services/directions_service.dart';
import 'package:flutter/material.dart';
import 'package:fartenbuch/src/features/farten/domain/adresse.dart';
import 'package:fartenbuch/src/features/farten/domain/fahrt.dart';
import 'package:fartenbuch/src/data/database_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

String? googleApiKey = dotenv.env['DEIN_GOOGLE_API_KEY'];

class CreateFahrtScreen extends StatefulWidget {
  final String fahrtenanlassId;
  final DatabaseRepository repository;

  const CreateFahrtScreen({
    super.key,
    required this.fahrtenanlassId,
    required this.repository,
  });

  @override
  State<CreateFahrtScreen> createState() => _CreateFahrtScreenState();
}

class _CreateFahrtScreenState extends State<CreateFahrtScreen> {
  final _formKey = GlobalKey<FormState>();

  final _startAdressController = TextEditingController();
  final _zielAdressController = TextEditingController();
  final _beschreibungController = TextEditingController();
  final _startOrtController = TextEditingController();
  final _startStrasseController = TextEditingController();
  final _startHausnummerController = TextEditingController();
  final _startPlzController = TextEditingController();
  final _zielOrtController = TextEditingController();
  final _zielStrasseController = TextEditingController();
  final _zielHausnummerController = TextEditingController();
  final _zielPlzController = TextEditingController();
  final _kmStartController = TextEditingController();
  final _kmEndeController = TextEditingController();
  final _typController = TextEditingController();
  final _firmaController = TextEditingController();
  final _kontaktController = TextEditingController();

  List<String> _startSuggestions = [];
  List<String> _zielSuggestions = [];

  final DirectionsService _directionsService = DirectionsService();

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _datum =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    _abfahrt =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    _ankunft = _abfahrt;
  }

  String _datum = '';
  String _entfernung = '';
  String _abfahrt = '';
  String _ankunft = '';

  Timer? _debounce;
  GoogleMapController? _mapController;
  Set<Polyline> _polylines = {};

  LatLng? _startLatLng;
  LatLng? _zielLatLng;

  @override
  void dispose() {
    _startAdressController.dispose();
    _zielAdressController.dispose();
    _beschreibungController.dispose();
    _startOrtController.dispose();
    _startStrasseController.dispose();
    _startHausnummerController.dispose();
    _startPlzController.dispose();
    _zielOrtController.dispose();
    _zielStrasseController.dispose();
    _zielHausnummerController.dispose();
    _zielPlzController.dispose();
    _kmStartController.dispose();
    _kmEndeController.dispose();
    _typController.dispose();
    _firmaController.dispose();
    _kontaktController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onAddressChanged(String input, bool isStart) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$googleApiKey&language=de&components=country:de';
      final response = await http.get(Uri.parse(url));
      final json = jsonDecode(response.body);
      final suggestions =
          (json['predictions'] as List)
              .map((p) => p['description'] as String)
              .toList();

      setState(() {
        if (isStart) {
          _startSuggestions = suggestions;
        } else {
          _zielSuggestions = suggestions;
        }
      });
    });
  }

  Future<void> _maybeCalculateRoute() async {
    if (_startLatLng != null && _zielLatLng != null) {
      final route = await _directionsService.getRouteCoordinates(
        origin: _startLatLng!,
        destination: _zielLatLng!,
      );

      setState(() {
        _polylines = {
          Polyline(
            polylineId: const PolylineId('route'),
            points: route,
            color: Colors.blue,
            width: 5,
          ),
        };
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(
              _startLatLng!.latitude < _zielLatLng!.latitude
                  ? _startLatLng!.latitude
                  : _zielLatLng!.latitude,
              _startLatLng!.longitude < _zielLatLng!.longitude
                  ? _startLatLng!.longitude
                  : _zielLatLng!.longitude,
            ),
            northeast: LatLng(
              _startLatLng!.latitude > _zielLatLng!.latitude
                  ? _startLatLng!.latitude
                  : _zielLatLng!.latitude,
              _startLatLng!.longitude > _zielLatLng!.longitude
                  ? _startLatLng!.longitude
                  : _zielLatLng!.longitude,
            ),
          ),
          60,
        ),
      );
    }
  }

  Future<void> _setSelectedPlace(String description, bool isStart) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$description&key=$googleApiKey&language=de&components=country:de';
    final res = await http.get(Uri.parse(url));
    final predictions = jsonDecode(res.body)['predictions'];
    if (predictions.isEmpty) return;

    final placeId = predictions[0]['place_id'];
    final detailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey';
    final detailsRes = await http.get(Uri.parse(detailsUrl));
    final result = jsonDecode(detailsRes.body)['result'];
    final location = result['geometry']['location'];

    final lat = location['lat'];
    final lng = location['lng'];
    final position = LatLng(lat, lng);

    setState(() {
      if (isStart) {
        _startAdressController.text = description;
        _startLatLng = position;
        _startSuggestions.clear();
      } else {
        _zielAdressController.text = description;
        _zielLatLng = position;
        _zielSuggestions.clear();
      }
    });

    _maybeCalculateRoute();
  }

  void _saveFahrt() async {
    if (_formKey.currentState!.validate()) {
      final fahrt = Fahrt(
        fahrtenanlassId: widget.fahrtenanlassId,
        beschreibung: _beschreibungController.text,
        datum: _datum,
        entfernung: int.tryParse(_entfernung) ?? 0,
        abfahrtUhrzeit: _abfahrt,
        ankunftUhrzeit: _ankunft,
        kmStart: int.tryParse(_kmStartController.text) ?? 0,
        kmEnde: int.tryParse(_kmEndeController.text) ?? 0,
        typ: _typController.text,
        firma: _firmaController.text,
        kontakt: _kontaktController.text,
        start: Adresse(
          ort: _startOrtController.text,
          strasse: _startStrasseController.text,
          hausnummer: _startHausnummerController.text,
          plz: _startPlzController.text,
          lat: _startLatLng?.latitude ?? 0,
          lng: _startLatLng?.longitude ?? 0,
        ),
        ziel: Adresse(
          ort: _zielOrtController.text,
          strasse: _zielStrasseController.text,
          hausnummer: _zielHausnummerController.text,
          plz: _zielPlzController.text,
          lat: _zielLatLng?.latitude ?? 0,
          lng: _zielLatLng?.longitude ?? 0,
        ),
      );
      widget.repository.saveFahrt(fahrt);
      if (context.mounted) Navigator.pop(context, fahrt);
    }
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Pflichtfeld';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Neue Fahrt erstellen')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 4,
              child: SizedBox(
                height: 250,
                child: GoogleMap(
                  onMapCreated: (controller) => _mapController = controller,
                  initialCameraPosition: CameraPosition(
                    target: _startLatLng ?? const LatLng(52.52, 13.4050),
                    zoom: 12,
                  ),
                  markers: {
                    if (_startLatLng != null)
                      Marker(
                        markerId: const MarkerId("start"),
                        position: _startLatLng!,
                        infoWindow: const InfoWindow(title: "Start"),
                      ),
                    if (_zielLatLng != null)
                      Marker(
                        markerId: const MarkerId("ziel"),
                        position: _zielLatLng!,
                        infoWindow: const InfoWindow(title: "Ziel"),
                      ),
                  },
                  polylines: _polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: 16,
                  children: [
                    TextFormField(
                      controller: _startAdressController,
                      decoration: const InputDecoration(
                        labelText: 'Startadresse',
                      ),
                      validator: _required,
                      onChanged: (val) => _onAddressChanged(val, true),
                    ),
                    ..._startSuggestions.map(
                      (s) => ListTile(
                        title: Text(s),
                        onTap: () => _setSelectedPlace(s, true),
                      ),
                    ),
                    TextFormField(
                      controller: _zielAdressController,
                      decoration: const InputDecoration(
                        labelText: 'Zieladresse',
                      ),
                      validator: _required,
                      onChanged: (val) => _onAddressChanged(val, false),
                    ),
                    ..._zielSuggestions.map(
                      (s) => ListTile(
                        title: Text(s),
                        onTap: () => _setSelectedPlace(s, false),
                      ),
                    ),
                    TextFormField(
                      controller: _beschreibungController,
                      decoration: const InputDecoration(
                        labelText: 'Beschreibung',
                      ),
                      validator: _required,
                    ),
                    TextFormField(
                      controller: _kmStartController,
                      decoration: const InputDecoration(labelText: 'km Start'),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _kmEndeController,
                      decoration: const InputDecoration(labelText: 'km Ende'),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _typController,
                      decoration: const InputDecoration(labelText: 'Typ'),
                    ),
                    TextFormField(
                      controller: _firmaController,
                      decoration: const InputDecoration(labelText: 'Firma'),
                    ),
                    TextFormField(
                      controller: _kontaktController,
                      decoration: const InputDecoration(labelText: 'Kontakt'),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveFahrt,
                        child: const Text('Speichern'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
