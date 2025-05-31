import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home/home_screen_controller.dart';
import 'project_detail_screen.dart';

class HomeScreen extends GetView<HomeScreenController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search projects...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onChanged: controller.updateSearch,
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final projects = controller.filteredProjects;

            if (projects.isEmpty) {
              return const Center(child: Text("No projects found."));
            }

            return ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(project.name),
                    subtitle: Text(project.description),
                    onTap: () {
                      Get.to(() => ProjectDetailScreen(project: project));
                    },
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
