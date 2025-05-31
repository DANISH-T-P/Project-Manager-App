// File: lib/controllers/home/home_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;
  final userData = Rxn<Map<String, dynamic>>();
  final formKey = GlobalKey<FormState>();
  String? updatedName;
  String? updatedPhone;

  @override
  void onInit() {
    fetchUserData();
    super.onInit();
  }

  void onTabTapped(int index) {
    currentIndex.value = index;
  }

  Future<void> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      userData.value = doc.data();
    }
  }

  Future<void> updateUserData(String name, String phone) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name,
        'phone': phone,
      }, SetOptions(merge: true));
      fetchUserData(); // refresh
    }
  }

  void showEditDialog(BuildContext context) {
    updatedName = userData.value?['name'];
    updatedPhone = userData.value?['phone'];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Profile"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: updatedName,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (val) => val == null || val.isEmpty ? "Enter name" : null,
                onSaved: (val) => updatedName = val,
              ),
              TextFormField(
                initialValue: updatedPhone,
                decoration: const InputDecoration(labelText: "Phone"),
                validator: (val) => val == null || val.isEmpty ? "Enter phone" : null,
                onSaved: (val) => updatedPhone = val,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                await updateUserData(updatedName!, updatedPhone!);
                Get.back();
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
