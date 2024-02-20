import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageWithErr extends ConsumerWidget {
  final String publicUrl;
  final bool centerLoading;
  final BoxFit fit;

  const ImageWithErr({
    Key? key,
    required this.publicUrl,
    this.centerLoading = false,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CachedNetworkImage(
      imageUrl: publicUrl,
      fit: fit,
      errorWidget: errBuilder,
      progressIndicatorBuilder: loadingBuilder,
    );
  }

  Widget loadingBuilder(context, url, DownloadProgress downloadProgress) {
    return Align(
      alignment: centerLoading ? Alignment.bottomCenter : Alignment.center,
      child: centerLoading ? LinearProgressIndicator(value: downloadProgress.progress) : CircularProgressIndicator(value: downloadProgress.progress),
    );
  }

  Widget errBuilder(context, url, error) {
    return const Center(child: Icon(Icons.error_outline));
  }
}
