import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hear_ai_demo/entities/gallery_item.dart';

class CreateGalleryItemPageState {
  // TODO: hanldle errors in upload
  TextEditingController descriptionController;
  File? selectedFile;
  GalleryItem? itemToEdit;
  double? uploadProgress;

  CreateGalleryItemPageState(this.descriptionController, {this.selectedFile, this.uploadProgress, this.itemToEdit});

  CreateGalleryItemPageState copyWith({File? selectedFile, double? uploadProgress, GalleryItem? itemToEdit}) {
    return CreateGalleryItemPageState(
      descriptionController,
      selectedFile: selectedFile ?? this.selectedFile,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      itemToEdit: itemToEdit ?? this.itemToEdit,
    );
  }
}
