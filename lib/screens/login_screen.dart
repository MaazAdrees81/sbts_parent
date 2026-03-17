import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../components/custom_text_field.dart';
import '../components/empty_app_bar.dart';
import '../components/main_button.dart';
import '../controllers/app_controller.dart';
import '../dialogs/custom_dialog.dart';
import '../globals/api_exception.dart';
import '../globals/constants.dart';
import '../globals/images.dart';
import '../models/credentials_model.dart';
import '../routes/app_routes.dart';
import '../services/api_service.dart';
import '../services/preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _usernameError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() {
    final credentials = Preferences.I.getCredentials();
    if (credentials != null && credentials.saveForLater) {
      _usernameController.text = credentials.email;
      _passwordController.text = credentials.pass;
      _rememberMe = credentials.saveForLater;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _usernameError = _usernameController.text.trim().isEmpty ? "Phone number is required" : null;
      _passwordError = _passwordController.text.trim().isEmpty ? "Password is required" : null;
    });
    if (_usernameError != null || _passwordError != null) return;

    setState(() => _isLoading = true);
    try {
      final data = await ApiService.I.loginParent(
        userName: _usernameController.text.trim(),
        pass: _passwordController.text.trim(),
      );
      if (data != null) {
        await AppController.I.initUserSession(data);
        if (_rememberMe) {
          await Preferences.I.saveCredentials(CredentialsModel(
            email: _usernameController.text.trim(),
            pass: _passwordController.text.trim(),
            saveForLater: true,
          ));
        } else {
          await Preferences.I.deleteCredentials();
        }
        await Preferences.I.saveSession(true);
        Get.offAllNamed(Routes.home);
      }
    } on ApiException catch (e) {
      Get.dialog(CustomDialog(title: "Error", message: e.message ?? kGeneralErrMsg));
    } on PlatformException catch (e) {
      Get.dialog(CustomDialog(title: "Error", message: e.message ?? kGeneralErrMsg));
    } catch (e) {
      Get.dialog(CustomDialog(title: "Error", message: e.toString()));
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EmptyAppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: kMaxWidthConstraints,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("Welcome to", style: TextStyle(fontSize: 18, color: kBlack, fontWeight: FontWeight.w600), textAlign: TextAlign.start),
                const SizedBox(height: 4),
                const Text("Smart Bus", style: TextStyle(fontSize: 28, color: kPrimaryColor, fontWeight: FontWeight.w800), textAlign: TextAlign.start),
                const SizedBox(height: 24),
                Center(child: Image.asset(Images.appLogo, width: 120)),
                const SizedBox(height: 10),
                const Text("Quick and reliable bus tracking for parents", style: TextStyle(fontSize: 14, color: kBlack, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: _usernameController,
                  hintText: "Phone Number",
                  keyboardType: TextInputType.phone,
                  errorText: _usernameError,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.person_outline, color: kGrey),
                  onChanged: (_) {
                    if (_usernameError != null) setState(() => _usernameError = null);
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  hintText: "Password",
                  errorText: _passwordError,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.lock_outline, color: kGrey),
                  suffixIcon: GestureDetector(
                    onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                    child: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: kGrey),
                  ),
                  onChanged: (_) {
                    if (_passwordError != null) setState(() => _passwordError = null);
                  },
                  onFieldSubmitted: (_) => _login(),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _rememberMe,
                        onChanged: (val) => setState(() => _rememberMe = val ?? false),
                        activeColor: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _rememberMe = !_rememberMe),
                      child: const Text("Remember me", style: TextStyle(color: kDarkGrey, fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                MainButton(
                  label: "Login",
                  onPressed: _login,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}