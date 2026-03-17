import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/child_card.dart';
import '../components/guardian_bottom_sheet.dart';
import '../components/home_app_bar.dart';
import '../components/school_card.dart';
import '../controllers/app_controller.dart';
import '../globals/constants.dart';
import '../routes/app_routes.dart';
import '../models/school_model.dart';
import '../models/student_model.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const id = "HomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final ctrl = AppController.I;
    ctrl.isLoading = true;
    ctrl.update([HomeScreen.id]);
    try {
      final results = await Future.wait([
        ApiService.I.fetchSchool(ctrl.schoolId),
        ApiService.I.fetchStudents(),
      ]);
      final schoolData = results[0] as Map<String, dynamic>?;
      final studentsData = results[1] as List<dynamic>;

      if (schoolData != null) {
        ctrl.school = School.fromJson(schoolData);
      }
      ctrl.students = studentsData.map((e) => Student.fromJson(e)).toList();
    } catch (e) {
      if (kDebugMode) debugPrint("loadData error: $e");
    }
    ctrl.isLoading = false;
    ctrl.update([HomeScreen.id]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: kScaffoldBg,
      body: GetBuilder<AppController>(
        id: HomeScreen.id,
        builder: (ctrl) {
          if (ctrl.isLoading) {
            return Column(
              children: [
                HomeAppBar(trailing: GestureDetector(onTap: () => Get.toNamed(Routes.changePassword), child: const Icon(Icons.lock_outline, color: Colors.white, size: 24))),
                const Expanded(child: Center(child: CircularProgressIndicator(color: kPrimaryColor))),
              ],
            );
          }
          return RefreshIndicator(
            color: kPrimaryColor,
            onRefresh: () => _loadData(),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      HomeAppBar(trailing: GestureDetector(onTap: () => Get.toNamed(Routes.changePassword), child: const Icon(Icons.lock_outline, color: Colors.white, size: 24))),
                      if (ctrl.school != null)
                        Positioned(
                          left: 24,
                          right: 24,
                          top: MediaQuery.of(context).viewPadding.top + 140 - 60,
                          child: SchoolCard(school: ctrl.school!),
                        ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: ctrl.school != null ? 100 : 16)),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text("Child Profile", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kBlack), textAlign: TextAlign.center),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => ChildCard(
                        student: ctrl.students[i],
                        onTap: () => Get.bottomSheet(
                          GuardianBottomSheet(student: ctrl.students[i]),
                          isScrollControlled: true,
                        ),
                      ),
                      childCount: ctrl.students.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          );
        },
      ),
    );
  }
}
