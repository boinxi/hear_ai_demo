import 'package:go_router/go_router.dart';
import 'package:hear_ai_demo/pages/create_gallery_item_page.dart';
import 'package:hear_ai_demo/pages/homePage/home_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/create',
      builder: (context, state) => const CreateGalleryItemPage(),
    ),
  ],
);
