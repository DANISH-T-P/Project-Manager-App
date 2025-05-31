import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home/project_detail_controller.dart';
import '../../models/project_model.dart';
import '../../utils/appcolors.dart';
import '../../widgets/media_preview_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectDetailController>(
      init: ProjectDetailController(project),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF7F6FB),
          appBar: AppBar(
            title: Text(project.name),
            backgroundColor: AppColors.button,
          ),
          body: Column(
            children: [
              Expanded(child: Obx(() => _buildMediaContent(controller))),
              const SizedBox(height: 8),
              _buildTabSelector(controller),
              const SizedBox(height: 8),
              _buildProjectHeader(project),
              const SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProjectHeader(Project project) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            project.description,
            style: const TextStyle(color: Colors.black87),
          ),
          const SizedBox(height: 12),
          Wrap(
            runSpacing: 10,
            spacing: 12,
            children: [
              _infoChip(Icons.info_outline, "Status", project.status),
              _infoChip(Icons.date_range, "Start", _formatDate(project.startDate)),
              _infoChip(Icons.event, "End", _formatDate(project.endDate)),
              _infoChip(Icons.location_on, "Lat", project.latitude.toStringAsFixed(5)),
              _infoChip(Icons.location_on_outlined, "Lng", project.longitude.toStringAsFixed(5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, String value) {
    return Chip(
      avatar: Icon(icon, size: 18, color: AppColors.button),
      label: Text(
        "$label: $value",
        style: const TextStyle(fontSize: 13),
      ),
      backgroundColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _buildTabSelector(ProjectDetailController controller) {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ToggleButtons(
        isSelected: [
          controller.selectedTab.value == 'Images',
          controller.selectedTab.value == 'Videos',
        ],
        onPressed: (index) => controller.switchTab(index == 0 ? 'Images' : 'Videos'),
        borderRadius: BorderRadius.circular(10),
        selectedColor: Colors.white,
        fillColor: AppColors.button,
        color: Colors.black,
        textStyle: const TextStyle(fontWeight: FontWeight.w500),
        constraints: const BoxConstraints(minHeight: 40, minWidth: 120),
        children: const [
          Text("Images"),
          Text("Videos"),
        ],
      ),
    ));
  }

  Widget _buildMediaContent(ProjectDetailController controller) {
    final mediaList = controller.currentMedia;

    if (mediaList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              "No media available.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: mediaList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14,
      ),
      itemBuilder: (context, index) {
        final media = mediaList[index];
        final isVideo = controller.selectedTab.value == 'Videos';

        return GestureDetector(
          onTap: () => Get.to(() => MediaPreviewScreen(
            url: media.downloadUrl,
            isVideo: isVideo,
          )),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(media.downloadUrl, fit: BoxFit.cover),
                if (isVideo)
                  const Center(
                    child: Icon(Icons.play_circle_fill, size: 50, color: Colors.white),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
