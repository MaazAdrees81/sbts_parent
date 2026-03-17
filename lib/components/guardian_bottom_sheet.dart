import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../globals/constants.dart';
import '../models/student_model.dart';

class GuardianBottomSheet extends StatelessWidget {
  const GuardianBottomSheet({required this.student, super.key});
  final Student student;

  @override
  Widget build(BuildContext context) {
    final guardians = student.guardians;
    final showGuardians = false.obs;

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.65),
      decoration: const BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.4), borderRadius: kBorderRadius4)),
              const SizedBox(height: 16),
              // Toggle
              _Toggle(
                isGuardian: showGuardians.value,
                onChanged: (val) => showGuardians.value = val,
              ),
              const SizedBox(height: 16),
              // Content
              if (!showGuardians.value && student.parentName != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _ContactCard(
                    name: student.parentName!,
                    subtitle: student.parentEmail,
                    mobile: student.parentMobile,
                  ),
                ),
              if (showGuardians.value && guardians.isNotEmpty)
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: guardians.length,
                    itemBuilder: (_, i) => _GuardianCard(guardian: guardians[i]),
                  ),
                ),
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 32),
            ],
          )),
    );
  }
}

class _Toggle extends StatelessWidget {
  const _Toggle({required this.isGuardian, required this.onChanged});
  final bool isGuardian;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: kBorderRadius8,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: !isGuardian ? Colors.white : Colors.transparent,
                  borderRadius: kBorderRadius6,
                ),
                child: Text(
                  "Parent",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: !isGuardian ? kPrimaryColor : Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isGuardian ? Colors.white : Colors.transparent,
                  borderRadius: kBorderRadius6,
                ),
                child: Text(
                  "Guardian",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isGuardian ? kPrimaryColor : Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.name, this.subtitle, this.mobile});
  final String name;
  final String? subtitle;
  final String? mobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: Radius.circular(40), bottomRight: Radius.circular(6), topLeft: Radius.circular(6), bottomLeft: Radius.circular(6)),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 24, backgroundColor: kLightGrey, child: Icon(Icons.person, color: kGrey)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kBlack)),
                if (subtitle != null && subtitle!.isNotEmpty) Text(subtitle!, style: const TextStyle(fontSize: 12, color: kGrey)),
                if (mobile != null && mobile!.isNotEmpty) Text(mobile!, style: const TextStyle(fontSize: 12, color: kGrey)),
              ],
            ),
          ),
          if (mobile != null && mobile!.isNotEmpty)
            GestureDetector(
              onTap: () => launchUrl(Uri.parse("tel:$mobile")),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(color: kGreen, borderRadius: kBorderRadius8),
                child: Text(mobile!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }
}

class _GuardianCard extends StatelessWidget {
  const _GuardianCard({required this.guardian});
  final Guardian guardian;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: Radius.circular(40), bottomRight: Radius.circular(6), topLeft: Radius.circular(6), bottomLeft: Radius.circular(6)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: kLightGrey,
            backgroundImage: guardian.photo != null ? NetworkImage(guardian.photo!) : null,
            child: guardian.photo == null ? const Icon(Icons.person, color: kGrey) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(guardian.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kBlack)),
                Text(guardian.relation, style: const TextStyle(fontSize: 12, color: kDarkGrey)),
                if (guardian.email != null && guardian.email!.isNotEmpty)
                  Text(guardian.email!, style: const TextStyle(fontSize: 12, color: kGrey)),
                if (guardian.occupation != null && guardian.occupation!.isNotEmpty)
                  Text(guardian.occupation!, style: const TextStyle(fontSize: 12, color: kGrey)),
              ],
            ),
          ),
          if (guardian.mobile != null && guardian.mobile!.isNotEmpty)
            GestureDetector(
              onTap: () => launchUrl(Uri.parse("tel:${guardian.mobile}")),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(color: kGreen, borderRadius: kBorderRadius8),
                child: Text(guardian.mobile!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }
}
