import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hear_ai_demo/components/theme_switch.dart';
import 'package:hear_ai_demo/entities/gallery_item.dart';
import 'package:hear_ai_demo/state/providers.dart';
import 'package:hear_ai_demo/state/state/create_edit_page_state.dart';
import 'package:hear_ai_demo/util/validators.dart';

class CreateEditItemPage extends ConsumerWidget {
  final int? toEditId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // TODO: maybe move to state

  CreateEditItemPage({Key? key, this.toEditId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GalleryItem? itemToEdit = ref.watch(createGalleryItemPageProvider(toEditId).select((value) => value.itemToEdit));
    return Scaffold(
      appBar: AppBar(
        title: Text('${itemToEdit == null ? 'Create' : 'Edit'} Gallery Item'),
        actions: const [ThemeSwitch()],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    buildMediaPreview(),
                    buildDescriptionField(ref),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: buildUploadStateIndicator(itemToEdit != null),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUploadStateIndicator(bool isEditing) {
    return Consumer(
      builder: (context, ref, child) {
        double? uploadProgress = ref.watch(createGalleryItemPageProvider(toEditId).select((state) => state.uploadProgress));
        return uploadProgress != null
            ? buildUploadProgressIndicator(uploadProgress)
            : ElevatedButton(
                onPressed: () => _submitForm(context, ref),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(isEditing ? 'Update' : 'Upload', style: Theme.of(context).textTheme.bodyLarge),
                ),
              );
      },
    );
  }

  Widget buildUploadProgressIndicator(double? uploadProgress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: LinearProgressIndicator(value: uploadProgress),
    );
  }

  Widget buildDescriptionField(WidgetRef ref) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextFormField(
          controller: ref.read(createGalleryItemPageProvider(toEditId)).descriptionController,
          // TODO: check if im allowed
          minLines: 1,
          maxLines: 5,
          decoration: const InputDecoration(labelText: 'Description'),
          validator: createNonEmptyValidator('Description'),
        ),
      );

  Widget buildMediaPreview() {
    final cardBorderRadius = BorderRadius.circular(10);
    return Consumer(
      builder: (context, ref, child) {
        File? selectedFile = ref.watch(createGalleryItemPageProvider(toEditId).select((value) => value.selectedFile));
        String? toEditMediaUrl = ref.watch(createGalleryItemPageProvider(toEditId).select((value) => value.itemToEdit?.mediaUrl));
        return GestureDetector(
          onTap: () => ref.read(createGalleryItemPageProvider(toEditId).notifier).getImage(),
          child: SizedBox(
            height: 250,
            width: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: cardBorderRadius,
              ),
              child: selectedFile != null
                  ? ClipRRect(
                      borderRadius: cardBorderRadius,
                      child: Image.file(
                        File(selectedFile.path),
                        fit: BoxFit.fitWidth,
                      ),
                    )
                  : toEditMediaUrl != null
                      ? ClipRRect(
                          borderRadius: cardBorderRadius,
                          child: Image.network(
                            toEditMediaUrl,
                            fit: BoxFit.fitWidth,
                          ),
                        )
                      : const Center(child: Text('Tap to select media')),
            ),
          ),
        );
      },
    );
  }

  void _submitForm(BuildContext context, WidgetRef ref) async {
    CreateGalleryItemPageState state = ref.read(createGalleryItemPageProvider(toEditId));
    if (state.selectedFile == null && state.itemToEdit?.mediaUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a media file')));
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    await ref.read(createGalleryItemPageProvider(toEditId).notifier).createOrUpdateItem(ref);
    if (context.mounted) {
      GoRouter.of(context).pop();
    }
  }
}
