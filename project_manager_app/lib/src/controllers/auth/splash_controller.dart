import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:project_manager_app/src/utils/appcolors.dart';
import 'package:shimmer/shimmer.dart';
import '../auth/auth_controller.dart';

class SplashScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TickerProvider get vsync => this;

  late final AnimationController animationController;
  late final Animation<double> fade;
  late final Animation<Offset> slide;
  late final Animation<double> scale;
  late final Animation<double> rotation;

  /// Manual navigation toggle
  RxBool navigate = true.obs;

  /// Dropdown selected animation index
  final RxInt selectedAnimation = 10.obs;

  /// Animation names list for dropdown (20 styles)
  final List<String> animationNames = [
    'Fade',
    'Slide + Fade',
    'Scale + Fade',
    'Rotation',
    'Flip',
    'Bounce',
    'Wavy Text',
    'Typewriter',
    'Shimmer',
    'Neon Flicker',
    'Skew Slide',
    'Color Pulse',
    'Zoom Flip',
    'Shadow Wave',
    'Diagonal Slide',
    'Slide Rotation',
    'Pulse Expand',
    'Scale Shake',
    'Type Zoom',
    'Drop In',
  ];

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 2),
    );
    fade = Tween<double>(begin: 0, end: 1).animate(animationController);
    slide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        );
    scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.elasticOut),
    );
    rotation = Tween<double>(begin: 0.0, end: 1.0).animate(animationController);

    animationController.forward();

    Future.delayed(const Duration(seconds: 4), () {
      if (navigate.value) {
        final user = Get.find<AuthController>().firebaseUser.value;
        if (user == null) {
          Get.offAllNamed('/login');
        } else {
          Get.offAllNamed('/home');
        }
      }
    });
  }

  void reloadAnimation() {
    animationController.reset();
    animationController.forward();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  /// Builds the animated title text widget based on selectedAnimation
  Widget buildAnimatedText() {
    const title = 'Project Manager';
    final index = selectedAnimation.value;

    switch (index) {
      case 1:
        return FadeTransition(
          opacity: fade,
          child: _titleText(title, Colors.blueAccent),
        );
      case 2:
        return SlideTransition(
          position: slide,
          child: FadeTransition(
            opacity: fade,
            child: _titleText(title, Colors.teal),
          ),
        );
      case 3:
        return ScaleTransition(
          scale: scale,
          child: FadeTransition(
            opacity: fade,
            child: _titleText(title, Colors.deepPurple),
          ),
        );
      case 4:
        return RotationTransition(
          turns: rotation,
          child: _titleText(title, Colors.green),
        );
      case 5:
        return AnimatedBuilder(
          animation: animationController,
          child: _titleText(title, Colors.cyan),
          builder: (context, child) {
            final angle = animationController.value * pi;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(angle),
              child: child,
            );
          },
        );
      case 6:
        return ScaleTransition(
          scale: scale,
          child: _titleText('$title (Bounce)', Colors.indigo),
        );
      case 7:
        return AnimatedTextKit(
          totalRepeatCount: 1,
          animatedTexts: [
            WavyAnimatedText(
              title,
              textStyle: _titleStyle(Colors.deepOrangeAccent),
            ),
          ],
        );
      case 8:
        return AnimatedTextKit(
          totalRepeatCount: 1,
          animatedTexts: [
            TypewriterAnimatedText(
              title,
              textStyle: _titleStyle(Colors.teal),
              speed: const Duration(milliseconds: 100),
            ),
          ],
        );
      case 9:
        return Shimmer.fromColors(
          baseColor: Colors.pinkAccent,
          highlightColor: Colors.white,
          child: _titleText('$title (Shimmer)', Colors.white),
        );
      case 10:
        return AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            final color = animationController.value < 0.5
                ? AppColors.button
                : AppColors.button;
            return Shimmer.fromColors(
              baseColor: color,
              highlightColor: Colors.white,
              child: _titleText(title, color),
            );
          },
        );
      case 11:
        return Transform.translate(
          offset: Offset(0, sin(animationController.value * pi * 2) * 10),
          child: _titleText(title, Colors.amber),
        );
      case 12:
        return AnimatedBuilder(
          animation: animationController,
          builder: (_, child) {
            final color = Color.lerp(
              Colors.blue,
              Colors.red,
              animationController.value,
            )!;
            return _titleText(title, color);
          },
        );
      case 13:
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..rotateX(animationController.value * pi)
            ..scale(animationController.value),
          child: _titleText(title, Colors.purpleAccent),
        );
      case 14:
        return Transform.translate(
          offset: Offset(sin(animationController.value * 2 * pi) * 20, 0),
          child: _titleText(title, Colors.lime),
        );
      case 15:
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(-1, 1), end: Offset.zero)
              .animate(
                CurvedAnimation(
                  parent: animationController,
                  curve: Curves.easeOut,
                ),
              ),
          child: _titleText(title, Colors.brown),
        );
      case 16:
        return Transform.rotate(
          angle: animationController.value * 2 * pi,
          child: SlideTransition(
            position: slide,
            child: _titleText(title, Colors.orange),
          ),
        );
      case 17:
        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.2).animate(
            CurvedAnimation(
              parent: animationController,
              curve: Curves.easeInOut,
            ),
          ),
          child: _titleText(title, Colors.pink),
        );
      case 18:
        return ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1.1).animate(
            CurvedAnimation(
              parent: animationController,
              curve: Curves.elasticIn,
            ),
          ),
          child: _titleText(title, Colors.blueGrey),
        );
      case 19:
        return AnimatedTextKit(
          totalRepeatCount: 1,
          animatedTexts: [
            ScaleAnimatedText(
              title,
              duration: const Duration(milliseconds: 1500),
              textStyle: _titleStyle(Colors.tealAccent),
            ),
          ],
        );
      case 20:
        return Transform.translate(
          offset: Tween<Offset>(begin: const Offset(0, -50), end: Offset.zero)
              .animate(
                CurvedAnimation(
                  parent: animationController,
                  curve: Curves.bounceOut,
                ),
              )
              .value,
          child: _titleText(title, Colors.redAccent),
        );
      default:
        return _titleText(title, Colors.grey);
    }
  }

  Text _titleText(String text, Color color) {
    return Text(text, style: _titleStyle(color));
  }

  TextStyle _titleStyle(Color color) {
    return TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: color,
      shadows: [
        Shadow(
          blurRadius: 10,
          color: color.withAlpha((0.6 * 255).round()), // equals to color: color.withOpacity(0.6);
          offset: const Offset(0, 0),
        ),
      ],
    );
  }
}
