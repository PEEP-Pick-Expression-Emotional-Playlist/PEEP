import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'emotion_detection.dart';

class EmotionChart extends StatefulWidget {
  final List<ChartData> chartData;
  const EmotionChart({Key key, this.chartData}) : super(key: key);
  @override
  State createState() {
    // _EmotionChart createState() => _EmotionChart();
    return _EmotionChart();
  }
}

class _EmotionChart extends State<EmotionChart>{
  // final List<ChartData> chartData;
  List<ChartData> chartData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
            sortingOrder: SortingOrder.descending
          )
        ],
      /// A chart for emotion frequency
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          angle: 0,
          radius: '0%',
          height: '80%',
          width: '80%',
          widget: SizedBox( /// [IconButton] for emotion camera.
            height: 80,
            width: 80,
            child: IconButton(
            icon: SvgPicture.asset(
                'assets/itd/ITD_camera_faceicon.svg',
              ),
              onPressed: () {
                // widthFactor: 5,
                print('Camera button is clicked');
                Navigator.push(
                  //getImage(ImagefSource.camera);
                    context,
                    MaterialPageRoute(builder: (context) => EmotionDetect()));
                //클릭 시 감정 분석 카메라로 이동
                //현재 임시 이미지 넣어둠
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final int y;
  final Color color;
}