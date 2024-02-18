import 'package:hear_ai_demo/entities/gallery_item.dart';

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
