import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../utils/custom_snackbar.dart';

class ForgotPasswordScreen extends GetView<AuthController> {
  ForgotPasswordScreen({super.key});

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Enter your email"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final email = emailController.text.trim();
                if (email.isEmpty) {
                  CustomSnackbar.warning("Input Error", "Please enter your email address.");
                } else {
                  controller.sendResetLink(email);
                }
              },
              child: const Text("Send Reset Link"),
            )
          ],
        ),
      ),
    );
  }
}
