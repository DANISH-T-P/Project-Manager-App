import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home/project_controller.dart';
import '../models/project_model.dart';
import '../utils/appcolors.dart';
import 'location_picker.dart';

class ProjectsFormScreen extends StatefulWidget {
  final Project project;
  final bool isEdit;

  const ProjectsFormScreen({Key? key, required this.project, this.isEdit = false})
      : super(key: key);

  @override
  State<ProjectsFormScreen> createState() => _ProjectsFormScreenState();
}

class _ProjectsFormScreenState extends State<ProjectsFormScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _statusController;
  late TextEditingController _addressController;

  final _formKey = GlobalKey<FormState>();

  late double _latitude;
  late double _longitude;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.project.name);
    _descriptionController = TextEditingController(text: widget.project.description);
    _statusController = TextEditingController(text: widget.project.status);
    _addressController = TextEditingController(text: widget.project.address);

    _latitude = widget.project.latitude;
    _longitude = widget.project.longitude;
    _startDate = widget.project.startDate;
    _endDate = widget.project.endDate;

    super.initState();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _pickAndUploadMedia({required bool isVideo}) async {
    final result = await FilePicker.platform.pickFiles(
      type: isVideo ? FileType.video : FileType.image,
    );
    if (result == null) return;

    final file = File(result.files.single.path!);
    final controller = Get.find<ProjectController>();

    await controller.addMediaToProject(
      projectId: widget.project.id,
      file: file,
      isVideo: isVideo,
    );

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(isVideo ? "Video uploaded!" : "Image uploaded!"),
    ));
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedProject = widget.project.copyWith(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      status: _statusController.text.trim(),
      address: _addressController.text.trim(),
      latitude: _latitude,
      longitude: _longitude,
      startDate: _startDate,
      endDate: _endDate,
      updatedAt: DateTime.now(),
      createdAt: widget.isEdit ? widget.project.createdAt : DateTime.now(),
    );

    final ref = FirebaseFirestore.instance.collection('projects').doc(updatedProject.id);

    if (widget.isEdit) {
      await ref.update(updatedProject.toMap());
    } else {
      await ref.set(updatedProject.toMap());
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Project' : 'New Project'),
        backgroundColor: AppColors.button,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Project Name'),
                validator: (val) => val!.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _statusController,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),

              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LocationPicker(
                        initialLat: _latitude,
                        initialLng: _longitude,
                        onLocationSelected: (lat, lng) {
                          setState(() {
                            _latitude = lat;
                            _longitude = lng;
                          });
                        },
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.location_on),
                label: const Text("Pick Location"),
              ),
              Text("Lat: $_latitude, Lng: $_longitude",
                  style: const TextStyle(fontSize: 13, color: Colors.grey)),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text("Start Date"),
                      subtitle: Text("${_startDate.toLocal()}".split(' ')[0]),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _pickDate(isStart: true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ListTile(
                      title: const Text("End Date"),
                      subtitle: Text("${_endDate.toLocal()}".split(' ')[0]),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _pickDate(isStart: false),
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.image),
                    label: const Text("Add Image"),
                    onPressed: () => _pickAndUploadMedia(isVideo: false),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.videocam),
                    label: const Text("Add Video"),
                    onPressed: () => _pickAndUploadMedia(isVideo: true),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.button,
                  minimumSize: const Size.fromHeight(44),
                ),
                child: Text(widget.isEdit ? 'Update Project' : 'Create Project'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
