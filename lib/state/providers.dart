import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hear_ai_demo/data/gallery_items_repository.dart';
import 'package:hear_ai_demo/data/storage_bucket.dart';
import 'package:hear_ai_demo/entities/gallery_item.dart';
import 'package:hear_ai_demo/services/db_service.dart';
import 'package:hear_ai_demo/services/firebase_service.dart';
import 'package:hear_ai_demo/state/notifires/create_gallery_item_page_state_notifier.dart';
import 'package:hear_ai_demo/state/notifires/home_page_state_notifier.dart';
import 'package:hear_ai_demo/state/notifires/theme_state_notifier.dart';
import 'package:hear_ai_demo/state/state/create_edit_page_state.dart';
import 'package:hear_ai_demo/state/state/home_page_state.dart';

final homePageStateProvider = StateNotifierProvider<HomePageStateNotifier, HomePageState>(
  (ref) {
    GalleryItemsRepository itemsRepository = DBService();
    StorageBucket storageBucket = ref.watch(storageBucketProvider);
    return HomePageStateNotifier(itemsRepository, storageBucket)..loadItems();
  },
);

final createEditItemPageProvider = StateNotifierProvider.autoDispose.family<CreateEditItemPageStateNotifier, CreateEditGalleryItemPageState, int?>(
  (ref, int? id) {
    StorageBucket storageBucket = ref.read(storageBucketProvider);
    if (id == null) return CreateEditItemPageStateNotifier(storageBucket, null);

    GalleryItem itemToEdit = ref.read(homePageStateProvider).items.firstWhere((element) => element.id == id);
    return CreateEditItemPageStateNotifier(storageBucket, itemToEdit);
  },
);

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) => ThemeNotifier());

final storageBucketProvider = Provider<StorageBucket>((ref) => FirebaseService());
