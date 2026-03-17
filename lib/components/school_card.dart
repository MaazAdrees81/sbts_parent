import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../globals/constants.dart';
import '../globals/images.dart';
import '../models/school_model.dart';

class SchoolCard extends StatelessWidget {
  const SchoolCard({required this.school, super.key});
  final School school;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: kBorderRadius20,
        boxShadow: [kCardsShadow2],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: kBorderRadius12,
            child: Image.asset(Images.appLogo, width: 80, height: 80, fit: BoxFit.contain),
          ),
          const SizedBox(height: 10),
          Text(
            school.name,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: kBlack),
            textAlign: TextAlign.center,
          ),
          if (school.fullAddress.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              school.fullAddress,
              style: const TextStyle(fontSize: 12, color: kDarkGrey),
              textAlign: TextAlign.center,
            ),
          ],
          if (school.phone != null && school.phone!.isNotEmpty) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => launchUrl(Uri.parse("tel:${school.phone}")),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.phone, size: 15, color: kPrimaryColor),
                  const SizedBox(width: 5),
                  Text(
                    school.phone!,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kPrimaryColor),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
