import 'package:hear_ai_demo/entities/gallery_item.dart';
import 'package:hear_ai_demo/entities/media_filter.dart';

class HomePageState {
  final List<GalleryItem> items;
  final bool isLoading;
  final String? error;
  final MediaFilter filter;

  HomePageState({this.items = const [], this.isLoading = false, this.error, this.filter = MediaFilter.none});

  HomePageState copyWith({
    List<GalleryItem>? items,
    bool? isLoading,
    String? error,
    MediaFilter? filter,
  }) {
    return HomePageState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      filter: filter ?? this.filter,
    );
  }
}
