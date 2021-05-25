import 'package:flutter/material.dart';

//홈페이지

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.fromLTRB(15.0, 35.0, 0.0, 0.0),
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
              child: CircleAvatar(
                //사용자 감상 통계 데이터 시각화 부분
                //현재는 임의의 고정 이미지로 넣어둠
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage('assets/dataex.png'),
                radius: 200,
              ),
            ),
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
            Row(
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                  ),
                  onPressed: () {
                    //버튼 클릭 시 HAPPY 플레이리스트 재생
                  },
                  child: Text(
                    'HAPPY',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                  ),
                  onPressed: () {
                    //버튼 클릭 시 BLUE 플레이리스트 재생
                  },
                  child: Text(
                    'BLUE',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                  ),
                  onPressed: () {
                    //버튼 클릭 시 SURPRISED 플레이리스트 재생
                  },
                  child: Text(
                    'SURPRISED',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                  ),
                  onPressed: () {
                    //버튼 클릭 시 CALM 플레이리스트 재생
                  },
                  child: Text(
                    'CALM',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                  ),
                  onPressed: () {
                    //버튼 클릭 시 TIRED 플레이리스트 재생
                  },
                  child: Text(
                    'TIRED',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
          ],
        ),
      ),
    );
  }
}
