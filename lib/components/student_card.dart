import 'package:flutter/material.dart';

import '../globals/constants.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({
    required this.name,
    required this.className,
    this.profilePic,
    this.status,
    this.onAbsentTap,
    this.onPresentTap,
    this.onLeaveTap,
    this.parents = const [],
    super.key,
  });

  final String name;
  final String className;
  final String? profilePic;
  final String? status;
  final VoidCallback? onAbsentTap;
  final VoidCallback? onPresentTap;
  final VoidCallback? onLeaveTap;
  final List<ParentInfo> parents;

  bool _isSelected(String label) {
    if (status == null) return false;
    return status!.toLowerCase() == label.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: kBorderRadius12,
        boxShadow: [kCardsShadow2],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: kLightGrey,
                backgroundImage: profilePic != null ? NetworkImage(profilePic!) : null,
                child: profilePic == null ? const Icon(Icons.person, color: kGrey) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kBlack)),
                    const SizedBox(height: 2),
                    Text(className, style: const TextStyle(fontSize: 12, color: kDarkGrey)),
                  ],
                ),
              ),
              _attButton("A", kRed, _isSelected("absent"), onAbsentTap),
              const SizedBox(width: 6),
              _attButton("P", kGreen, _isSelected("present"), onPresentTap),
              const SizedBox(width: 6),
              _attButton("L", kOrange, _isSelected("leave"), onLeaveTap),
            ],
          ),
          if (parents.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Divider(height: 1, color: kLightGrey),
            const SizedBox(height: 8),
            ...parents.map((parent) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: kLightGrey,
                        backgroundImage: parent.profilePic != null ? NetworkImage(parent.profilePic!) : null,
                        child: parent.profilePic == null ? const Icon(Icons.person, color: kGrey, size: 18) : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(parent.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: kBlack)),
                            Text(parent.relation, style: const TextStyle(fontSize: 11, color: kGrey)),
                          ],
                        ),
                      ),
                      if (parent.phone != null)
                        GestureDetector(
                          onTap: parent.onCallTap,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(color: kPrimaryColor, borderRadius: kBorderRadius8),
                            child: const Icon(Icons.phone, color: Colors.white, size: 18),
                          ),
                        ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Widget _attButton(String label, Color color, bool selected, VoidCallback? onTap) {
    return Material(
      color: selected ? color : kLightGrey,
      borderRadius: kBorderRadius8,
      child: InkWell(
        onTap: onTap,
        borderRadius: kBorderRadius8,
        child: SizedBox(
          width: 32,
          height: 32,
          child: Center(
            child: Text(label, style: TextStyle(color: selected ? Colors.white : kBlack, fontSize: 13, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }
}

class ParentInfo {
  const ParentInfo({required this.name, required this.relation, this.profilePic, this.phone, this.onCallTap});

  final String name;
  final String relation;
  final String? profilePic;
  final String? phone;
  final VoidCallback? onCallTap;
}
