import 'package:flutter/material.dart';
import 'package:hear_ai_demo/entities/gallery_item_type.dart';

class MediaTypePicker extends StatelessWidget {
  const MediaTypePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.image),
          title: const Text('Image'),
          onTap: () => Navigator.pop(context, GalleryItemType.image),
        ),
        ListTile(
          leading: const Icon(Icons.video_library),
          title: const Text('Video'),
          onTap: () => Navigator.pop(context, GalleryItemType.video),
        ),
      ],
    );
  }
}
