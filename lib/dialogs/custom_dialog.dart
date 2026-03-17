import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals/constants.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({this.title, this.titleStyle, this.message, this.minWidth = 320, this.backgroundColor = Colors.white, this.onTap, this.btnLabel, this.actionsWidget, this.icon, this.child, super.key});
  final String? message;
  final String? title;
  final TextStyle? titleStyle;
  final String? btnLabel;
  final VoidCallback? onTap;
  final Widget? child;
  final Widget? icon;
  final Widget? actionsWidget;
  final double minWidth;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: min(Get.width, minWidth),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: backgroundColor, borderRadius: kBorderRadius16),
          child:
              child ??
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    if (title != null)
                      Text(
                        title!,
                        style: titleStyle ?? const TextStyle(fontSize: 22, color: kLightBlack, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 20),
                    if (icon != null) Padding(padding: const EdgeInsets.only(bottom: 12), child: icon),
                    SelectableText(
                      message ?? "",
                      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    actionsWidget ??
                        InkWell(
                          onTap: onTap ?? () => Get.back(),
                          borderRadius: BorderRadius.circular(6),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(
                              btnLabel ?? "Close",
                              style: const TextStyle(color: kPrimaryColor, decorationColor: kPrimaryColor, decorationThickness: 3, decoration: TextDecoration.underline, fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                          ),
                        ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
