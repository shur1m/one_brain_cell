import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PageCreator {
  static Widget makeTitle(String title, BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline1,
          //overflow: TextOverflow.ellipsis,
          softWrap: true,
        ));
  }

  static Widget makeTitleWithBack(String title, BuildContext context) {
    return Row(
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
    );
  }

  static Widget makeCircularTextField(
      {required BuildContext context,
      required TextEditingController? controller,
      required String placeholder,
      int minLines = 8}) {
    return TextField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyText1,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
                width: 2.0, color: Theme.of(context).secondaryHeaderColor),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          hintStyle: TextStyle(color: Colors.grey),
          hintText: placeholder),
      maxLines: null,
      minLines: 8,
    );
  }

  static Widget makeCirclePercentage(double percentage, Color color,
      double size, double stroke, double fontSize) {
    int displayPercentage = (percentage * 100).toInt();
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Text(displayPercentage.toString() + '%',
              style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          CustomPaint(
            size: Size(size, size),
            painter: Arc(1.0, Colors.grey.shade200, stroke),
          ),
          CustomPaint(
              size: Size(size, size), painter: Arc(percentage, color, stroke)),
        ]);
  }

  static Widget makeDismissibleBackground(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade200,
      body: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.delete, color: Theme.of(context).scaffoldBackgroundColor),
          Padding(padding: EdgeInsets.only(right: 14)),
        ],
      )),
    );
  }

  static Future<dynamic> makeEditFlashcardSheet(
      BuildContext context,
      TextEditingController frontTextController,
      TextEditingController backTextController,
      void Function() onDone) {
    return showCupertinoModalBottomSheet(
        animationCurve: Curves.ease,
        duration: const Duration(milliseconds: 200),
        context: context,
        builder: (context) {
          return Scaffold(
              appBar: CupertinoNavigationBar(
                leading: CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.grey)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                trailing: CupertinoButton(
                  child: Text('Done',
                      style: TextStyle(color: Theme.of(context).buttonColor)),
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    //ensure that there are front and back fields
                    if (frontTextController.text.isEmpty ||
                        backTextController.text.isEmpty) {
                      showCupertinoDialog<void>(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Text('Empty Text Fields')),
                              content: Text(
                                  'Fun fact: You can\'t learn anything from an empty flashcard.'),
                              actions: [
                                CupertinoDialogAction(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    })
                              ],
                            );
                          });
                      return;
                    }

                    //this should add entry to list in db
                    //then add rowid to hivelist of CardCollection (curcardlist)
                    onDone();
                  },
                ),
              ),
              body: ListView(children: [
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 9, horizontal: 18),
                    child: PageCreator.makeCircularTextField(
                        context: context,
                        controller: frontTextController,
                        placeholder: 'Flashcard Front')),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 9, horizontal: 18),
                    child: PageCreator.makeCircularTextField(
                        context: context,
                        controller: backTextController,
                        placeholder: 'Flashcard Back'))
              ]));
        });
  }
}

//for creating arcs of certain length starting from top center
class Arc extends CustomPainter {
  Arc(double percentage, Color color, double strokeWidth) {
    this.percentage = percentage;
    this.color = color;
    this.strokeWidth = strokeWidth;
  }

  late double percentage;
  late Color color;
  late double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        width: size.width / 2,
        height: size.height / 2);

    final startAngle = -math.pi / 2;
    final sweepAngle = (math.pi * 2) * this.percentage;

    final useCenter = false;
    final paint = Paint()
      ..color = this.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = this.strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
