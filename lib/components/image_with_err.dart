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
        return Image.network(
          snapshot.data!,
          fit: fit,
          errorBuilder: errBuilder,
          loadingBuilder: loadingBuilder,
        );
      },
      future: ref.watch(storageBucketProvider).getPublicUrl(fileName),
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
