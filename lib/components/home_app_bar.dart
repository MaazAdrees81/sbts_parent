import 'package:flutter/material.dart';

import '../globals/images.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({this.leading, this.trailing, this.height = 200, super.key});

  final Widget? leading;
  final Widget? trailing;
  final double height;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).viewPadding.top;
    return SizedBox(
      height: height + topPadding,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(Images.topBar, fit: BoxFit.cover),
          ),
          Positioned(
            top: topPadding + 12,
            left: 12,
            right: 12,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Smart BUS",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "SCHOOL BUS SOLUTION",
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10, fontWeight: FontWeight.w500, letterSpacing: 1.2),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
