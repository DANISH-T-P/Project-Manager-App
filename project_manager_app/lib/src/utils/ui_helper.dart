import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'appcolors.dart';


class UiHelper {
  static Widget customImage({
    required String img,
    double? height,
    double? width,
    BoxFit fit = BoxFit.contain,
  })
  {
    return Image.asset(
      "assets/images/$img",
      height: height,
      width: width,
      fit: fit,
    );
  }

  static Widget customText({
    required String text,
    required Color color,
    required FontWeight fontWeight,
    double fontSize = 14,
    String fontFamily = "regular",
    bool isPadding = false,
    double left = 0.0,
    double right = 0.0,
    double top = 0.0,
    double bottom = 0.0,
  })
  {
    Widget content = Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        color: color,
      ),
    );
    return isPadding
        ? Padding(
      padding: EdgeInsets.only(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
      ),
      child: content,
    )
        : content;
  }

  static Widget customTextField({
    required TextEditingController controller,
    bool isPadding = false,
    double left = 0.0,
    double right = 0.0,
    double top = 0.0,
    double bottom = 0.0,
    String hintText = "Search 'ice-cream'",
    String prefixIcon = "assets/images/search.png",
    String suffixIcon = "assets/images/mic 1.png",
    double height = 40,
    double width = 360,
  })
  {
    return Padding(
      padding: isPadding
          ? EdgeInsets.only(left: left, right: right, top: top, bottom: bottom)
          : EdgeInsets.zero,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: const Color(0XFFC5C5C5)),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Image.asset(prefixIcon),
            suffixIcon: Image.asset(suffixIcon),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  static Widget customButton({
    required VoidCallback onTap,
    String label = "Add",
    Color textColor = const Color(0XFF27AF34),
    Color borderColor = const Color(0XFF27AF34),
    double fontSize = 8,
    double height = 18,
    double width = 30,
  })
  {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(fontSize: fontSize, color: textColor),
          ),
        ),
      ),
    );
  }

  static Widget button(String label, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.button,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  static Widget label(String text) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.bold));
  }

  static Widget header({
    required String title,
    required String subtitle,
    Color titleColor = Colors.white,
    Color subtitleColor = Colors.white70,
    bool showBack = false,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.scaffoldBackground,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showBack)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: subtitleColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

}

class CustomInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool isPassword;

  const CustomInputField({
    Key? key,
    required this.controller,
    required this.hint,
    this.isPassword = false,
  }) : super(key: key);

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late bool obscure;

  @override
  void initState() {
    super.initState();
    obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: widget.hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() => obscure = !obscure);
          },
        )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
