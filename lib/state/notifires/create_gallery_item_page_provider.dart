import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hear_ai_demo/data/storage_bucket.dart';
import 'package:hear_ai_demo/entities/gallery_item.dart';
import 'package:hear_ai_demo/entities/gallery_item_type.dart';
import 'package:hear_ai_demo/state/providers.dart';
import 'package:hear_ai_demo/state/state/create_edit_page_state.dart';
import 'package:image_picker/image_picker.dart';

class CreateEditItemPageStateNotifier extends StateNotifier<CreateGalleryItemPageState> {
  final StorageBucket _storageBucket;

  CreateEditItemPageStateNotifier(this._storageBucket, GalleryItem? itemToEdit) : super(CreateGalleryItemPageState(TextEditingController())) {
    if (itemToEdit != null) loadItemToEdit(itemToEdit);
  }

  void loadItemToEdit(GalleryItem itemToEdit) {
    state = state.copyWith(itemToEdit: itemToEdit);
    state.descriptionController.text = itemToEdit.description;
  }

  void setSelectedFile(File? selectedFile) {
    state = state.copyWith(selectedFile: selectedFile);
  }

  void setUploadProgress(double? uploadProgress) {
    state = state.copyWith(uploadProgress: uploadProgress);
  }

  Future getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      state = state.copyWith(itemToEdit: state.itemToEdit?.copyWith(mediaUrl: null));
      setSelectedFile(File(pickedFile.path));
    }
  }

  Future<void> createOrUpdateItem(WidgetRef ref) async {
    // TODO: check if i acn get rid of ref

    String? path = state.itemToEdit?.mediaUrl;
    if (state.selectedFile != null) {
      // TODO: if there is a media url to be deleted, delete it
      setUploadProgress(0);

      path = await _storageBucket.uploadMedia(
        File(state.selectedFile!.path),
        onProgress: setUploadProgress,
      );
      setUploadProgress(null);
    }

    if (state.itemToEdit != null) {
      GalleryItem updatedItem = state.itemToEdit!.copyWith(
        description: state.descriptionController.text,
        mediaUrl: path,
        time: DateTime.now(),
      );
      await ref.read(homePageStateProvider.notifier).updateGalleryItem(updatedItem);
    } else {
      GalleryItem newItem = GalleryItem(
        description: state.descriptionController.text,
        mediaUrl: path!,
        time: DateTime.now(),
        mediaType: GalleryItemType.image,
      );
      await ref.read(homePageStateProvider.notifier).addGalleryItem(newItem);
    }
  }

}
