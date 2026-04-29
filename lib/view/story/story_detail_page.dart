import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

import '../../data/models/story_model.dart';

class StoryDetailPage extends StatefulWidget {
  final StoryModel story;
  final VoidCallback onBack;

  const StoryDetailPage({
    super.key,
    required this.story,
    required this.onBack,
  });

  @override
  State<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  String address = "Memuat alamat...";
  bool isLoadingAddress = false;

  @override
  void initState() {
    super.initState();

    if (widget.story.lat != null && widget.story.lon != null) {
      getAddress();
    }
  }

  Future<void> getAddress() async {
    try {
      setState(() => isLoadingAddress = true);

      final placemarks = await placemarkFromCoordinates(
        widget.story.lat!,
        widget.story.lon!,
      );

      final place = placemarks.first;

      setState(() {
        address =
            "${place.street}, ${place.subLocality}, ${place.locality}";
      });
    } catch (e) {
      setState(() {
        address = "Alamat tidak ditemukan";
      });
    } finally {
      setState(() => isLoadingAddress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasLocation =
        widget.story.lat != null && widget.story.lon != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Story"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack, // 🔥 declarative back
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// 🔹 IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.story.photoUrl,
              height: 220,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                  const Icon(Icons.broken_image, size: 100),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            widget.story.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(widget.story.description),

          const SizedBox(height: 16),

          if (hasLocation) ...[
            const Text(
              "Lokasi",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 250,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    widget.story.lat!,
                    widget.story.lon!,
                  ),
                  zoom: 14,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(widget.story.id),
                    position: LatLng(
                      widget.story.lat!,
                      widget.story.lon!,
                    ),
                    infoWindow: InfoWindow(
                      title: widget.story.name,
                      snippet: isLoadingAddress
                          ? "Memuat alamat..."
                          : address,
                    ),
                  ),
                },
              ),
            ),

            const SizedBox(height: 10),

            Text(
              isLoadingAddress ? "Memuat alamat..." : address,
              style: const TextStyle(color: Colors.grey),
            ),
          ] else ...[
            const Text(
              "Lokasi tidak tersedia",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }
}