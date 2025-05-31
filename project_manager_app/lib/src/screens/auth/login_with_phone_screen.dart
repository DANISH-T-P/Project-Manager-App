import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../utils/appcolors.dart';
import '../../utils/custom_snackbar.dart';
import '../../utils/ui_helper.dart';

class LoginPhoneScreen extends GetView<AuthController> {
  const LoginPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            UiHelper.header(
              title: "Log In with Phone Number",
              subtitle: "Please sign in to your existing account",
              context: context,
              showBack: true,
              titleColor: Colors.black,
              subtitleColor: Colors.black,
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    UiHelper.label("PHONE NUMBER"),
                    const SizedBox(height: 4),
                    CustomInputField(
                      hint: "+91 123 456 7890",
                      controller: phoneController,
                    ),
                    const SizedBox(height: 16),
                    Obx(() => Row(
                      children: [
                        Checkbox(
                          value: controller.rememberMe.value,
                          onChanged: (value) => controller.rememberMe.value = value ?? false,
                        ),
                        const Text("Remember me"),
                      ],
                    )),
                    const SizedBox(height: 8),
                    UiHelper.button("Get OTP", () {
                      final number = phoneController.text.trim();
                      if (number.isEmpty || number.length != 10) {
                        CustomSnackbar.warning("Invalid Input", "Enter a valid 10-digit number");
                      } else {
                        controller.verifyPhoneNumber(number, controller.rememberMe.value);
                      }
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
