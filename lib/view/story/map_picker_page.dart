import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerPage extends StatefulWidget {
  final Function(LatLng) onPicked;
  final VoidCallback onBack;

  const MapPickerPage({
    super.key,
    required this.onPicked,
    required this.onBack,
  });

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  LatLng? selectedLatLng;

  static const LatLng initialPosition = LatLng(-6.200000, 106.816666);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Lokasi"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack, // declarative
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: initialPosition,
              zoom: 12,
            ),
            onTap: (latLng) {
              setState(() {
                selectedLatLng = latLng;
              });
            },
            markers: selectedLatLng == null
                ? {}
                : {
                    Marker(
                      markerId: const MarkerId("selected"),
                      position: selectedLatLng!,
                    )
                  },
          ),

          if (selectedLatLng != null)
            Positioned(
              bottom: 80,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "Lat: ${selectedLatLng!.latitude}, "
                    "Lng: ${selectedLatLng!.longitude}",
                  ),
                ),
              ),
            ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedLatLng != null) {
            widget.onPicked(selectedLatLng!);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Pilih lokasi dulu")),
            );
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}