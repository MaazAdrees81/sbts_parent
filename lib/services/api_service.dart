import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

import '../globals/api_exception.dart';
import '../services/preferences.dart';

const kJsonHeader = {"Content-Type": "application/json"};
const kAcceptJsonHeader = {"Accept": "application/json"};
const kUrlEncodedContentHeader = {"Content-Type": "application/x-www-form-urlencoded"};
final kAuthHeaders = <String, String>{};

class ApiService extends GetxController {
  static const baseUrl = "https://sbts.igadgets.org";

  static ApiService get I => Get.find<ApiService>();

  static final Dio _dio = Dio(
    BaseOptions(
      validateStatus: (int? status) => true,
      connectTimeout: const Duration(seconds: 15),
    ),
  );

  void updateCookie(Map<String, dynamic> headers) {
    final String? rawCookie = headers['set-cookie']?.first;
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      final cookie = (index == -1) ? rawCookie : rawCookie.substring(0, index).trim();
      kAuthHeaders['cookie'] = cookie;
      Preferences.I.saveCookie(cookie);
    }
  }

  Future<Map<String, dynamic>?> loginParent({required String userName, required String pass}) async {
    final Map<String, dynamic> body = {"login": userName, "password": pass};
    final Uri uri = Uri.parse("$baseUrl/api/api.php/login");
    if (kDebugMode) {
      debugPrint("$uri");
    }
    final response = await _dio.postUri(
      uri,
      data: body,
      options: Options(
        extra: {"withCredentials": false},
        headers: {...kJsonHeader},
      ),
    );
    if (kDebugMode) {
      debugPrint("Api.loginParent ${response.statusCode}");
      log("Api.loginParent ${jsonEncode(response.data)}");
    }
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      final Map<String, dynamic> map = response.data;
      if ("${map["success"]}".toLowerCase() == "false") {
        String? message;
        if (response.data is Map) {
          message = response.data["message"];
        }
        throw ApiException(response.statusCode!, message: message);
      } else if ("${map["success"]}".toLowerCase() == "true") {
        updateCookie(response.headers.map);
        final token = "${map["data"]?["token"] ?? ""}";
        if (token.isNotEmpty) {
          Preferences.I.saveToken(token);
          kAuthHeaders["Authorization"] = "Bearer $token";
        }
        return map;
      }
      return null;
    } else {
      String? message;
      if (response.data is Map) {
        message = response.data["message"];
      }
      throw ApiException(response.statusCode!, message: message);
    }
  }

  Future<Map<String, dynamic>?> fetchSchool(String schoolId) async {
    final Uri uri = Uri.parse("$baseUrl/api/api.php/schools/$schoolId");
    if (kDebugMode) debugPrint("$uri");
    final response = await _dio.getUri(uri, options: Options(headers: {...kJsonHeader, ...kAuthHeaders}));
    if (kDebugMode) {
      debugPrint("Api.fetchSchool ${response.statusCode}");
      log("Api.fetchSchool ${jsonEncode(response.data)}");
    }
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      final Map<String, dynamic> map = response.data;
      if ("${map["success"]}".toLowerCase() == "true") {
        return map["data"];
      }
      return null;
    } else {
      String? message;
      if (response.data is Map) message = response.data["message"];
      throw ApiException(response.statusCode!, message: message);
    }
  }

  Future<List<dynamic>> fetchStudents() async {
    final Uri uri = Uri.parse("$baseUrl/api/api.php/students");
    if (kDebugMode) debugPrint("$uri");
    final response = await _dio.getUri(uri, options: Options(headers: {...kJsonHeader, ...kAuthHeaders}));
    if (kDebugMode) {
      debugPrint("Api.fetchStudents ${response.statusCode}");
      log("Api.fetchStudents ${jsonEncode(response.data)}");
    }
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      final Map<String, dynamic> map = response.data;
      if ("${map["success"]}".toLowerCase() == "true") {
        return map["data"] ?? [];
      }
      return [];
    } else {
      String? message;
      if (response.data is Map) message = response.data["message"];
      throw ApiException(response.statusCode!, message: message);
    }
  }

  Future<List<dynamic>> fetchStops({required String routeId, required String schedule, required String studentId}) async {
    final Uri uri = Uri.parse("$baseUrl/api/api.php/stops?route_id=$routeId&schedule=$schedule&student_id=$studentId");
    if (kDebugMode) debugPrint("$uri");
    final response = await _dio.getUri(uri, options: Options(headers: {...kJsonHeader, ...kAuthHeaders}));
    if (kDebugMode) {
      debugPrint("Api.fetchStops ${response.statusCode}");
      log("Api.fetchStops ${jsonEncode(response.data)}");
    }
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      final Map<String, dynamic> map = response.data;
      if ("${map["success"]}".toLowerCase() == "true") {
        return map["data"] ?? [];
      }
      return [];
    } else {
      String? message;
      if (response.data is Map) message = response.data["message"];
      throw ApiException(response.statusCode!, message: message);
    }
  }

  Future<Map<String, dynamic>?> fetchBusLocation() async {
    final Uri uri = Uri.parse("$baseUrl/api/api.php/location");
    if (kDebugMode) debugPrint("$uri");
    final response = await _dio.getUri(uri, options: Options(headers: {...kJsonHeader, ...kAuthHeaders}));
    if (kDebugMode) {
      debugPrint("Api.fetchBusLocation ${response.statusCode}");
      log("Api.fetchBusLocation ${jsonEncode(response.data)}");
    }
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      final Map<String, dynamic> map = response.data;
      if ("${map["success"]}".toLowerCase() == "true") {
        return map["data"];
      }
      return null;
    } else {
      String? message;
      if (response.data is Map) message = response.data["message"];
      throw ApiException(response.statusCode!, message: message);
    }
  }

  Future<void> changePassword({required String userId, required String newPassword}) async {
    final Uri uri = Uri.parse("$baseUrl/api/api.php/users/$userId");
    if (kDebugMode) debugPrint("$uri");
    final response = await _dio.putUri(
      uri,
      data: {"password": newPassword},
      options: Options(headers: {...kJsonHeader, ...kAuthHeaders}),
    );
    if (kDebugMode) {
      debugPrint("Api.changePassword ${response.statusCode}");
      log("Api.changePassword ${jsonEncode(response.data)}");
    }
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      final Map<String, dynamic> map = response.data;
      if ("${map["success"]}".toLowerCase() == "false") {
        String? message;
        if (response.data is Map) message = response.data["message"];
        throw ApiException(response.statusCode!, message: message);
      }
    } else {
      String? message;
      if (response.data is Map) message = response.data["message"];
      throw ApiException(response.statusCode!, message: message);
    }
  }

  Future<void> logout() async {
    final Uri uri = Uri.parse("$baseUrl/api/api.php/logout");
    if (kDebugMode) {
      debugPrint("$uri");
    }
    final response = await _dio.deleteUri(uri, options: Options(headers: {...kUrlEncodedContentHeader, ...kAuthHeaders}));
    if (kDebugMode) {
      debugPrint("Api.logout ${response.statusCode}");
    }
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
    } else {
      String? message;
      if (response.data is Map) {
        message = response.data["message"];
      }
      throw ApiException(response.statusCode!, message: message);
    }
  }
}