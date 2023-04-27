import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_reader/models/scan_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  MapType mapType = MapType.normal;
  @override
  Widget build(BuildContext context) {
    final ScanModel scan =
        ModalRoute.of(context)?.settings.arguments as ScanModel;

    final CameraPosition startingPoint = CameraPosition(
      target: scan.getLatLng(),
      zoom: 17.5,
    );

    // Marcadores
    Set<Marker> markers = Set<Marker>();
    markers.add(Marker(
        markerId: const MarkerId('geo-location'), position: scan.getLatLng()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        actions: [
          IconButton(
              onPressed: () async {
                final GoogleMapController controller = await _controller.future;
                controller.animateCamera(
                    CameraUpdate.newCameraPosition(startingPoint));
              },
              icon: const Icon(Icons.gps_fixed_rounded))
        ],
      ),
      body: GoogleMap(
        myLocationButtonEnabled: false,
        mapType: mapType,
        markers: markers,
        initialCameraPosition: startingPoint,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (mapType == MapType.normal) {
              mapType = MapType.satellite;
            } else {
              mapType = MapType.normal;
            }
            setState(() {});
          },
          child: const Icon(Icons.layers)),
    );
  }
}
