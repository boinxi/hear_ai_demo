import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hear_ai_demo/components/image_with_err.dart';
import 'package:hear_ai_demo/entities/gallery_item.dart';
import 'package:hear_ai_demo/state/providers.dart';

class MediaViewPage extends ConsumerWidget {
  final int itemId;

  const MediaViewPage(this.itemId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GalleryItem galleryItem = ref.watch(homePageStateProvider).items.firstWhere((item) => item.id == itemId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Viewing item $itemId'),
        actions: [
          buildEditButton(context),
        ],
      ),
      body: Center(
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
    );
  }

  IconButton buildEditButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () => goToEdit(context),
    );
  }

  void goToEdit(BuildContext context) {
    final router = GoRouter.of(context);
    if (router.canPop()) {
      router.pop();
    }
    router.push('/create/$itemId');
  }
}
