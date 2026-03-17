import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/app_controller.dart';
import 'globals/constants.dart';
import 'routes/app_pages.dart';
import 'services/api_service.dart';
import 'services/preferences.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initServices();
  _initControllers();
  runApp(const MyApp());
}

Future<void> _initServices() async {
  await Get.putAsync<Preferences>(() => Preferences().init(), permanent: true);
  Get.put<ApiService>(ApiService(), permanent: true);
}

void _initControllers() {
  Get.put<AppController>(AppController(), permanent: true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: kAppName,
      color: kPrimaryColor,
      theme: buildAppTheme(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}