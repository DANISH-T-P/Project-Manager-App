import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../utils/appcolors.dart';
import '../../utils/custom_snackbar.dart';
import '../../utils/ui_helper.dart';
import 'login_screen.dart';

class SignUpScreen extends GetView<AuthController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final passController = TextEditingController();
    final repassController = TextEditingController();
    final isLoading = false.obs;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      UiHelper.label("NAME"),
                      CustomInputField(hint: "Your name", controller: nameController),
                      const SizedBox(height: 16),
                      UiHelper.label("EMAIL"),
                      CustomInputField(hint: "example@gmail.com", controller: emailController),
                      const SizedBox(height: 16),
                      UiHelper.label("PHONE NUMBER"),
                      CustomInputField(hint: "+91 123 456 7890", controller: phoneController),
                      const SizedBox(height: 16),
                      UiHelper.label("PASSWORD"),
                      CustomInputField(hint: "********", isPassword: true, controller: passController),
                      const SizedBox(height: 16),
                      UiHelper.label("RE-TYPE PASSWORD"),
                      CustomInputField(hint: "********", isPassword: true, controller: repassController),
                      const SizedBox(height: 24),
                      Obx(() => UiHelper.button(
                        isLoading.value ? "Signing up..." : "SIGN UP",
                        isLoading.value
                            ? () {}
                            : () async {
                          final name = nameController.text.trim();
                          final email = emailController.text.trim();
                          final phone = phoneController.text.trim();
                          final pass = passController.text.trim();
                          final repass = repassController.text.trim();

                          if ([name, email, phone, pass, repass].any((e) => e.isEmpty)) {
                            CustomSnackbar.warning("Missing Fields", "Please fill in all fields");
                            return;
                          }

                          if (pass.length < 6) {
                            CustomSnackbar.warning("Password Error", "Minimum 6 characters required");
                            return;
                          }

                          if (pass != repass) {
                            CustomSnackbar.warning("Password Mismatch", "Passwords do not match");
                            return;
                          }

                          try {
                            isLoading.value = true;
                            await controller.signUpUser(
                              name: name,
                              email: email,
                              phone: phone,
                              password: pass,
                            );
                            Get.offAll(() => const LoginScreen());
                          } finally {
                            isLoading.value = false;
                          }
                        },
                      )),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          TextButton(
                            onPressed: () => Get.offAll(() => const LoginScreen()),
                            child: const Text("LOG IN", style: TextStyle(color: AppColors.button)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
