import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth/splash_controller.dart';
import '../../utils/appcolors.dart';

class SplashScreen extends GetView<SplashScreenController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Center(
        child: Obx(
          () => controller.navigate.value
              ? controller.buildAnimatedText()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
                    controller.buildAnimatedText(),
                    const SizedBox(height: 30),
                    Expanded(child: SizedBox()),
                    Column(
                      children: [
                        DropdownButton<int>(
                          value: controller.selectedAnimation.value,
                          items: List.generate(
                            controller.animationNames.length,
                            (i) => DropdownMenuItem(
                              value: i + 1,
                              child: Row(
                                children: [
                                  Text(
                                    '${i + 1}.',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(controller.animationNames[i]),
                                ],
                              ),
                            ),
                          ),
                          onChanged: (val) {
                            if (val != null) {
                              controller.selectedAnimation.value = val;
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: controller.reloadAnimation,
                          child: const Text("Reload"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
        ),
      ),
    );
  }
}
