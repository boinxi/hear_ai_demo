import 'package:flutter/material.dart';
import 'package:hear_ai_demo/components/image_with_err.dart';

class MediaPreview extends StatelessWidget {
  final VoidCallback? onTap;
  final String fileName;

  const MediaPreview({Key? key, required this.fileName, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardBorderRadius = BorderRadius.circular(10);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: cardBorderRadius),
        child: ClipRRect(
          borderRadius: cardBorderRadius,
          child: ImageWithErr(fileName: fileName, centerLoading: true),
        ),
      ),
    );
  }
}
