import 'package:flutter/material.dart';

import '../globals/constants.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({required this.currentIndex, required this.onTap, super.key});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, -2))],
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavItem(icon: Icons.map_outlined, activeIcon: Icons.map, label: "Map", isActive: currentIndex == 0, onTap: () => onTap(0)),
          GestureDetector(
            onTap: () => onTap(1),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: currentIndex == 1 ? kPrimaryColor : kPrimaryColor.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: kPrimaryColor.withValues(alpha: 0.4), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: const Icon(Icons.home, color: Colors.white, size: 28),
            ),
          ),
          _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: "Profile", isActive: currentIndex == 2, onTap: () => onTap(2)),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.activeIcon, required this.label, required this.isActive, required this.onTap});

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isActive ? activeIcon : icon, color: isActive ? kPrimaryColor : kGrey, size: 26),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: isActive ? FontWeight.w600 : FontWeight.w500, color: isActive ? kPrimaryColor : kGrey)),
          ],
        ),
      ),
    );
  }
}
