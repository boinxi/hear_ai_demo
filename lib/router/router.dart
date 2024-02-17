import 'package:go_router/go_router.dart';
import 'package:hear_ai_demo/pages/create_gallery_item_page.dart';
import 'package:hear_ai_demo/pages/homePage/home_page.dart';
import 'package:hear_ai_demo/pages/media_view_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/create',
      builder: (context, state) => CreateGalleryItemPage(),
    ),
    GoRoute(
      path: '/view/:id',
      builder: (context, state) {
        final String? id = state.pathParameters['id'];
        return MediaViewPage(int.parse(id!));
      },
    ),
  ],
);
