import 'package:flutter/material.dart';

import '../globals/constants.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.backgroundColor = kPrimaryColor,
    this.foregroundColor = Colors.white,
    this.borderRadius = 8,
    this.height = 48,
    this.width,
    this.fontSize = 16,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;
  final double height;
  final double? width;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: TextButton(
        onPressed: (isLoading || !enabled) ? null : onPressed,
        style: TextButton.styleFrom(
          backgroundColor: enabled ? backgroundColor : Colors.grey,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
              )
            : Text(
                label,
                style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600, color: foregroundColor),
              ),
      ),
    );
  }
}
