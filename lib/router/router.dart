import 'package:go_router/go_router.dart';
import 'package:hear_ai_demo/pages/createEditItemPage/create_edit_item_page.dart';
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
      builder: (context, state) => CreateEditItemPage(),
    ),
    GoRoute(
      path: '/create/:id',
      builder: (context, state) {
        final int? toEditId = state.pathParameters.containsKey('id') ? int.parse(state.pathParameters['id']!) : null;
        return CreateEditItemPage(toEditId: toEditId);
      },
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
