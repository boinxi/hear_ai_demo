import 'package:flutter/material.dart';

class ImageWithErr extends StatelessWidget {
  final String mediaUrl;
  final bool centerLoading;
  final BoxFit fit;

  const ImageWithErr({
    Key? key,
    required this.mediaUrl,
    this.centerLoading = false,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      mediaUrl,
      fit: fit,
      errorBuilder: errBuilder,
      loadingBuilder: loadingBuilder,
    );
  }

  Widget loadingBuilder(context, child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) {
      return child;
    }
    double? progress =
        loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null;

    return Align(
      alignment: centerLoading ? Alignment.bottomCenter : Alignment.center,
      child: centerLoading ? LinearProgressIndicator(value: progress) : CircularProgressIndicator(value: progress),
    );
  }

  Widget errBuilder(contex_, error, stackTrace) {
    return const Center(child: Icon(Icons.error_outline));
  }
}
