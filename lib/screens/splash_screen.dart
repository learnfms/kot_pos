import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kot_pos/screens/welcome_screen.dart';
import 'package:kot_pos/shared_preferences/store_data_manager.dart';
import 'package:kot_pos/screens/home_screen.dart'; // Add this import

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    isLoggedIn = await StoreDataManager.hasStoreData();
    Timer(
      const Duration(seconds: 3),
          () {
        if (isLoggedIn) {
          Get.off(() => const HomeScreen()); // Navigate to HomeScreen if logged in
        } else {
          Get.off(() => const WelcomeScreen()); // Navigate to WelcomeScreen if not logged in
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/icon.png', width: 150, height: 150),
      ),
    );
  }
}
