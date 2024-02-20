import 'package:hear_ai_demo/entities/gallery_item.dart';
import 'package:hear_ai_demo/entities/media_filter.dart';

abstract class GalleryItemsRepository {
  Future<int> insert(GalleryItem item);

  Future<int> update(GalleryItem item);

  Future<int> delete(GalleryItem item);

  Future<List<GalleryItem>> getAllItems({MediaFilter? filter});
}
