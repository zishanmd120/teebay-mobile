import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teebay_mobile/features/authentication/presentation/controllers/auth_controller.dart';

class BiometricAuthScreen extends GetView<AuthController> {
  const BiometricAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: context.height / 8,
              ),
              Center(
                child: Image.network(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTXmE8iVLC7BBxfTpxcCwwE8TRhFKDxLh2Ng&s",
                  height: 80,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: context.height / 6,
              ),
              GestureDetector(
                onTap: controller.biometricAuthenticate,
                child: Container(
                  height: 100,
                  width: 100,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.shade300,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12.withOpacity(.2),
                            offset: const Offset(0, 2),
                            blurRadius: 5)
                      ]),
                  child: const Center(
                      child: Icon(
                        Icons.lock,
                        size: 80,
                        color: Colors.white,
                      )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text("Tap to proceed with the biometric auth.", style: context.textTheme.bodyLarge, textAlign: TextAlign.center,),
            ],
          ),
        ),
      ),
    );
  }
}
