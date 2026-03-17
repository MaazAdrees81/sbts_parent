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
    final parentsList = student.parents;
    final guardiansList = student.guardians;
    final showGuardians = false.obs;

    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
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
              _Toggle(
                isGuardian: showGuardians.value,
                onChanged: (val) => showGuardians.value = val,
              ),
              const SizedBox(height: 16),
              Flexible(
                child: Builder(builder: (_) {
                  final list = !showGuardians.value ? parentsList : guardiansList;
                  final maxCount = !showGuardians.value ? 2 : 2;
                  final count = list.isEmpty ? maxCount : list.length;
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: count,
                    itemBuilder: (_, i) => i < list.length
                        ? _PersonCard(person: list[i])
                        : const _NaCard(),
                  );
                }),
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

class _PersonCard extends StatelessWidget {
  const _PersonCard({required this.person});
  final Guardian person;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
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
            backgroundImage: person.photo != null ? NetworkImage(person.photo!) : null,
            child: person.photo == null ? const Icon(Icons.person, color: kGrey) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(person.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kBlack)),
                Text(person.relation, style: const TextStyle(fontSize: 12, color: kDarkGrey)),
                if (person.email != null && person.email!.isNotEmpty)
                  Text(person.email!, style: const TextStyle(fontSize: 12, color: kGrey), overflow: TextOverflow.ellipsis),
                if (person.occupation != null && person.occupation!.isNotEmpty)
                  Text(person.occupation!, style: const TextStyle(fontSize: 12, color: kGrey), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          if (person.mobile != null && person.mobile!.isNotEmpty)
            GestureDetector(
              onTap: () => launchUrl(Uri.parse("tel:${person.mobile}")),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(color: kGreen, borderRadius: kBorderRadius8),
                child: Text(person.mobile!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }
}

class _NaCard extends StatelessWidget {
  const _NaCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: Radius.circular(40), bottomRight: Radius.circular(6), topLeft: Radius.circular(6), bottomLeft: Radius.circular(6)),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 24, backgroundColor: kLightGrey, child: Icon(Icons.person, color: kGrey)),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("N/A", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kBlack)),
                Text("N/A", style: TextStyle(fontSize: 12, color: kDarkGrey)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(color: kGrey, borderRadius: kBorderRadius8),
            child: const Text("N/A", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}