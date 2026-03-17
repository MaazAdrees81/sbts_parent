import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals/constants.dart';
import '../models/student_model.dart';
import '../routes/app_routes.dart';

class ChildCard extends StatefulWidget {
  const ChildCard({required this.student, required this.onTap, super.key});
  final Student student;
  final VoidCallback onTap;

  @override
  State<ChildCard> createState() => _ChildCardState();
}

class _ChildCardState extends State<ChildCard> {
  String? _expanded;

  void _toggleExpand(String type) {
    setState(() => _expanded = _expanded == type ? null : type);
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.student;
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
                  onTap: widget.onTap,
                  child: const Icon(Icons.more_vert, color: kGrey, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                if (student.pickupStopName != null)
                  GestureDetector(
                    onTap: () => _toggleExpand("pickup"),
                    child: _StopBadge(label: "Pick Up", color: kGreen, active: _expanded == "pickup"),
                  ),
                if (student.pickupStopName != null && student.dropStopName != null)
                  const SizedBox(width: 8),
                if (student.dropStopName != null)
                  GestureDetector(
                    onTap: () => _toggleExpand("drop"),
                    child: _StopBadge(label: "Drop", color: kOrange, active: _expanded == "drop"),
                  ),
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
            if (_expanded == "pickup" && student.pickupStopName != null)
              _ExpandedDetail(
                stopName: student.pickupStopName!,
                time: student.pickupMorningTime,
                onClose: () => setState(() => _expanded = null),
              ),
            if (_expanded == "drop" && student.dropStopName != null)
              _ExpandedDetail(
                stopName: student.dropStopName!,
                time: student.dropEveningTime,
                onClose: () => setState(() => _expanded = null),
              ),
          ],
        ),
      ),
    );
  }
}

class _ExpandedDetail extends StatelessWidget {
  const _ExpandedDetail({required this.stopName, this.time, required this.onClose});
  final String stopName;
  final String? time;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kScaffoldBg,
        borderRadius: kBorderRadius8,
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: kPrimaryColor, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stopName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kBlack)),
                if (time != null && time!.isNotEmpty)
                  Text(time!, style: const TextStyle(fontSize: 12, color: kDarkGrey)),
              ],
            ),
          ),
          GestureDetector(
            onTap: onClose,
            child: const Icon(Icons.close, color: kGrey, size: 18),
          ),
        ],
      ),
    );
  }
}

class _StopBadge extends StatelessWidget {
  const _StopBadge({required this.label, required this.color, this.active = false});
  final String label;
  final Color color;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: active ? color.withValues(alpha: 0.25) : color.withValues(alpha: 0.12),
        borderRadius: kBorderRadius12,
        border: Border.all(color: color.withValues(alpha: active ? 0.8 : 0.4), width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}