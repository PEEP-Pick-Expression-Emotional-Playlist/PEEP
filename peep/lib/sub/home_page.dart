import 'package:flutter/material.dart';
import 'package:peep/home/emotion_chart.dart';
import 'package:peep/home/play_cards.dart';

//홈페이지

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<ChartData> chartData = [
    ChartData('HAPPY', 44),
    ChartData('BLUE', 90),
    ChartData('SURPRISED', 20),
    ChartData('CALM', 30),
    ChartData('TIRED', 55)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.fromLTRB(15.0, 35.0, 0.0, 0.0),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              //회원정보 가져와서 회원 이름 + 님의 감정 분석
              'USERNAME 님의 감정 분석',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Center(
                child: EmotionChart(
              chartData: chartData,
            )),
            SizedBox(
              height: 10.0,
            ),
            Text(
              '통계',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            PlayCards(
              cards: [
                Card(color: Colors.black26,shadowColor: Colors.transparent,),
                Card(color: Colors.black26,shadowColor: Colors.transparent,),
                Card(color: Colors.black26,shadowColor: Colors.transparent,),
                Card(color: Colors.black26,shadowColor: Colors.transparent,),
                Card(color: Colors.black26,shadowColor: Colors.transparent,)],),
          ],
        ))),
      ),
    );
  }


}
