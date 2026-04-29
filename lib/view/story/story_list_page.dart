import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../data/api_service.dart';
import '../../data/models/story_model.dart';
import '../../data/repository/story_repository.dart';

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
  static const _pageSize = 10;

  final PagingController<int, StoryModel> _pagingController =
      PagingController(firstPageKey: 1);

  final repo = StoryRepository(ApiService());

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });
  }

  Future<void> fetchPage(int pageKey) async {
    try {
      final newItems = await repo.getStories(pageKey, _pageSize);

      final isLastPage = newItems.length < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Story App"),
        actions: [
          IconButton(
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: PagedListView<int, StoryModel>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<StoryModel>(
          itemBuilder: (context, item, index) {
            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                leading: Image.network(
                  item.photoUrl,
                  width: 60,
                  fit: BoxFit.cover,
                ),
                title: Text(item.name),
                subtitle: Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => widget.onDetail(item),
              ),
            );
          },

          firstPageProgressIndicatorBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),

          firstPageErrorIndicatorBuilder: (_) =>
              const Center(child: Text("Gagal memuat data")),

          noItemsFoundIndicatorBuilder: (_) =>
              const Center(child: Text("Belum ada story")),

          newPageProgressIndicatorBuilder: (_) =>
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: widget.onAddStory,
        child: const Icon(Icons.add),
      ),
    );
  }
}