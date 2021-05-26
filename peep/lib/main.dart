import 'package:flutter/material.dart';
import 'package:peep/sub/homePage.dart';
import 'package:peep/sub/searchPage.dart';
import 'package:peep/sub/userPage.dart';
import 'MiniPlayerController.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PEEP',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int screenIndex = 0;
  List<Widget> screenList = [HomePage(), SearchPage(), UserPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'PEEP',
          style: TextStyle(color: Colors.grey),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () {
                print('Camera button is clicked');
                //감정인식 카메라 버튼 누르면 카메라 화면으로 이동
              })
        ],
      ),
      body: screenList[screenIndex],
      bottomNavigationBar:
          Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        MiniPlayerController(), //하단 미니 음악 플레이어
        BottomNavigationBar(
          currentIndex: screenIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.grey), label: '홈'),
            BottomNavigationBarItem(
                icon: Icon(Icons.search, color: Colors.grey), label: '검색'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person, color: Colors.grey), label: 'MY'),
          ],
          onTap: (value) {
            setState(() {
              screenIndex = value;
            });
          },
        )
      ]),
    );
  }
}
