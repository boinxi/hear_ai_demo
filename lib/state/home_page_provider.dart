import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hear_ai_demo/data/gallery_items_repository.dart';
import 'package:hear_ai_demo/entities/gallery_item.dart';
import 'package:hear_ai_demo/services/db_service.dart';

class HomePageStateNotifier extends StateNotifier<HomePageState> {
  final GalleryItemsRepository repository;

  HomePageStateNotifier(this.repository) : super(HomePageState());

  Future<void> loadItems() async {
    try {
      final List<GalleryItem> items = await repository.getAllItems();
      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> addGalleryItem(GalleryItem item) async {
    final int newId = await repository.insert(item);
    final List<GalleryItem> newList = List<GalleryItem>.from(state.items)..add(item.copyWith(id: newId));
    state = state.copyWith(items: newList);
  }
}

final homePageStateProvider = StateNotifierProvider<HomePageStateNotifier, HomePageState>(
  (ref) {
    GalleryItemsRepository itemsRepository = DBService();
    return HomePageStateNotifier(itemsRepository)..loadItems();
  },
);

class HomePageState {
  final List<GalleryItem> items;
  final bool isLoading;
  final String? error;

  HomePageState({this.items = const [], this.isLoading = false, this.error});

  HomePageState copyWith({
    List<GalleryItem>? items,
    bool? isLoading,
    String? error,
  }) {
    return HomePageState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
