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
    ;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(top: 20)),
            Center(
              child: PageCreator.makeCirclePercentage(_reviewPercentage,
                  Theme.of(context).secondaryHeaderColor, 200, 15, 24),
            ),
          ]),
    );
  }

  //chart testing
}
