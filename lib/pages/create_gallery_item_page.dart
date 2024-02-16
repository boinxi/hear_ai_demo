import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hear_ai_demo/components/theme_switch.dart';
import 'package:hear_ai_demo/entities/gallary_item.dart';
import 'package:hear_ai_demo/entities/gallary_item_type.dart';
import 'package:hear_ai_demo/services/firebase_service.dart';
import 'package:hear_ai_demo/state/home_page_providor.dart';
import 'package:hear_ai_demo/util/validators.dart';
import 'package:image_picker/image_picker.dart';

class CreateGalleryItemPage extends ConsumerStatefulWidget {
  const CreateGalleryItemPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateGalleryItemPageState();
}

class _CreateGalleryItemPageState extends ConsumerState<CreateGalleryItemPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  XFile? _selectedFile;
  double? _uploadProgress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Gallery Item'),
        actions: const [ThemeSwitch()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildMediaPreview(),
              buildDescriptionField(),
              _uploadProgress != null
                  ? buildUploadProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Upload'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUploadProgressIndicator() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: LinearProgressIndicator(value: _uploadProgress),
      );

  Widget buildDescriptionField() => TextFormField(
        controller: _descriptionController,
        decoration: const InputDecoration(labelText: 'Description'),
        validator: createNonEmptyValidator('Description'),
      );

  Widget buildMediaPreview() => GestureDetector(
        onTap: getImage,
        child: SizedBox(
          width: 200,
          height: 200,
          child: Card(
            child: _selectedFile == null
                ? const Center(child: Text('Tap to select media'))
                : Image.file(
                    File(_selectedFile!.path),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      );

  Future getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedFile = pickedFile;
      });
    }
  }

  void _submitForm() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a media file')));
      return;
    }
    if (_formKey.currentState!.validate()) {
      setState(() {
        _uploadProgress = 0.0;
      });
      String path = await uploadMedia(
        File(_selectedFile!.path),
        onProgress: (event) {
          setState(() {
            _uploadProgress = event.bytesTransferred / event.totalBytes;
          });
        },
      );
      setState(() {
        _uploadProgress = null;
      });
      GalleryItem newItem = GalleryItem(
        description: _descriptionController.text,
        mediaUrl: path,
        time: DateTime.now(),
        mediaType: GalleryItemType.image,
      );
      await ref.read(homePageStateProvider.notifier).addGalleryItem(newItem);
      if (mounted) {
        GoRouter.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
