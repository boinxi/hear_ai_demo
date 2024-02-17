import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hear_ai_demo/entities/gallery_item.dart';
import 'package:hear_ai_demo/entities/gallery_item_type.dart';
import 'package:hear_ai_demo/services/firebase_service.dart';
import 'package:hear_ai_demo/state/home_page_provider.dart';
import 'package:image_picker/image_picker.dart';

class CreateGalleryItemPageState {
  // TODO: hanldle errors in upload
  TextEditingController descriptionController;
  File? selectedFile;
  double? uploadProgress;

  CreateGalleryItemPageState(this.descriptionController, {this.selectedFile, this.uploadProgress});

  CreateGalleryItemPageState copyWith({File? selectedFile, double? uploadProgress}) {
    return CreateGalleryItemPageState(
      descriptionController,
      selectedFile: selectedFile ?? this.selectedFile,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }
}

class CreateGalleryItemPageStateNotifier extends StateNotifier<CreateGalleryItemPageState> {
  CreateGalleryItemPageStateNotifier() : super(CreateGalleryItemPageState(TextEditingController()));

  void setSelectedFile(File? selectedFile) {
    state = state.copyWith(selectedFile: selectedFile);
  }

  void setUploadProgress(double? uploadProgress) {
    state = state.copyWith(uploadProgress: uploadProgress);
  }

  Future getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setSelectedFile(File(pickedFile.path));
    }
  }

  Future<void> createEntry(WidgetRef ref, VoidCallback onComplete) async {
    // TODO: check if i acn get rid of ref
    if (state.selectedFile == null) return;
    setUploadProgress(0);

    String path = await FirebaseService().uploadMedia(
      File(state.selectedFile!.path),
      onProgress: setUploadProgress,
    );
    setUploadProgress(null);
    GalleryItem newItem = GalleryItem(
      description: state.descriptionController.text,
      mediaUrl: path,
      time: DateTime.now(),
      mediaType: GalleryItemType.image,
    );
    await ref.read(homePageStateProvider.notifier).addGalleryItem(newItem);
    onComplete();
  }
}

final createGalleryItemPageProvider = StateNotifierProvider.autoDispose<CreateGalleryItemPageStateNotifier, CreateGalleryItemPageState>(
  // TODO: check if autoDispose is needed
  (ref) => CreateGalleryItemPageStateNotifier(),
);
