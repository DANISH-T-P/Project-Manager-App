import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/home/home_ui.dart';
import '../../utils/custom_snackbar.dart';

class AuthController extends GetxController {
  /// Input Controllers
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final rememberMe = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rxn<User?> firebaseUser = Rxn<User?>();
  String? _verificationId;

  @override
  void onInit() {
    firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  bool get isLoggedIn => firebaseUser.value != null;

  /// Login with Email/Password
  Future<void> login() async {
    final email = emailController.text.trim();
    final pass = passController.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      CustomSnackbar.warning("Input Error", "Please enter both email and password");
      return;
    }

    if (pass.length < 6) {
      CustomSnackbar.warning("Input Error", "Password must be at least 6 characters");
      return;
    }

    try {
      /// Only set persistence for web — not needed on Android/iOS
      if (GetPlatform.isWeb) {
        await _auth.setPersistence(
          rememberMe.value ? Persistence.LOCAL : Persistence.SESSION,
        );
      }

      await _auth.signInWithEmailAndPassword(email: email, password: pass);

      /// Save rememberMe only if truly used
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('rememberMe', rememberMe.value);

      CustomSnackbar.success("Login Successful", "Welcome back!");
      CustomSnackbar.console.success("Login Successful", "User ID: ${_auth.currentUser?.uid}");

      Get.offAll(() => const HomeUI());
    } on FirebaseAuthException catch (e) {
      /// More specific Firebase error handling
      String message = switch (e.code) {
        'user-not-found' => "No user found for that email.",
        'wrong-password' => "Incorrect password provided.",
        'invalid-email' => "The email address is badly formatted.",
        _ => "Authentication failed. Please try again.",
      };

      CustomSnackbar.info("Login Failed", message);
      CustomSnackbar.console.info("FirebaseAuth Error", "Code: ${e.code}, Message: ${e.message}");
    } catch (e) {
      CustomSnackbar.error("Unexpected Error", "Something went wrong.");
      CustomSnackbar.console.error("Login Exception", e.toString());
    }
  }

  /// Signup New User
  Future<void> signUpUser({required String name, required String email, required String phone, required String password,}) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'phone': phone,
        });

        CustomSnackbar.success("Signup Successful", "Account created successfully");
        CustomSnackbar.console.success("Signup Successful", "Account created successfully ---- name: $name, email: $email, phone: $phone,");
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          CustomSnackbar.warning('Weak Password', 'The password provided is too weak.');
          break;
        case 'email-already-in-use':
          CustomSnackbar.warning('Email In Use', 'The account already exists for that email.');
          break;
        default:
          CustomSnackbar.error('Signup Error', e.message ?? 'Something went wrong');
      }
      CustomSnackbar.console.error("Signup Error", e.toString());
      rethrow;
    }
  }

  /// Send Reset Email
  Future<void> sendResetLink(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      CustomSnackbar.success("Success", "Reset link sent to $email");
      CustomSnackbar.console.success("Success", "Reset link sent to $email");
    } catch (e) {
      CustomSnackbar.error("Reset Failed", e.toString());
      CustomSnackbar.console.error("Reset Link Error", e.toString());
    }
  }

  /// Phone Number Login
  Future<void> verifyPhoneNumber(String number, bool rememberMe) async {
    await _auth.setPersistence(
      GetPlatform.isWeb
          ? (rememberMe ? Persistence.LOCAL : Persistence.SESSION)
          : (rememberMe ? Persistence.LOCAL : Persistence.NONE),
    );

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91$number",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          CustomSnackbar.success("Success", "Phone auto-verified");
          Get.offAll(() => const HomeUI());
        },
        verificationFailed: (FirebaseAuthException e) {
          CustomSnackbar.error("Phone Auth Failed", e.message ?? "Error");
          CustomSnackbar.console.error("Phone Auth Error", e.toString());
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          Get.toNamed("/otp", arguments: verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      CustomSnackbar.error("Verification Failed", e.toString());
      CustomSnackbar.console.error("Phone Verification Error", e.toString());
    }
  }

  /// OTP Verification
  Future<void> verifyOtp(String smsCode) async {
    try {
      if (_verificationId == null) throw Exception("Verification ID is null");

      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      await _auth.signInWithCredential(credential);
      CustomSnackbar.success("OTP Verified", "You are logged in");
      CustomSnackbar.console.success("OTP Verified", "credential: $credential ----");
      Get.offAll(() => const HomeUI());
    } catch (e) {
      CustomSnackbar.error("OTP Error", "Invalid or expired OTP");
      CustomSnackbar.console.error("OTP Verification Error", e.toString());
    }
  }

  /// Logout
  Future<void> signOut() async {
    await _auth.signOut();
    Get.offAllNamed('/login');
    CustomSnackbar.info("Signed Out", "You have been logged out.");
    CustomSnackbar.console.info("Signed Out", "You have been logged out.");
  }
}
