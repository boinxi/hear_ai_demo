import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hear_ai_demo/components/theme_switch.dart';
import 'package:hear_ai_demo/entities/gallary_item.dart';
import 'package:hear_ai_demo/entities/gallary_item_type.dart';
import 'package:hear_ai_demo/state/home_page_providor.dart';
import 'package:hear_ai_demo/util/validators.dart';

class CreateGalleryItemPage extends ConsumerStatefulWidget {
  const CreateGalleryItemPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateGalleryItemPageState();
}

class _CreateGalleryItemPageState extends ConsumerState<CreateGalleryItemPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();

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
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: createNonEmptyValidator('Description'),
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Upload'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      GalleryItem newItem = GalleryItem(
        description: _descriptionController.text,
        mediaUrl: 'https://picsum.photos/500/500',
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
