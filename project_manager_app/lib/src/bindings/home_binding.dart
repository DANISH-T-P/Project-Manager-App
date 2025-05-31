// File: lib/bindings/home_binding.dart

import 'package:get/get.dart';
import '../controllers/home/home_controller.dart';
import '../controllers/home/home_screen_controller.dart';
import '../controllers/home/profile_controller.dart';
import '../controllers/home/project_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.put(HomeScreenController());
    Get.put(ProjectController());
    Get.put(ProfileController());
  }
}
