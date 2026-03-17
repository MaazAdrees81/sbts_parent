import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals/constants.dart';
import '../models/student_model.dart';
import '../routes/app_routes.dart';

class ChildCard extends StatelessWidget {
  const ChildCard({required this.student, required this.onTap, super.key});
  final Student student;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.routeDetail, arguments: student),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(40),
            bottomRight: Radius.circular(6),
            topLeft: Radius.circular(6),
            bottomLeft: Radius.circular(6),
          ),
          boxShadow: [kCardsShadow2],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: kLightGrey,
                  backgroundImage: student.profilePicUrl != null ? NetworkImage(student.profilePicUrl!) : null,
                  child: student.profilePicUrl == null ? const Icon(Icons.person, color: kGrey, size: 26) : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(student.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kBlack)),
                      const SizedBox(height: 2),
                      Text(student.classSection, style: const TextStyle(fontSize: 12, color: kDarkGrey)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: const Icon(Icons.more_vert, color: kGrey, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                if (student.pickupStopName != null)
                  _StopBadge(label: "Pick Up", color: kGreen),
                if (student.pickupStopName != null && student.dropStopName != null)
                  const SizedBox(width: 8),
                if (student.dropStopName != null)
                  _StopBadge(label: "Drop", color: kOrange),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withValues(alpha: 0.1),
                    borderRadius: kBorderRadius12,
                  ),
                  child: const Text("In Bus", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kPrimaryColor)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StopBadge extends StatelessWidget {
  const _StopBadge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: kBorderRadius12,
        border: Border.all(color: color.withValues(alpha: 0.4), width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
