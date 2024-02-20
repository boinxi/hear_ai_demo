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

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void setUploadProgress(double? uploadProgress) {
    state = state.copyWith(uploadProgress: uploadProgress);
  }

  void getMedia(GalleryItemType mediaType) async {
    if (mediaType == GalleryItemType.image) {
      getImage();
    } else {
      getVideo();
    }
  }

  Future getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      state = state.copyWith(
          itemToEdit: state.itemToEdit?.copyWith(fileName: null, mediaType: GalleryItemType.image), selectedType: GalleryItemType.image);
      state = state.copyWith();

      setSelectedFile(File(pickedFile.path));
    }
  }

  Future getVideo() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      state = state.copyWith(itemToEdit: state.itemToEdit?.copyWith(fileName: null), selectedType: GalleryItemType.video);
      setSelectedFile(File(pickedFile.path));
    }
  }

  Future<void> createOrUpdateItem(WidgetRef ref) async {
    String? fileName = state.itemToEdit?.fileName;
    String? publicUrl = state.itemToEdit?.publicUrl;
    if (state.selectedFile != null) {
      setUploadProgress(0);

      fileName = await _storageBucket.uploadMedia(
        File(state.selectedFile!.path),
        onProgress: setUploadProgress,
        onError: setError,
      );
      publicUrl = await _storageBucket.getPublicUrl(fileName);

      setUploadProgress(null);
      if (state.itemToEdit?.fileName != null) _storageBucket.deleteMedia(state.itemToEdit!.fileName);
    }

    if (state.itemToEdit != null) {
      GalleryItem updatedItem = state.itemToEdit!.copyWith(
        description: state.descriptionController.text,
        fileName: fileName,
        publicUrl: publicUrl,
        mediaType: state.selectedType ?? state.itemToEdit!.mediaType,
        time: DateTime.now(),
      );

      await ref.read(homePageStateProvider.notifier).updateGalleryItem(updatedItem);
    } else {
      GalleryItem newItem = GalleryItem(
        description: state.descriptionController.text,
        fileName: fileName!,
        time: DateTime.now(),
        mediaType: state.selectedType!,
        publicUrl: publicUrl!,
      );
      await ref.read(homePageStateProvider.notifier).addGalleryItem(newItem);
    }
  }
}
