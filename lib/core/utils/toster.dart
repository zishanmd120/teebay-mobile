import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSuccessSnackBar(String title, String message) {
  Get.snackbar(
    title,
    message,
    backgroundColor: Colors.green,
    colorText: Colors.white,
  );
}

void showErrorSnackBar(String title, String message) {
  Get.snackbar(
    title,
    message,
    backgroundColor: Colors.red,
    colorText: Colors.white,
  );
}