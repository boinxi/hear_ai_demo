import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hear_ai_demo/components/media_preview.dart';
import 'package:hear_ai_demo/components/theme_switch.dart';
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
        actions: const [ThemeSwitch()],
      ),
      body: GridView.builder(
        itemCount: galleryState.items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) => MediaPreview(
          mediaUrl: galleryState.items[index].mediaUrl,
          onTap: () => goToView(context, galleryState.items[index].id!),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => goToCreate(context),
      ),
    );
  }

  void goToCreate(context) {
    GoRouter.of(context).push('/create');
  }

  void goToView(BuildContext context, int id) {
    GoRouter.of(context).push('/view/$id');
  }
}
