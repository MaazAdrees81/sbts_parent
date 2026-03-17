import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/empty_app_bar.dart';
import '../globals/constants.dart';
import '../globals/images.dart';
import '../models/credentials_model.dart';
import '../controllers/app_controller.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../services/preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(const Duration(seconds: 2));
    final CredentialsModel? credentials = Preferences.I.getCredentials();
    final bool hasSession = Preferences.I.getSession();

    if (hasSession && credentials != null) {
      try {
        final data = await ApiService.I.loginParent(userName: credentials.email, pass: credentials.pass);
        if (data != null) {
          await AppController.I.initUserSession(data);
          await Preferences.I.saveSession(true);
          Get.offAllNamed(Routes.home);
          return;
        }
      } catch (_) {}
    }
    Get.offAllNamed(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EmptyAppBar(brightness: Brightness.light),
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * 0.12,
            left: 24,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome to", style: TextStyle(fontSize: 18, color: kBlack, fontWeight: FontWeight.w500)),
                SizedBox(height: 4),
                Text("Smart Bus", style: TextStyle(fontSize: 30, color: kPrimaryColor, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.15,
            child: Center(
              child: Image.asset(Images.schoolBus, width: 260),
            ),
          ),
          const Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, color: kPrimaryColor)),
            ),
          ),
        ],
      ),
    );
  }
}