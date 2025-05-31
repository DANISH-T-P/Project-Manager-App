import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import '../models/project_model.dart';

class MediaService {
  final storage = FirebaseStorage.instance;

  Future<MediaFile> uploadMedia({
    required File file,
    required String projectId,
    required bool isVideo,
  }) async {
    final folder = isVideo ? 'videos' : 'images';
    final filename = basename(file.path);
    final storagePath = 'projects/$projectId/$folder/$filename';
    final ref = storage.ref().child(storagePath);

    final task = await ref.putFile(file);
    final downloadUrl = await ref.getDownloadURL();

    return MediaFile(
      filename: filename,
      storagePath: storagePath,
      downloadUrl: downloadUrl,
      uploadedAt: DateTime.now(),
    );
  }

  Future<void> deleteMedia(MediaFile mediaFile) async {
    final ref = storage.ref(mediaFile.storagePath);
    await ref.delete();
  }
}
