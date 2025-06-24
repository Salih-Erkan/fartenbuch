import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapCard extends StatefulWidget {
  final bool showMap;
  final GoogleMapController? mapController;
  final Function(GoogleMapController controller)? onMapCreated;
  final LatLng? startLatLng;
  final LatLng? zielLatLng;
  final Set<Polyline> polylines;

  const MapCard({
    super.key,
    required this.showMap,
    required this.mapController,
    required this.onMapCreated,
    required this.startLatLng,
    required this.zielLatLng,
    required this.polylines,
  });

  @override
  State<MapCard> createState() => _MapCardState();
}

class _MapCardState extends State<MapCard> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // wichtig für KeepAlive

    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 4,
      child: SizedBox(
        height: 250,
        child:
            widget.showMap
                ? GoogleMap(
                  onMapCreated: widget.onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: widget.startLatLng ?? const LatLng(52.52, 13.4050),
                    zoom: 12,
                  ),
                  markers: {
                    if (widget.startLatLng != null)
                      Marker(
                        markerId: const MarkerId("start"),
                        position: widget.startLatLng!,
                        infoWindow: const InfoWindow(title: "Start"),
                      ),
                    if (widget.zielLatLng != null)
                      Marker(
                        markerId: const MarkerId("ziel"),
                        position: widget.zielLatLng!,
                        infoWindow: const InfoWindow(title: "Ziel"),
                      ),
                  },
                  polylines: widget.polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                )
                : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
