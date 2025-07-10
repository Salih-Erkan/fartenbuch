import 'package:fartenbuch/src/features/farten/presentation/providers/map_init_cache_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapCard extends ConsumerWidget {
  final GoogleMapController? mapController;
  final Function(GoogleMapController controller)? onMapCreated;
  final LatLng? startLatLng;
  final LatLng? zielLatLng;
  final Set<Polyline> polylines;

  const MapCard({
    super.key,
    required this.mapController,
    required this.onMapCreated,
    required this.startLatLng,
    required this.zielLatLng,
    required this.polylines,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showMap = ref.watch(mapInitCacheProvider);

    return Card(
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 4,
      child: SizedBox(
        height: 250,
        child:
            showMap
                ? GoogleMap(
                  onMapCreated: onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: startLatLng ?? const LatLng(52.52, 13.4050),
                    zoom: 12,
                  ),
                  markers: {
                    if (startLatLng != null)
                      Marker(
                        markerId: const MarkerId("start"),
                        position: startLatLng!,
                        infoWindow: const InfoWindow(title: "Start"),
                      ),
                    if (zielLatLng != null)
                      Marker(
                        markerId: const MarkerId("ziel"),
                        position: zielLatLng!,
                        infoWindow: const InfoWindow(title: "Ziel"),
                      ),
                  },
                  polylines: polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                )
                : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
