import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hear_ai_demo/components/image_with_err.dart';
import 'package:hear_ai_demo/entities/gallery_item.dart';
import 'package:hear_ai_demo/state/home_page_provider.dart';

class MediaViewPage extends ConsumerWidget {
  final int itemId;

  const MediaViewPage(this.itemId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GalleryItem galleryItem = ref.watch(homePageStateProvider).items.firstWhere((item) => item.id == itemId);
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: double.infinity),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: ImageWithErr(mediaUrl: galleryItem.mediaUrl, fit: BoxFit.contain),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Item description:',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 170),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(child: Text(galleryItem.description)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
