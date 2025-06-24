import 'package:fartenbuch/src/core/presentation/app_scaffold.dart';
import 'package:fartenbuch/src/core/services/directions_service.dart';
import 'package:fartenbuch/src/features/farten/domain/create_fahrt/place_util.dart';
import 'package:fartenbuch/src/features/farten/domain/create_fahrt/fahrt_util.dart';
import 'package:fartenbuch/src/features/farten/presentation/widgets/map.dart';
import 'package:flutter/material.dart';
import 'package:fartenbuch/src/features/farten/domain/adresse.dart';
import 'package:fartenbuch/src/data/database_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

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
  String startort = '';
  String startstrasse = '';
  String starthausnummer = '';
  String startplz = '';

  String zielort = '';
  String zielstrasse = '';
  String zielhausnummer = '';
  String zielplz = '';

  final _formKey = GlobalKey<FormState>();

  bool _showMap = false;
  bool _mapWasInitialized = false;

  final _startAdressController = TextEditingController();
  final _zielAdressController = TextEditingController();

  final _kmStartController = TextEditingController();
  final _kmEndeController = TextEditingController();
  final _typController = TextEditingController();
  final _firmaController = TextEditingController();
  final _kontaktController = TextEditingController();

  List<String> _startSuggestions = [];
  List<String> _zielSuggestions = [];

  final DirectionsService _directionsService = DirectionsService();

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
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _datum =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    _abfahrt =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    _ankunft = _abfahrt;

    if (_mapWasInitialized) {
      _showMap = true;
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            _showMap = true;
            _mapWasInitialized =
                true; // merken, dass Map nun einmal gezeigt wurde
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _startAdressController.dispose();
    _zielAdressController.dispose();
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
      final suggestions = await PlaceUtil.getSuggestions(input);
      setState(() {
        if (isStart) {
          _startSuggestions = suggestions;
        } else {
          _zielSuggestions = suggestions;
        }
      });
    });
  }

  Future<void> _setSelectedPlace(String description, bool isStart) async {
    final result = await PlaceUtil.getPlaceDetails(description);
    if (result == null) return;

    final location = result['geometry']['location'];
    final position = LatLng(location['lat'], location['lng']);
    final components = PlaceUtil.getAddressComponents(result);

    setState(() {
      if (isStart) {
        _startAdressController.text = description;
        _startLatLng = position;
        _startSuggestions.clear();
        startort = components['ort'] ?? '';
        startstrasse = components['strasse'] ?? '';
        starthausnummer = components['hausnummer'] ?? '';
        startplz = components['plz'] ?? '';
      } else {
        _zielAdressController.text = description;
        _zielLatLng = position;
        _zielSuggestions.clear();
        zielort = components['ort'] ?? '';
        zielstrasse = components['strasse'] ?? '';
        zielhausnummer = components['hausnummer'] ?? '';
        zielplz = components['plz'] ?? '';
      }
    });

    if (_startLatLng != null && _zielLatLng != null) {
      await FahrtHelper.maybeCalculateRoute(
        startLatLng: _startLatLng!,
        zielLatLng: _zielLatLng!,
        directionsService: _directionsService,
        onPolylinesChanged:
            (newPolylines) => setState(() => _polylines = newPolylines),
        onCameraUpdate:
            (bounds) => _mapController?.animateCamera(
              CameraUpdate.newLatLngBounds(bounds, 60),
            ),
        onDistanceCalculated:
            (distance) => setState(() => _entfernung = distance),
      );
    }
  }

  Future<void> _saveFahrt() async {
    if (!_formKey.currentState!.validate()) return;

    await FahrtHelper.saveFahrt(
      context: context,
      formKey: _formKey,
      fahrtenanlassId: widget.fahrtenanlassId,
      datum: _datum,
      entfernung: _entfernung,
      abfahrt: _abfahrt,
      ankunft: _ankunft,
      kmStart: _kmStartController.text,
      kmEnde: _kmEndeController.text,
      typ: _typController.text,
      firma: _firmaController.text,
      kontakt: _kontaktController.text,
      start: Adresse(
        ort: startort,
        strasse: startstrasse,
        hausnummer: starthausnummer,
        plz: startplz,
        lat: _startLatLng?.latitude ?? 0,
        lng: _startLatLng?.longitude ?? 0,
      ),
      ziel: Adresse(
        ort: zielort,
        strasse: zielstrasse,
        hausnummer: zielhausnummer,
        plz: zielplz,
        lat: _zielLatLng?.latitude ?? 0,
        lng: _zielLatLng?.longitude ?? 0,
      ),
      repository: widget.repository,
    );
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Pflichtfeld';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: const Text('Neue Fahrt erstellen')),
      child: SingleChildScrollView(
        child: Column(
          children: [
            MapCard(
              showMap: _showMap,
              mapController: _mapController,
              onMapCreated: (controller) => _mapController = controller,
              startLatLng: _startLatLng,
              zielLatLng: _zielLatLng,
              polylines: _polylines,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveFahrt,
                          child: const Text('Speichern'),
                        ),
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
