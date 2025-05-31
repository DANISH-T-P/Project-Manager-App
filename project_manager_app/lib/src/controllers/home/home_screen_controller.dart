import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../models/project_model.dart';

class HomeScreenController extends GetxController {
  final searchQuery = ''.obs;
  final allProjects = <Project>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    _listenToProjects();
    super.onInit();
  }

  void _listenToProjects() {
    FirebaseFirestore.instance
        .collection('projects')
        .snapshots()
        .listen((snapshot) {
      final projects = snapshot.docs.map((doc) => Project.fromDoc(doc)).toList();
      allProjects.assignAll(projects);
      isLoading.value = false;
    });
  }

  List<Project> get filteredProjects {
    if (searchQuery.isEmpty) return allProjects;
    return allProjects
        .where((p) => p.name.toLowerCase().contains(searchQuery.value))
        .toList();
  }

  void updateSearch(String value) {
    searchQuery.value = value.trim().toLowerCase();
  }
}
