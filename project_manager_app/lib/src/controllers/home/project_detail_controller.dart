import 'package:get/get.dart';
import '../../models/project_model.dart';

class ProjectDetailController extends GetxController {
  final Project project;
  final selectedTab = 'Images'.obs;

  ProjectDetailController(this.project);

  List<MediaFile> get currentMedia =>
      selectedTab.value == 'Images' ? project.images : project.videos;

  void switchTab(String tab) => selectedTab.value = tab;
}
