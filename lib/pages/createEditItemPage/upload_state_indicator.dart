import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hear_ai_demo/state/providers.dart';

class UploadStateIndicator extends ConsumerWidget {
  final VoidCallback onUploadUpdateTap;
  final int? toEditId;
  final bool isEditing;

  const UploadStateIndicator(this.toEditId, this.isEditing, this.onUploadUpdateTap, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double? uploadProgress = ref.watch(createGalleryItemPageProvider(toEditId).select((state) => state.uploadProgress));
    if (uploadProgress != null) return buildUploadProgressIndicator(uploadProgress);
    return ElevatedButton(
      onPressed: onUploadUpdateTap,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Text(isEditing ? 'Update' : 'Upload', style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }

  Widget buildUploadProgressIndicator(double? uploadProgress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: LinearProgressIndicator(value: uploadProgress),
    );
  }

}
