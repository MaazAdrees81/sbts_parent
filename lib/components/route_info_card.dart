import 'package:flutter/material.dart';

import '../globals/constants.dart';
import '../models/stop_model.dart';

class RouteInfoCard extends StatelessWidget {
  const RouteInfoCard({
    required this.routeName,
    required this.registrationNo,
    required this.firstStop,
    required this.lastStop,
    required this.isMorning,
    this.onToggleSchedule,
    super.key,
  });

  final String routeName;
  final String registrationNo;
  final Stop? firstStop;
  final Stop? lastStop;
  final bool isMorning;
  final VoidCallback? onToggleSchedule;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5B6CFF), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: kBorderRadius16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Route: $routeName", style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    Text("Bus no: $registrationNo", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              if (onToggleSchedule != null)
                GestureDetector(
                  onTap: onToggleSchedule,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: kBorderRadius8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(isMorning ? Icons.wb_sunny : Icons.nights_stay, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(isMorning ? "Morning" : "Evening", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(firstStop?.name ?? "", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
              ),
              Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
              Expanded(
                child: CustomPaint(
                  painter: _DashedLinePainter(),
                  child: const SizedBox(height: 10),
                ),
              ),
              Container(width: 10, height: 10, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
              Expanded(
                child: Text(lastStop?.name ?? "", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(child: Text(isMorning ? (firstStop?.morningTime ?? "") : (firstStop?.eveningTime ?? ""), style: const TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center)),
              const Expanded(flex: 3, child: Center(child: Text("12 km", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)))),
              Expanded(child: Text(isMorning ? (lastStop?.morningTime ?? "") : (lastStop?.eveningTime ?? ""), style: const TextStyle(color: Colors.white70, fontSize: 12), textAlign: TextAlign.center)),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    double startX = 0;
    final y = size.height / 2;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, y), Offset(startX + dashWidth, y), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
