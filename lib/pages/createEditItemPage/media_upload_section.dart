import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hear_ai_demo/components/media/media_preview.dart';
import 'package:hear_ai_demo/entities/gallery_item_type.dart';
import 'package:hear_ai_demo/pages/createEditItemPage/media_type_picker.dart';
import 'package:hear_ai_demo/state/providers.dart';
import 'package:hear_ai_demo/state/state/create_edit_page_state.dart';

class MediaUploadSection extends ConsumerWidget {
  final int? toEditId;

  const MediaUploadSection(this.toEditId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => onUploadMediaTap(ref, context),
      child: SizedBox(
        height: 250,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: buildPreview(ref),
        ),
      ),
    );
  }

  buildPreview(WidgetRef ref) {
    CreateGalleryItemPageState state = ref.watch(createGalleryItemPageProvider(toEditId));
    final String? uri = state.selectedFile?.path ?? state.itemToEdit?.publicUrl;

    if (uri == null) return const Card(child: Center(child: Text('Tap to select media')));

    GalleryItemType type = state.selectedType ?? state.itemToEdit!.mediaType;
    return MediaPreview(uri: uri, type: type, isNetworkSource: state.selectedFile?.path == null);
  }

  void onUploadMediaTap(WidgetRef ref, context) async {
    final GalleryItemType? selectedMediaType =
        await showModalBottomSheet<GalleryItemType>(context: context, builder: (BuildContext context) => const MediaTypePicker());
    if (selectedMediaType == null) return;
    if (selectedMediaType == GalleryItemType.image) {
      ref.read(createGalleryItemPageProvider(toEditId).notifier).getImage();
    } else {
      ref.read(createGalleryItemPageProvider(toEditId).notifier).getVideo();
    }
  }
}
