import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EmotionChart extends StatelessWidget {
  final List<ChartData> chartData;

  const EmotionChart({Key key, this.chartData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
        series: <CircularSeries>[
          // Renders radial bar chart
          RadialBarSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              cornerStyle: CornerStyle.bothCurve,
            radius: '100%',
            innerRadius: '40%',
            gap: '3%',
            sortingOrder: SortingOrder.none
          )
        ]
    );
  }

}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color color;
}