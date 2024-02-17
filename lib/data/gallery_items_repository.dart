import 'package:hear_ai_demo/entities/gallery_item.dart';

abstract class GalleryItemsRepository {
  Future<int> insert(GalleryItem item);

  Future<int> update(GalleryItem item);

  Future<int> delete(GalleryItem item);

  Future<List<GalleryItem>> getAllItems();
}
