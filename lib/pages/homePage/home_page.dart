import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hear_ai_demo/components/media/media_preview.dart';
import 'package:hear_ai_demo/components/theme_switch.dart';
import 'package:hear_ai_demo/entities/gallery_item.dart';
import 'package:hear_ai_demo/pages/homePage/media_type_filter_picker.dart';
import 'package:hear_ai_demo/state/providers.dart';
import 'package:hear_ai_demo/state/state/home_page_state.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HomePageState galleryState = ref.watch(homePageStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: const [
          MediaTypeFilterPicker(),
          ThemeSwitch(),
          SizedBox(width: 10),
        ],
      ),
      body: galleryState.error != null
          ? buildError(galleryState.error!)
          : galleryState.isLoading
              ? buildLoading()
              : buildGrid(galleryState.items),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => goToCreate(context),
      ),
    );
  }

  Widget buildGrid(List<GalleryItem> items) {
    if (items.isEmpty) return const Center(child: Text('No items yet'));

    return GridView.builder(
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (context, index) {
        var item = items[index];
        return MediaPreview(
          onTap: () => goToView(context, item.id!),
          key: ValueKey(item.id),
          uri: item.publicUrl,
          isNetworkSource: true,
          type: item.mediaType,
        );
      },
    );
  }

  Widget buildError(String error) => Center(child: Text(error, style: const TextStyle(color: Colors.red)));

  Widget buildLoading() => const Center(child: CircularProgressIndicator());

  void goToCreate(context) {
    GoRouter.of(context).push('/create');
  }

  void goToView(BuildContext context, int id) {
    GoRouter.of(context).push('/view/$id');
  }
}
