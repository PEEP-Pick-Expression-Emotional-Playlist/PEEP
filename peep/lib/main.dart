import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:peep/sub/homePage.dart';
import 'package:peep/sub/searchPage.dart';
import 'package:peep/sub/userPage.dart';
import 'MiniPlayerController.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  final FirebaseApp app;

  const Home({Key key, this.app}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int screenIndex = 0;
  List<Widget> screenList = [HomePage(), SearchPage(), UserPage()];
  final fb = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference();
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
                // ref.child("abc").set("yoyoyo");
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
