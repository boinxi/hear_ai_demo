import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hear_ai_demo/state/providers.dart';

class ImageWithErr extends ConsumerWidget {
  final String fileName;
  final bool centerLoading;
  final BoxFit fit;

  const ImageWithErr({
    Key? key,
    required this.fileName,
    this.centerLoading = false,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        return CachedNetworkImage(
          imageUrl: snapshot.data!,
          fit: fit,
          errorWidget: errBuilder,
          progressIndicatorBuilder: loadingBuilder,
        );
      },
      future: ref.watch(storageBucketProvider).getPublicUrl(fileName),
    );
  }

  Widget loadingBuilder(context, url, DownloadProgress downloadProgress) {
    return Align(
      alignment: centerLoading ? Alignment.bottomCenter : Alignment.center,
      child: centerLoading ? LinearProgressIndicator(value: downloadProgress.progress) : CircularProgressIndicator(value: downloadProgress.progress),
    );
  }

  Widget errBuilder(
    context,
    url,
    error,
  ) {
    return const Center(child: Icon(Icons.error_outline));
  }
}
