import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeTab {
  final Widget page;
  final String title;
  final bool showDrawer;
  final bool showAppBar;

  HomeTab({
    required this.page,
    required this.title,
    this.showDrawer = false,
    this.showAppBar = true,
  });
}
