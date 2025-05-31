import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class MediaPreviewScreen extends StatefulWidget {
  final String url;
  final bool isVideo;

  const MediaPreviewScreen({super.key, required this.url, required this.isVideo});

  @override
  State<MediaPreviewScreen> createState() => _MediaPreviewScreenState();
}

class _MediaPreviewScreenState extends State<MediaPreviewScreen> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _videoController = VideoPlayerController.network(widget.url)
        ..initialize().then((_) => setState(() {}))
        ..play();
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _shareMedia() async {
    final dir = await getTemporaryDirectory();
    final filename = widget.url.split('/').last;
    final filePath = '${dir.path}/$filename';

    await Dio().download(widget.url, filePath);
    Share.shareXFiles([XFile(filePath)], text: 'Check this out!');
  }

  Future<void> _downloadMedia() async {
    final dir = await getApplicationDocumentsDirectory();
    final filename = widget.url.split('/').last;
    final filePath = '${dir.path}/$filename';

    await Dio().download(widget.url, filePath);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Downloaded to $filePath'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Media Preview"),
        actions: [
          IconButton(onPressed: _shareMedia, icon: const Icon(Icons.share)),
          IconButton(onPressed: _downloadMedia, icon: const Icon(Icons.download)),
        ],
      ),
      body: Center(
        child: widget.isVideo
            ? _videoController != null && _videoController!.value.isInitialized
            ? AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: VideoPlayer(_videoController!),
        )
            : const CircularProgressIndicator()
            : PhotoView(imageProvider: NetworkImage(widget.url)),
      ),
    );
  }
}
