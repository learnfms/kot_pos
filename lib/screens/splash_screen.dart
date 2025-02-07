import 'dart:async';

import 'package:flutter/material.dart';
    class SplashScreen extends StatefulWidget {
      const SplashScreen({super.key});

      @override
      State<SplashScreen> createState() => _SplashScreenState();
    }

    class _SplashScreenState extends State<SplashScreen> {
      @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
      Duration(seconds: 3),
        (){
        
        }
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
