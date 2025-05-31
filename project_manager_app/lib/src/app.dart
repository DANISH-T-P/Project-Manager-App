import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_manager_app/src/bindings/home_binding.dart';
import 'package:project_manager_app/src/screens/auth/forgot_password_screen.dart';
import 'package:project_manager_app/src/screens/auth/login_screen.dart';
import 'package:project_manager_app/src/screens/auth/login_with_phone_screen.dart';
import 'package:project_manager_app/src/screens/auth/otp_screen.dart';
import 'package:project_manager_app/src/screens/auth/signup_screen.dart';
import 'package:project_manager_app/src/screens/auth/splash_screen.dart';
import 'package:project_manager_app/src/screens/home/home_ui.dart';
import '../src/bindings/initial_binding.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Project Manager',
      initialBinding: InitialBinding(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/signup', page: () => const SignUpScreen()),
        GetPage(name: '/otp', page: () => const OtpScreen()),
        GetPage(name: '/phone', page: () => const LoginPhoneScreen()),
        GetPage(name: '/forgot', page: () => ForgotPasswordScreen()),
        GetPage(name: '/home', page: () => const HomeUI(), binding: HomeBinding()),
      ],
    );
  }
}
