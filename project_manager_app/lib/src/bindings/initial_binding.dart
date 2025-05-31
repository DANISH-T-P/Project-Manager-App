import 'package:get/get.dart';
import 'package:project_manager_app/src/controllers/home/home_controller.dart';
import '../controllers/auth/auth_controller.dart';
import '../controllers/auth/splash_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashScreenController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(HomeController(), permanent: true);
  }
}
