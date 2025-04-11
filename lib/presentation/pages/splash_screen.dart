import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:kot_pos/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add any initialization logic here
    Future.delayed(const Duration(seconds: 2), () {
      Get.off(() => const LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
} 