/// Line chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class AreaAndLineChart extends StatelessWidget {
  final List<charts.Series<dynamic, num>> seriesList;
  final bool animate;

  AreaAndLineChart(this.seriesList, {required this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory AreaAndLineChart.withStudyData(BuildContext context) {
    return AreaAndLineChart(
      _getStudyData(context),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.LineChart(seriesList,
        animate: animate,
        domainAxis: charts.NumericAxisSpec(
            showAxisLine: true, renderSpec: charts.NoneRenderSpec()),
        primaryMeasureAxis: charts.NumericAxisSpec(
            tickProviderSpec:
                charts.BasicNumericTickProviderSpec(zeroBound: false)),
        customSeriesRenderers: [
          charts.LineRendererConfig(
              // ID used to link series to this renderer.
              customRendererId: 'customArea',
              includeArea: true,
              stacked: true),
        ]);
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<CardCount, int>> _getStudyData(context) {
    final myFakeDesktopData = [
      CardCount(0, 100),
      CardCount(1, 123),
      CardCount(2, 137),
      CardCount(3, 153),
      CardCount(4, 175),
      CardCount(5, 212),
      CardCount(6, 214),
    ];

    return [
      new charts.Series<CardCount, int>(
        id: 'Desktop',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            Theme.of(context).secondaryHeaderColor),
        domainFn: (CardCount count, _) => count.index,
        measureFn: (CardCount count, _) => count.count,
        data: myFakeDesktopData,
      )
        // Configure our custom bar target renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customArea'),
    ];
  }
}

/// Sample linear data type.
class CardCount {
  final int index;
  final int count;

  CardCount(this.index, this.count);
}
