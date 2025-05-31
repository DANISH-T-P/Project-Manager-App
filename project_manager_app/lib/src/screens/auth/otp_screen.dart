import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../utils/appcolors.dart';
import '../../utils/custom_snackbar.dart';
import '../../utils/ui_helper.dart';

class OtpScreen extends GetView<AuthController> {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final otpController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            UiHelper.header(
              title: "Otp Verification",
              subtitle: '',
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
                    UiHelper.label("ENTER OTP"),
                    const SizedBox(height: 4),
                    CustomInputField(
                      hint: "123456",
                      controller: otpController,
                    ),
                    const SizedBox(height: 16),
                    UiHelper.button("Verify OTP", () async {
                      final otp = otpController.text.trim();
                      if (otp.isEmpty) {
                        CustomSnackbar.warning("Empty OTP", "Please enter the OTP");
                        return;
                      }
                      await controller.verifyOtp(otp);
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
