import 'package:fartenbuch/src/features/farten/domain/fahrt.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fartenbuch/src/core/services/directions_service.dart';

class FahrtDetailScreen extends StatefulWidget {
  final Fahrt fahrt;

  const FahrtDetailScreen({super.key, required this.fahrt});

  @override
  State<FahrtDetailScreen> createState() => _FahrtDetailScreenState();
}

class _FahrtDetailScreenState extends State<FahrtDetailScreen> {
  final Set<Polyline> _polylines = {};
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _loadRoute();
  }

  Future<void> _loadRoute() async {
    final directionsService = DirectionsService();
    final routePoints = await directionsService.getRouteCoordinates(
      origin: LatLng(widget.fahrt.start.lat, widget.fahrt.start.lng),
      destination: LatLng(widget.fahrt.ziel.lat, widget.fahrt.ziel.lng),
    );

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId("route"),
          points: routePoints,
          color: Colors.blue,
          width: 4,
        ),
      );
    });

    // Kamera anpassen
    if (_mapController != null && routePoints.isNotEmpty) {
      final bounds = _calculateBounds(routePoints);
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    }
  }

  LatLngBounds _calculateBounds(List<LatLng> points) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fahrt',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.fahrt.start.lat, widget.fahrt.start.lng),
                zoom: 12,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              markers: {
                Marker(
                  markerId: const MarkerId("start"),
                  position: LatLng(
                    widget.fahrt.start.lat,
                    widget.fahrt.start.lng,
                  ),
                  infoWindow: const InfoWindow(title: "Start"),
                ),
                Marker(
                  markerId: const MarkerId("ziel"),
                  position: LatLng(
                    widget.fahrt.ziel.lat,
                    widget.fahrt.ziel.lng,
                  ),
                  infoWindow: const InfoWindow(title: "Ziel"),
                ),
              },
              polylines: _polylines,
            ),
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
                  label: "Reisezweck",
                  value: widget.fahrt.beschreibung,
                ),
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

class RowEntry extends StatelessWidget {
  final String titleLeft, valueLeft, subtitleLeft;
  final String titleRight, valueRight, subtitleRight;

  const RowEntry({
    super.key,
    required this.titleLeft,
    required this.valueLeft,
    required this.subtitleLeft,
    required this.titleRight,
    required this.valueRight,
    required this.subtitleRight,
  });

  @override
  Widget build(BuildContext context) {
    final styleTitle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
    final styleValue = const TextStyle(color: Colors.black, fontSize: 16);
    final styleSubtitle = const TextStyle(color: Colors.black, fontSize: 13);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titleLeft, style: styleTitle),
                const SizedBox(height: 4),
                Text(valueLeft, style: styleValue),
                if (subtitleLeft.isNotEmpty)
                  Text(subtitleLeft, style: styleSubtitle),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(titleRight, style: styleTitle),
                const SizedBox(height: 4),
                Text(valueRight, style: styleValue, textAlign: TextAlign.end),
                if (subtitleRight.isNotEmpty)
                  Text(
                    subtitleRight,
                    style: styleSubtitle,
                    textAlign: TextAlign.end,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SimpleRow extends StatelessWidget {
  final String label;
  final String value;

  const SimpleRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.black)),
              Text(value, style: const TextStyle(color: Colors.black)),
            ],
          ),
        ),
        const Divider(color: Colors.white24, thickness: 0.5),
      ],
    );
  }
}
