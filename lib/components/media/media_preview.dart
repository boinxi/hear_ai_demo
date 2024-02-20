import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hear_ai_demo/components/media/image_with_err.dart';
import 'package:hear_ai_demo/components/media/video_player_wrapper.dart';
import 'package:hear_ai_demo/entities/gallery_item_type.dart';

class MediaPreview extends StatelessWidget {
  final VoidCallback? onTap;
  final String uri;
  final GalleryItemType type;
  final bool isNetworkSource;

  const MediaPreview({Key? key, required this.uri, this.onTap, required this.type, required this.isNetworkSource}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardBorderRadius = BorderRadius.circular(10);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: cardBorderRadius),
        child: ClipRRect(
          borderRadius: cardBorderRadius,
          child: buildPreview(),
        ),
      ),
    );
  }

  Widget buildPreview() {
    if (type == GalleryItemType.video) {
      return VideoPlayerWrapper(isNetworkSource: isNetworkSource, uri: uri);
    }
    if (isNetworkSource) {
      return ImageWithErr(publicUrl: uri, fit: BoxFit.cover);
    } else {
      return Image.file(File(uri), fit: BoxFit.fitWidth);
    }
  }
}
