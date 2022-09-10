import 'package:flutter/material.dart';
import 'dart:math' as math;

class PageCreator {
  static Widget makeTitle(String title, BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 15, left: 8),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline1,
          overflow: TextOverflow.ellipsis,
        ));
  }

  static Widget makeTitleWithBack(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded)),
          Flexible(
            child: Container(
                padding: EdgeInsets.only(left: 1.2),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headline2,
                  overflow: TextOverflow.ellipsis,
                )),
          ),
        ],
      ),
    );
  }

  static Widget makeCirclePercentage(double percentage, Color color) {
    int displayPercentage = (percentage * 100).toInt();
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Text(displayPercentage.toString() + '%',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
          CustomPaint(
            size: Size(200, 200),
            painter: Arc(1.0, Colors.grey.shade200),
          ),
          CustomPaint(size: Size(200, 200), painter: Arc(percentage, color)),
        ]);
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
