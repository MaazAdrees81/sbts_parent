import 'package:get/get.dart';

import '../screens/change_password_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/route_detail_screen.dart';
import '../screens/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static const String initial = Routes.splash;
  static final routes = <GetPage>[
    GetPage(name: Routes.splash, page: () => const SplashScreen()),
    GetPage(name: Routes.login, page: () => const LoginScreen()),
    GetPage(name: Routes.home, page: () => const HomeScreen()),
    GetPage(name: Routes.changePassword, page: () => const ChangePasswordScreen()),
    GetPage(name: Routes.routeDetail, page: () => const RouteDetailScreen()),
  ];
}