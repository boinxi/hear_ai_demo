import 'package:hear_ai_demo/entities/gallery_item_type.dart';

class GalleryItem {
  final int? id;
  final String description;
  final String fileName;
  final DateTime time;
  final GalleryItemType mediaType;

  GalleryItem({
    this.id,
    required this.description,
    required this.fileName,
    required this.time,
    required this.mediaType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'fileName': fileName,
      'time': time.millisecondsSinceEpoch,
      'mediaType': mediaType.index,
    };
  }

  factory GalleryItem.fromMap(Map<String, dynamic> map) {
    return GalleryItem(
      id: map['id'] as int,
      description: map['description'] as String,
      fileName: map['fileName'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      mediaType: GalleryItemType.values[map['mediaType'] as int],
    );
  }

  GalleryItem copyWith({
    int? id,
    String? description,
    String? fileName,
    DateTime? time,
    GalleryItemType? mediaType,
  }) {
    return GalleryItem(
      id: id ?? this.id,
      description: description ?? this.description,
      fileName: fileName ?? this.fileName,
      time: time ?? this.time,
      mediaType: mediaType ?? this.mediaType,
    );
  }
}
