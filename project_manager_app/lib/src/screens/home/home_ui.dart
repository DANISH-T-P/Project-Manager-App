// File: lib/screens/home/home_ui.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../controllers/home/home_controller.dart';
import '../../models/home_ui.dart';
import '../../utils/appcolors.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'projects_screen.dart';

class HomeUI extends GetView<HomeController> {
  const HomeUI({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomeTab(page: const HomeScreen(), title: "PROJECT MANAGER", showDrawer: false),
      HomeTab(page: const ProjectsScreen(), title: "Projects", showDrawer: false),
      HomeTab(page: const ProfileScreen(), title: "Profile", showDrawer: true, showAppBar: false,),
    ];

    return Obx(() {
      if (controller.userData.value == null) {
        return const Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.scaffoldBackground,
          body: Center(child: CircularProgressIndicator()),
        );
      }

      final index = controller.currentIndex.value;
      final currentTab = tabs[index];
      final user = controller.userData.value!;

      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: currentTab.showAppBar
            ? AppBar(
          title: Text(
            currentTab.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.button, Color(0xFF1E3C72)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        )
            : null,
        endDrawer: currentTab.showDrawer
            ? Drawer(
          child: SafeArea(
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(user['name'] ?? 'No Name'),
                  accountEmail: Text(user['email'] ?? 'No Email'),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: AppColors.button,
                    child: Text(
                      (user['name']?.isNotEmpty ?? false)
                          ? user['name'][0].toUpperCase()
                          : '?',
                      style: const TextStyle(fontSize: 32, color: Colors.white),
                    ),
                  ),
                  otherAccountsPictures: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        Get.back();
                        controller.showEditDialog(context);
                      },
                    )
                  ],
                ),
                const Spacer(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                  onTap: () async {
                    await Get.find<AuthController>().signOut();
                  },
                ),
              ],
            ),
          ),
        )
            : null,
        body: IndexedStack(
          index: index,
          children: tabs.map((tab) => tab.page).toList(),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          elevation: 8,
          color: Colors.white,
          child: BottomNavigationBar(
            currentIndex: index,
            onTap: controller.onTabTapped,
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.button,
            unselectedItemColor: AppColors.iconLight,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work_outline),
                activeIcon: Icon(Icons.work),
                label: 'Projects',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      );
    });
  }
}
