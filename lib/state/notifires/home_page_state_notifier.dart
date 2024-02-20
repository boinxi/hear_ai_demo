import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hear_ai_demo/data/gallery_items_repository.dart';
import 'package:hear_ai_demo/data/storage_bucket.dart';
import 'package:hear_ai_demo/entities/gallery_item.dart';
import 'package:hear_ai_demo/entities/media_filter.dart';
import 'package:hear_ai_demo/state/state/home_page_state.dart';

class HomePageStateNotifier extends StateNotifier<HomePageState> {
  final GalleryItemsRepository _repository;
  final StorageBucket _storageBucket;

  HomePageStateNotifier(this._repository, this._storageBucket) : super(HomePageState());

  Future<void> loadItems() async {
    try {
      state = state.copyWith(isLoading: true);
      final List<GalleryItem> items = await _repository.getAllItems(filter: state.filter);
      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void setFilter(MediaFilter? newFilter) {
    state = state.copyWith(filter: newFilter);
    loadItems(); // Reload items with the new filter
  }

  Future<void> addGalleryItem(GalleryItem item) async {
    final int newId = await _repository.insert(item);
    final List<GalleryItem> newList = List<GalleryItem>.from(state.items)..add(item.copyWith(id: newId));
    state = state.copyWith(items: newList);
  }

  Future<void> updateGalleryItem(GalleryItem item) async {
    await _repository.update(item);

    int itemIndex = state.items.indexWhere((galleryItem) => galleryItem.id == item.id);
    if (itemIndex != -1) {
      List<GalleryItem> updatedItems = List<GalleryItem>.from(state.items)..[itemIndex] = item;
      state = state.copyWith(items: updatedItems);
    }
  }

  Future<void> deleteGalleryItem(GalleryItem item) async {
    await _repository.delete(item);
    await _storageBucket.deleteMedia(item.fileName);
    final List<GalleryItem> newList = List<GalleryItem>.from(state.items)..remove(item);
    state = state.copyWith(items: newList);
  }
}
