import 'package:flutter/material.dart';
import '../../data/api_service.dart';
import '../../data/repository/story_repository.dart';
import '../../data/models/story_model.dart';

class StoryListPage extends StatefulWidget {
  final VoidCallback onLogout;
  final VoidCallback onAddStory;
  final Function(StoryModel) onDetail;

  const StoryListPage({
    super.key,
    required this.onLogout,
    required this.onAddStory,
    required this.onDetail,
  });

  @override
  State<StoryListPage> createState() => _StoryListPageState();
}

class _StoryListPageState extends State<StoryListPage> {
  final repo = StoryRepository(ApiService());

  List<StoryModel> stories = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchStories();
  }

  Future<void> fetchStories() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final result = await repo.getStories();
      stories = result;
    } catch (e) {
      error = e.toString();
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Story App"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text(error!))
          : stories.isEmpty
          ? const Center(child: Text("Belum ada story"))
          : RefreshIndicator(
              onRefresh: fetchStories,
              child: ListView.builder(
                itemCount: stories.length,
                itemBuilder: (context, index) {
                  final story = stories[index];

                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),

                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          story.photoUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              const Icon(Icons.broken_image),
                        ),
                      ),

                      title: Text(
                        story.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      subtitle: Text(
                        story.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      onTap: () => widget.onDetail(story),
                    ),
                  );
                },
              ),
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: widget.onAddStory,
        child: const Icon(Icons.add),
      ),
    );
  }
}
