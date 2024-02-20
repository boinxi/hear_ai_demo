import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hear_ai_demo/components/theme_switch.dart';
import 'package:hear_ai_demo/entities/gallery_item.dart';
import 'package:hear_ai_demo/pages/createEditItemPage/media_upload_section.dart';
import 'package:hear_ai_demo/pages/createEditItemPage/upload_state_indicator.dart';
import 'package:hear_ai_demo/state/providers.dart';
import 'package:hear_ai_demo/state/state/create_edit_page_state.dart';
import 'package:hear_ai_demo/util/validators.dart';

class CreateEditItemPage extends ConsumerWidget {
  final int? toEditId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CreateEditItemPage({Key? key, this.toEditId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GalleryItem? itemToEdit = ref.watch(createEditItemPageProvider(toEditId).select((value) => value.itemToEdit));

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
                    MediaUploadSection(toEditId),
                    buildDescriptionField(ref),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: UploadStateIndicator(toEditId, itemToEdit != null, () => tryUpload(context, ref)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDescriptionField(WidgetRef ref) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextFormField(
          controller: ref.read(createEditItemPageProvider(toEditId)).descriptionController,
          minLines: 1,
          maxLines: 5,
          decoration: const InputDecoration(labelText: 'Description'),
          validator: createNonEmptyValidator('Description'),
        ),
      );

  void tryUpload(BuildContext context, WidgetRef ref) async {
    CreateEditGalleryItemPageState state = ref.read(createEditItemPageProvider(toEditId));
    if (state.selectedFile == null && state.itemToEdit?.fileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a media file')));
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    await ref.read(createEditItemPageProvider(toEditId).notifier).createOrUpdateItem(ref);
    if (context.mounted) {
      GoRouter.of(context).pop();
    }
  }
}
