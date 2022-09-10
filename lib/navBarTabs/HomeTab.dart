import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:one_brain_cell/utils/PageCreator.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  double _reviewPercentage = 0.32;

  Widget build(BuildContext context) {
    int displayReview = (_reviewPercentage * 100).toInt();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: PageCreator.makeCirclePercentage(_reviewPercentage,
            Theme.of(context).secondaryHeaderColor, 200, 15, 24),
      ),
    );
  }
}

//for creating arcs of certain length starting from top center
class Arc extends CustomPainter {
  Arc(double percentage, Color color) {
    this.percentage = percentage;
    this.color = color;
  }

  late double percentage;
  late Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        width: 100,
        height: 100);

    final startAngle = -math.pi / 2;
    final sweepAngle = (math.pi * 2) * this.percentage;

    final useCenter = false;
    final paint = Paint()
      ..color = this.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
