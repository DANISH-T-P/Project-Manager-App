import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/project_model.dart';
import '../../services/storage_service.dart';
import '../../widgets/project_form.dart';

class ProjectController extends GetxController {
  final projects = <Project>[].obs;
  final isLoading = true.obs;
  final _mediaService = MediaService();

  @override
  void onInit() {
    listenToProjects();
    super.onInit();
  }

  void listenToProjects() {
    FirebaseFirestore.instance
        .collection('projects')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .listen((snapshot) {
      projects.value = snapshot.docs.map((doc) => Project.fromDoc(doc)).toList();
      isLoading.value = false;
    });
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await FirebaseFirestore.instance.collection('projects').doc(projectId).delete();
    } catch (e) {
      Get.snackbar("Error", "Failed to delete project");
    }
  }

  Future<void> confirmDelete(String projectId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this project?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await deleteProject(projectId);
    }
  }

  String formatDate(DateTime date) {
    return DateFormat.yMMMd().add_jm().format(date);
  }

  void openProjectForm({Project? project}) {
    final isEdit = project != null;

    final formProject = project ??
        Project(
          id: FirebaseFirestore.instance.collection('projects').doc().id,
          name: '',
          description: '',
          status: '',
          address: '',
          latitude: 0.0,
          longitude: 0.0,
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          images: [],
          videos: [],
        );

    Get.to(() => ProjectsFormScreen(project: formProject, isEdit: isEdit));
  }

  Future<void> addMediaToProject({
    required String projectId,
    required File file,
    required bool isVideo,
  }) async {
    final docRef = FirebaseFirestore.instance.collection('projects').doc(projectId);
    final snapshot = await docRef.get();
    final project = Project.fromDoc(snapshot);

    final mediaFile = await _mediaService.uploadMedia(
      file: file,
      projectId: projectId,
      isVideo: isVideo,
    );

    final updatedList = isVideo
        ? [...project.videos, mediaFile]
        : [...project.images, mediaFile];

    await docRef.update({
      isVideo ? 'videos' : 'images': updatedList.map((e) => e.toMap()).toList(),
    });
  }

  Future<void> deleteMediaFromProject({
    required String projectId,
    required MediaFile media,
    required bool isVideo,
  }) async {
    final docRef = FirebaseFirestore.instance.collection('projects').doc(
        projectId);
    final snapshot = await docRef.get();
    final project = Project.fromDoc(snapshot);

    final updatedList = (isVideo ? project.videos : project.images)
        .where((m) => m.downloadUrl != media.downloadUrl)
        .toList();

    await _mediaService.deleteMedia(media);

    await docRef.update({
      isVideo ? 'videos' : 'images': updatedList.map((e) => e.toMap()).toList(),
    });
  }

}
