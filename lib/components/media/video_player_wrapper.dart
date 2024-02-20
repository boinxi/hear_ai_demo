import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hear_ai_demo/state/providers.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWrapper extends ConsumerStatefulWidget {
  final String uri;
  final bool isNetworkSource;

  const VideoPlayerWrapper({Key? key, required this.uri, required this.isNetworkSource}) : super(key: key);

  @override
  ConsumerState<VideoPlayerWrapper> createState() => _VideoPlayerWrapperState();
}

class _VideoPlayerWrapperState extends ConsumerState<VideoPlayerWrapper> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _controller?.value.isInitialized ?? false
        ? AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          )
        : const Center(child: CircularProgressIndicator());
  }

  void initPlayer() async {
    if (widget.isNetworkSource) {
      String videoPublicUrl = await ref.read(storageBucketProvider).getPublicUrl(widget.uri);
      _controller = VideoPlayerController.networkUrl(Uri.parse(videoPublicUrl));
    } else {
      _controller = VideoPlayerController.file(File(widget.uri));
    }
    await _controller!.initialize();

    if (mounted) {
      setState(() {});
      _controller!.play();
    }
  }
}
