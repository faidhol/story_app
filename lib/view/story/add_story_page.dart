import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/api_service.dart';
import '../../data/repository/story_repository.dart';

class AddStoryPage extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onSuccess;

  const AddStoryPage({
    super.key,
    required this.onBack,
    required this.onSuccess,
  });

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final picker = ImagePicker();
  XFile? image;
  final descC = TextEditingController();

  bool isLoading = false;

  final repo = StoryRepository(ApiService());

  Future<void> pickCamera() async {
    final result = await picker.pickImage(source: ImageSource.camera);
    if (result != null) {
      setState(() => image = result);
    }
  }

  Future<void> pickGallery() async {
    final result = await picker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      setState(() => image = result);
    }
  }

  Future<void> handleUpload() async {
    if (image == null || descC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gambar & deskripsi wajib diisi")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final success = await repo.addStory(
        file: File(image!.path),
        description: descC.text,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Story berhasil diupload")),
        );

        widget.onSuccess(); 
        widget.onBack(); 
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Upload gagal")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    descC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Story"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: image != null
                  ? Image.file(File(image!.path), fit: BoxFit.cover)
                  : const Center(child: Text("Belum ada gambar")),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: pickCamera,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: pickGallery,
                    icon: const Icon(Icons.image),
                    label: const Text("Gallery"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            TextField(
              controller: descC,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Deskripsi",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            isLoading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: handleUpload,
                      child: const Text("Upload Story"),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
