// File: lib/screens/home/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home/profile_controller.dart';
import '../../utils/appcolors.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.userData.value;

      if (user == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return SizedBox(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(user),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      _buildInfoTile(Icons.person, "Name", user['name'] ?? ''),
                      const Divider(),
                      _buildInfoTile(Icons.email, "Email", user['email'] ?? ''),
                      const Divider(),
                      _buildInfoTile(Icons.phone, "Phone", user['phone'] ?? ''),
                      const Divider(),
                      _buildInfoTile(
                        Icons.lock_outline,
                        "Password",
                        "********",
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _buildActionButtons(context),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(Map<String, dynamic> user) {
    return Stack(
      children: [
        Container(
          height: 220,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.button, Color(0xFF1E3C72)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 42,
                backgroundColor: Colors.white,
                child: Text(
                  user['name']?.substring(0, 1).toUpperCase() ?? '?',
                  style: const TextStyle(
                    fontSize: 36,
                    color: AppColors.button,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                user['name'] ?? 'No Name',
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                user['email'] ?? '',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),

        /// 👇 Drawer trigger icon (top-right)
        Positioned(
          top: 32,
          right: 12,
          child: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.button.withOpacity(0.1),
        child: Icon(icon, color: AppColors.button),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(value, style: const TextStyle(fontSize: 15)),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Positioned(
      bottom: 24,
      left: 20,
      right: 20,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.button,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile"),
              onPressed: () => controller.showEditDialog(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              onPressed: controller.logout,
            ),
          ),
        ],
      ),
    );
  }
}
