import 'package:fartenbuch/src/core/presentation/app_scaffold.dart';
import 'package:fartenbuch/src/core/services/directions_service.dart';
import 'package:fartenbuch/src/data/database_providers.dart';
import 'package:fartenbuch/src/features/farten/domain/create_fahrt/place_util.dart';
import 'package:fartenbuch/src/features/farten/domain/create_fahrt/fahrt_util.dart';
import 'package:fartenbuch/src/features/farten/domain/fahrt.dart';
import 'package:fartenbuch/src/features/farten/presentation/providers/fahrten_provider.dart';
import 'package:fartenbuch/src/features/farten/presentation/providers/map_init_cache_provider.dart';
import 'package:fartenbuch/src/features/farten/presentation/map/map.dart';
import 'package:flutter/material.dart';
import 'package:fartenbuch/src/features/farten/domain/adresse.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✔ RICHTIG!

class CreateFahrtScreen extends ConsumerStatefulWidget {
  const CreateFahrtScreen({super.key, required this.fahrtenanlassId});

  final String fahrtenanlassId;

  @override
  ConsumerState<CreateFahrtScreen> createState() => _CreateFahrtScreenState(); // wichtig
}

class _CreateFahrtScreenState extends ConsumerState<CreateFahrtScreen>
    with WidgetsBindingObserver {
  String startort = '';
  String startstrasse = '';
  String starthausnummer = '';
  String startplz = '';

  String zielort = '';
  String zielstrasse = '';
  String zielhausnummer = '';
  String zielplz = '';

  final _formKey = GlobalKey<FormState>();

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

    WidgetsBinding.instance.addObserver(this);

    final alreadyInitialized = ref.read(mapInitCacheProvider);

    if (!alreadyInitialized) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          ref.read(mapInitCacheProvider.notifier).state = true;
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
    WidgetsBinding.instance.removeObserver(this);
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

    final repository = ref.watch(databaseRepositoryProvider);

    final neueFahrt = Fahrt(
      fahrtenanlassId: widget.fahrtenanlassId,
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
    );

    await repository.saveFahrt(neueFahrt);

    ref.invalidate(fahrtenProvider(widget.fahrtenanlassId));
    // ignore: use_build_context_synchronously
    if (context.mounted) Navigator.pop(context, neueFahrt);
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
