import 'package:fartenbuch/src/features/farten/domain/fahrt.dart';
import 'package:fartenbuch/src/features/farten/domain/fahrt_detail/map_util.dart';
import 'package:fartenbuch/src/features/farten/presentation/providers/map_init_cache_provider.dart';
import 'package:fartenbuch/src/features/farten/presentation/map/map.dart';
import 'package:fartenbuch/src/features/farten/presentation/widgets/fahrt_detail/row_entry.dart';
import 'package:fartenbuch/src/features/farten/presentation/widgets/fahrt_detail/simple_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FahrtDetailScreen extends ConsumerStatefulWidget {
  final Fahrt fahrt;

  const FahrtDetailScreen({super.key, required this.fahrt});

  @override
  ConsumerState<FahrtDetailScreen> createState() => _FahrtDetailScreenState();
}

class _FahrtDetailScreenState extends ConsumerState<FahrtDetailScreen>
    with WidgetsBindingObserver {
  final Set<Polyline> _polylines = {};
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    final alreadyInitialized = ref.read(mapInitCacheProvider);

    if (!alreadyInitialized) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          ref.read(mapInitCacheProvider.notifier).state = true;
          _loadRoute();
        }
      });
    } else {
      _loadRoute();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mapController?.dispose(); // gibt Speicher explizit frei
    super.dispose();
  }

  Future<void> _loadRoute() async {
    final result = await MapUtil.getRouteWithDistance(
      origin: LatLng(widget.fahrt.start.lat, widget.fahrt.start.lng),
      destination: LatLng(widget.fahrt.ziel.lat, widget.fahrt.ziel.lng),
    );

    if (!mounted) return;

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId("route"),
          points: result.route,
          color: Colors.blue,
          width: 4,
        ),
      );
    });

    if (_mapController != null && result.route.isNotEmpty) {
      final bounds = MapUtil.calculateBounds(result.route);
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fahrt')),
      body: Column(
        children: [
          MapCard(
            mapController: _mapController,
            onMapCreated: (controller) => _mapController = controller,
            startLatLng: LatLng(widget.fahrt.start.lat, widget.fahrt.start.lng),
            zielLatLng: LatLng(widget.fahrt.ziel.lat, widget.fahrt.ziel.lng),
            polylines: _polylines,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: Text(
                '${widget.fahrt.entfernung} km',
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              children: [
                RowEntry(
                  titleLeft: "START",
                  valueLeft: widget.fahrt.firma,
                  subtitleLeft: widget.fahrt.start.vollAdresse,
                  titleRight: "ENDE",
                  valueRight: widget.fahrt.kontakt,
                  subtitleRight: widget.fahrt.ziel.vollAdresse,
                ),
                RowEntry(
                  titleLeft: "KILOMETERSTAND",
                  valueLeft: widget.fahrt.kmStart.toString(),
                  subtitleLeft: "",
                  titleRight: "KILOMETERSTAND",
                  valueRight: widget.fahrt.kmEnde.toString(),
                  subtitleRight: "",
                ),
                RowEntry(
                  titleLeft: "ABFAHRT",
                  valueLeft: widget.fahrt.abfahrtUhrzeit,
                  subtitleLeft: widget.fahrt.abfahrtUhrzeit,
                  titleRight: "ANKUNFT",
                  valueRight: widget.fahrt.ankunftUhrzeit,
                  subtitleRight: widget.fahrt.ankunftUhrzeit,
                ),
                const Divider(color: Colors.black, thickness: 1),
                SimpleRow(label: "Fahrttyp", value: widget.fahrt.typ),
                SimpleRow(
                  label: "Geschäftspartner",
                  value: widget.fahrt.kontakt,
                ),
                SimpleRow(label: "Firma", value: widget.fahrt.firma),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
