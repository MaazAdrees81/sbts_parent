import 'package:get/get.dart';

import '../models/school_model.dart';
import '../models/student_model.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../services/preferences.dart';

class AppController extends GetxController {
  static AppController get I => Get.find<AppController>();

  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;
  String get userName => "${_userData?["data"]?["user"]?["name"] ?? "Parent"}";
  String get schoolId => "${_userData?["data"]?["user"]?["school_id"] ?? ""}";

  School? school;
  List<Student> students = [];
  bool isLoading = false;

  Future<void> initUserSession(Map<String, dynamic> data) async {
    _userData = data;
  }

  void resetData() {
    _userData = null;
    school = null;
    students = [];
  }

  Future<void> logout() async {
    try {
      await ApiService.I.logout();
    } catch (_) {}
    await Preferences.I.deleteUserSession();
    Get.offAllNamed(Routes.login);
    resetData();
  }
}
