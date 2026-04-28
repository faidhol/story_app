import 'package:flutter/material.dart';
import '../../data/models/story_model.dart';
import 'package:intl/intl.dart';

class StoryDetailPage extends StatelessWidget {
  final StoryModel story;
  final VoidCallback onBack;

  const StoryDetailPage({super.key, required this.story, required this.onBack});

  String formatDate(String date) {
    final parsed = DateTime.parse(date);
    return DateFormat('dd MMM yyyy, HH:mm').format(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Story"),
        centerTitle: true,

        /// 🔹 BACK BUTTON (DECLARATIVE)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: ListView(
        children: [
          /// 🔹 IMAGE
          Image.network(
            story.photoUrl,
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                const Center(child: Icon(Icons.broken_image, size: 50)),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 NAME
                Text(
                  story.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                /// 🔹 DATE
                Text(
                  formatDate(story.createdAt),
                  style: TextStyle(color: Colors.grey[600]),
                ),

                const SizedBox(height: 16),

                /// 🔹 DESCRIPTION
                Text(story.description, style: const TextStyle(fontSize: 16)),

                const SizedBox(height: 20),

                /// 🔹 LOCATION (OPTIONAL)
                if (story.lat != null && story.lon != null)
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 5),
                      Text(
                        "Lat: ${story.lat}, Lon: ${story.lon}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
