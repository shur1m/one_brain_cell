import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:one_brain_cell/utils/pageCreator.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:one_brain_cell/utils/studyChart.dart';

//show progress in reviews
//show progress in recent lists
//show heatmap and max streak

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  double _reviewPercentage = 0.32;

  @override
  Widget build(BuildContext context) {
    //never place int of 0 in heapmapdata or crashes
    Map<DateTime, int> heatMapData = {
      DateTime(2022, 9, 6): 3,
      DateTime(2022, 9, 7): 7,
      DateTime(2022, 9, 1): 10,
      DateTime(2022, 8, 15): 13,
      DateTime(2022, 8, 16): 28,
    };

    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child:
                      PageCreator.makeTitle('Single-celled Progress', context),
                ),
                Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          PageCreator.makeCirclePercentage(
                              _reviewPercentage,
                              Theme.of(context).secondaryHeaderColor,
                              120,
                              13,
                              15),
                          Flexible(
                              child: Text(
                            'Keep reviewing and you might just get another!',
                            style: Theme.of(context).textTheme.bodyText2,
                            softWrap: true,
                            textAlign: TextAlign.center,
                          )),
                          Padding(padding: EdgeInsets.only(right: 25)),
                        ])),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(top: 16, left: 8),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Text('Total Cards Learned',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2)),
                              Text(
                                'We can\'t believe you\'ve come this far!',
                                style: Theme.of(context).textTheme.subtitle1,
                                softWrap: true,
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 10)),
                              Expanded(
                                  child:
                                      AreaAndLineChart.withStudyData(context)),
                            ]))),
                HeatMap(
                  datasets: heatMapData,
                  colorMode: ColorMode.opacity,
                  defaultColor: Colors.grey.shade100,
                  textColor: Theme.of(context).scaffoldBackgroundColor,
                  showText: false,
                  scrollable: true,
                  colorsets: {
                    1: Color.fromARGB(255, 146, 84, 255),
                  },
                  onClick: (DateTime value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(value.toString())));
                  },
                  showColorTip: false,
                )
              ]),
        )));
  }

  //chart testing
}
