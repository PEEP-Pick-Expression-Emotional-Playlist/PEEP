import 'package:flutter/material.dart';
import 'package:peep/home/emotion_chart.dart';
import 'package:peep/home/play_cards.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peep/home/emotion_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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

  File _image;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    var name, photo, email, uid;
    if (user != null) {
      uid = user.uid;
      name = user.displayName;
      photo = user.photoURL;
      email = user.email;
    }
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
              name + ' 님의 감정 분석',
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
            Center(
                child: FlatButton(
              child: Image.asset(
                'assets/camera_0.png',
                width: 40,
              ),
              onPressed: () {
                print('Camera button is clicked');
                takePicture();
                Navigator.push(
                    //getImage(ImageSource.camera);
                    context,
                    MaterialPageRoute(builder: (context) => EmotionDetect()));
                //클릭 시 감정 분석 카메라로 이동
                //현재 임시 이미지 넣어둠
              },
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
                Card(
                  color: Colors.black26,
                  shadowColor: Colors.transparent,
                ),
                Card(
                  color: Colors.black26,
                  shadowColor: Colors.transparent,
                ),
                Card(
                  color: Colors.black26,
                  shadowColor: Colors.transparent,
                ),
                Card(
                  color: Colors.black26,
                  shadowColor: Colors.transparent,
                ),
                Card(
                  color: Colors.black26,
                  shadowColor: Colors.transparent,
                )
              ],
            ),
          ],
        ))),
      ),
    );
  }

  Future<void> takePicture() async {
    final File imageFile =
        (await _picker.getImage(source: ImageSource.camera)) as File;
    if (imageFile == null) {
      print("no image");
      return;
    }
    final appDir = await getApplicationDocumentsDirectory();
    //await File(appDir.path+'/test.jpg').create(recursive: true);
    final File newImage = await imageFile.copy(appDir.path + '/test.jpg');
    setState(() {
      _image = newImage;
    });
  }
}
