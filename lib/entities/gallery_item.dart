import 'package:hear_ai_demo/entities/gallery_item_type.dart';

class GalleryItem {
  final int? id;
  final String description;
  final String mediaUrl;
  final DateTime time;
  final GalleryItemType mediaType;

  GalleryItem({
    this.id,
    required this.description,
    required this.mediaUrl,
    required this.time,
    required this.mediaType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'mediaUrl': mediaUrl,
      'time': time.millisecondsSinceEpoch,
      'mediaType': mediaType.index,
    };
  }

  factory GalleryItem.fromMap(Map<String, dynamic> map) {
    return GalleryItem(
      id: map['id'] as int,
      description: map['description'] as String,
      mediaUrl: map['mediaUrl'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      mediaType: GalleryItemType.values[map['mediaType'] as int],
    );
  }

  GalleryItem copyWith({
    int? id,
    String? description,
    String? mediaUrl,
    DateTime? time,
    GalleryItemType? mediaType,
  }) {
    return GalleryItem(
      id: id ?? this.id,
      description: description ?? this.description,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      time: time ?? this.time,
      mediaType: mediaType ?? this.mediaType,
    );
  }
}
