import 'package:flutter/material.dart';
import 'package:task_qtec_ecommerce/view/screens/home/home_screen.dart';

class SplashService {
  Future<void> navigateAfterDelay(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }
}
