import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hear_ai_demo/components/theme_switch.dart';
import 'package:hear_ai_demo/state/create_gallery_item_page_provider.dart';
import 'package:hear_ai_demo/util/validators.dart';

class CreateGalleryItemPage extends ConsumerWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // TODO: maybe move to state

  CreateGalleryItemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Gallery Item'),
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
                child: buildUploadStateIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUploadStateIndicator() {
    return Consumer(
      builder: (context, ref, child) {
        double? uploadProgress = ref.watch(createGalleryItemPageProvider.select((state) => state.uploadProgress));
        return uploadProgress != null
            ? buildUploadProgressIndicator(uploadProgress)
            : ElevatedButton(
                onPressed: () => _submitForm(context, ref),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text('Upload', style: Theme.of(context).textTheme.bodyLarge),
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
          controller: ref.read(createGalleryItemPageProvider).descriptionController,
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
        File? selectedFile = ref.watch(createGalleryItemPageProvider.select((value) => value.selectedFile));
        return GestureDetector(
          onTap: () => ref.read(createGalleryItemPageProvider.notifier).getImage(),
          child: SizedBox(
            height: 250,
            width: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: cardBorderRadius,
              ),
              child: selectedFile == null
                  ? const Center(child: Text('Tap to select media'))
                  : ClipRRect(
                      borderRadius: cardBorderRadius,
                      child: Image.file(
                        File(selectedFile.path),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  void _submitForm(BuildContext context, WidgetRef ref) async {
    CreateGalleryItemPageState state = ref.read(createGalleryItemPageProvider);
    if (state.selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a media file')));
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    ref.read(createGalleryItemPageProvider.notifier).createEntry(ref, () => onUploadComplete(context));
  }

  void onUploadComplete(BuildContext context) {
    if (context.mounted) {
      GoRouter.of(context).pop();
    }
  }
}
