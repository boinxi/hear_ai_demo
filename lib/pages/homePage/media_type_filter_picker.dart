import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hear_ai_demo/entities/media_filter.dart';
import 'package:hear_ai_demo/state/providers.dart';

class MediaTypeFilterPicker extends ConsumerWidget {
  const MediaTypeFilterPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MediaFilter currentFilter = ref.watch(homePageStateProvider.select((state) => state.filter));
    return DropdownButton<MediaFilter>(
      value: currentFilter,
      onChanged: (MediaFilter? newValue) {
        ref.read(homePageStateProvider.notifier).setFilter(newValue);
      },
      items: const [
        DropdownMenuItem<MediaFilter>(
          value: MediaFilter.none,
          child: Text('All'),
        ),
        DropdownMenuItem<MediaFilter>(
          value: MediaFilter.image,
          child: Text('Images'),
        ),
        DropdownMenuItem<MediaFilter>(
          value: MediaFilter.video,
          child: Text('Videos'),
        ),
      ],
    );
  }
}
