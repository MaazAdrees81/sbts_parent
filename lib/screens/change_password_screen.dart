import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/custom_text_field.dart';
import '../components/home_app_bar.dart';
import '../components/main_button.dart';
import '../controllers/app_controller.dart';
import '../dialogs/custom_dialog.dart';
import '../globals/api_exception.dart';
import '../globals/constants.dart';
import '../services/api_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  String? _oldError;
  String? _newError;
  String? _confirmError;

  @override
  void dispose() {
    _oldPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _oldError = _oldPasswordCtrl.text.trim().isEmpty ? "Old password is required" : null;
      _newError = _newPasswordCtrl.text.trim().isEmpty ? "New password is required" : null;
      _confirmError = _confirmPasswordCtrl.text.trim().isEmpty
          ? "Please re-enter new password"
          : _confirmPasswordCtrl.text.trim() != _newPasswordCtrl.text.trim()
              ? "Passwords do not match"
              : null;
    });
    if (_oldError != null || _newError != null || _confirmError != null) return;

    setState(() => _isLoading = true);
    try {
      final userId = AppController.I.userData?["data"]?["user"]?["id"] ?? "";
      await ApiService.I.changePassword(
        userId: userId,
        newPassword: _newPasswordCtrl.text.trim(),
      );
      Get.dialog(CustomDialog(
        title: "Success",
        message: "Password changed successfully",
        onTap: () {
          Get.back();
          Get.back();
        },
      ));
    } on ApiException catch (e) {
      Get.dialog(CustomDialog(title: "Error", message: e.message ?? kGeneralErrMsg));
    } catch (e) {
      Get.dialog(CustomDialog(title: "Error", message: e.toString()));
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: kPrimaryColor,
      body: Column(
        children: [
          const HomeAppBar(),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(6),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: ConstrainedBox(
                  constraints: kMaxWidthConstraints,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Change Password",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: kPrimaryColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      CustomTextField(
                        controller: _oldPasswordCtrl,
                        hintText: "Old Password",
                        obscureText: _obscureOld,
                        errorText: _oldError,
                        textInputAction: TextInputAction.next,
                        suffixIcon: GestureDetector(
                          onTap: () => setState(() => _obscureOld = !_obscureOld),
                          child: Icon(_obscureOld ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: kGrey),
                        ),
                        onChanged: (_) {
                          if (_oldError != null) setState(() => _oldError = null);
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _newPasswordCtrl,
                        hintText: "New Password",
                        obscureText: _obscureNew,
                        errorText: _newError,
                        textInputAction: TextInputAction.next,
                        suffixIcon: GestureDetector(
                          onTap: () => setState(() => _obscureNew = !_obscureNew),
                          child: Icon(_obscureNew ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: kGrey),
                        ),
                        onChanged: (_) {
                          if (_newError != null) setState(() => _newError = null);
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _confirmPasswordCtrl,
                        hintText: "Re-enter New Password",
                        obscureText: _obscureConfirm,
                        errorText: _confirmError,
                        textInputAction: TextInputAction.done,
                        suffixIcon: GestureDetector(
                          onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
                          child: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: kGrey),
                        ),
                        onChanged: (_) {
                          if (_confirmError != null) setState(() => _confirmError = null);
                        },
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: 28),
                      MainButton(
                        label: "Submit",
                        onPressed: _submit,
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
