import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../controllers/home/project_controller.dart';
import '../../utils/appcolors.dart';

class ProjectsScreen extends GetView<ProjectController> {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.projects.isEmpty) {
          return const Center(child: Text("No projects available."));
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: controller.projects.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final project = controller.projects[index];
            return Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                title: Text(
                  project.name,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                subtitle: Text(
                  "Created at ${controller.formatDate(project.createdAt)}",
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueAccent),
                      onPressed: () => controller.openProjectForm(project: project),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => controller.confirmDelete(project.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 18.0), // Separation from bottom
        child: FloatingActionButton(
          onPressed: () => controller.openProjectForm(),
          backgroundColor: AppColors.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // rounded square style
          ),
          child: const Icon(Icons.add, size: 28, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
