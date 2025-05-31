import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth/auth_controller.dart';
import '../../utils/appcolors.dart';
import '../../utils/ui_helper.dart';
import 'forgot_password_screen.dart';
import 'login_with_phone_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            UiHelper.header(
              title: "Log In",
              subtitle: "Please sign in to your existing account",
              context: context,
              showBack: false,
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
                    UiHelper.label("EMAIL"),
                    const SizedBox(height: 4),
                    CustomInputField(
                      hint: "admin@gmail.com",
                      controller: controller.emailController,
                    ),
                    const SizedBox(height: 16),
                    UiHelper.label("PASSWORD"),
                    const SizedBox(height: 4),
                    CustomInputField(
                      hint: "admin@123",
                      isPassword: true,
                      controller: controller.passController,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => Row(
                          children: [
                            Checkbox(
                              value: controller.rememberMe.value,
                              onChanged: (value) {
                                controller.rememberMe.value = value ?? false;
                              },
                            ),
                            const Text("Remember me"),
                          ],
                        )),
                        TextButton(
                          onPressed: () => Get.to(() => ForgotPasswordScreen()),
                          child: const Text(
                            "Forgot Password",
                            style: TextStyle(color: AppColors.button),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    UiHelper.button("LOG IN", controller.login),
                    const SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () => Get.to(() => LoginPhoneScreen()),
                            child: const Text(
                              "Login with Phone Number?",
                              style: TextStyle(color: AppColors.button),
                            ),
                          ),
                          const Text("Or"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        CircleAvatar(child: Icon(Icons.facebook)),
                        CircleAvatar(child: Icon(Icons.email)),
                        CircleAvatar(child: Icon(Icons.apple)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don’t have an account? "),
                        TextButton(
                          onPressed: () => Get.to(() => SignUpScreen()),
                          child: const Text(
                            "SIGN UP",
                            style: TextStyle(color: AppColors.button),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
