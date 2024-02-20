import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hear_ai_demo/entities/gallery_item.dart';
import 'package:hear_ai_demo/entities/gallery_item_type.dart';

class CreateGalleryItemPageState {
  // TODO: hanldle errors in upload
  TextEditingController descriptionController;
  File? selectedFile;
  GalleryItemType? selectedType;
  double? uploadProgress;
  GalleryItem? itemToEdit;
  String? error;

  CreateGalleryItemPageState(this.descriptionController, {this.selectedFile, this.selectedType, this.uploadProgress, this.itemToEdit, this.error});

  CreateGalleryItemPageState copyWith(
      {File? selectedFile, GalleryItemType? selectedType, double? uploadProgress, GalleryItem? itemToEdit, String? error}) {
    return CreateGalleryItemPageState(
      descriptionController,
      selectedFile: selectedFile ?? this.selectedFile,
      selectedType: selectedType ?? this.selectedType,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      itemToEdit: itemToEdit ?? this.itemToEdit,
      error: error ?? error,
    );
  }
}
