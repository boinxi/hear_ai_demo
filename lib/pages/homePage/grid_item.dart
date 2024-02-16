import 'package:flutter/material.dart';
import 'package:hear_ai_demo/entities/gallary_item.dart';

class GridItem extends StatelessWidget {
  final GalleryItem item;

  const GridItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(item.id?.toString() ?? "no id"),
          Expanded(child: Image.network(item.mediaUrl)),
          Text(item.description),
        ],
      ),
    );
  }
}
