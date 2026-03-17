import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({this.label = "", this.canPop = true, this.height = 60, super.key, this.leading, this.trailing, this.backgroundColor = kPrimaryColor, this.labelPadding = const EdgeInsets.symmetric(horizontal: 12), this.contentPadding = const EdgeInsets.only(left: 12, right: 12), this.centerLabel = false});

  final String label;
  final double height;
  final bool canPop;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsets labelPadding;
  final EdgeInsets contentPadding;
  final bool centerLabel;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).viewPadding.top;
    return Container(
      height: height + topPadding,
      width: Get.size.width,
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: topPadding + contentPadding.top, left: contentPadding.left, right: contentPadding.right, bottom: contentPadding.bottom),
      decoration: BoxDecoration(color: backgroundColor),
      child: centerLabel
          ? Stack(
              children: [
                if (leading != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: leading!,
                  )
                else if (canPop && Navigator.of(context).canPop())
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 40,
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                      ),
                    ),
                  ),
                Center(
                  child: Padding(
                    padding: labelPadding,
                    child: Text(
                      label,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                if (trailing != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: trailing!,
                  ),
              ],
            )
          : Row(
              children: [
                if (leading != null)
                  leading!
                else if (canPop && Navigator.of(context).canPop())
                  SizedBox(
                    width: 40,
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    ),
                  ),
                Padding(
                  padding: labelPadding,
                  child: Text(
                    label,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const Spacer(),
                if (trailing != null) trailing!,
              ],
            ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, height);
}
