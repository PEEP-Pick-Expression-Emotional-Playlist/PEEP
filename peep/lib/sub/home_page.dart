import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peep/home/emotion_chart.dart';
import 'package:peep/home/play_cards.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peep/home/emotion_detection.dart';
import 'package:peep/mini_player_controller.dart';
import 'package:peep/player/music_player_page.dart';
import 'package:peep/player/player_controller.dart';
import '../home/client.dart';
import '../home/emotion_chart.dart';
//import 'package:flutter_svg_provider/flutter_svg_provider.dart';

//홈페이지

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int blueFreq;
  int fearFreq;
  int angryFreq;
  int happyFreq;
  int calmFreq;

  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    EmotionChart(
      chartData: [
        ChartData('BLUE', blueFreq),
        ChartData('FEAR', fearFreq),
        ChartData('ANGRY', angryFreq),
        ChartData('HAPPY', happyFreq),
        ChartData('CALM', calmFreq)
      ],
    );
  }

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
      body: SingleChildScrollView(
          child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 16.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      //회원정보 가져와서 회원 이름 + 님의 감정 분석
                      name + ' 님의 감정이 기록되었습니다',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Center(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: firestore.collection("emotion").snapshots(),
                      builder: (context, snapshot){
                        if(!snapshot.hasData){
                          return CircularProgressIndicator();
                        }else{
                          blueFreq = snapshot.data.docs[0]['sad'];
                          happyFreq = snapshot.data.docs[0]['happy'];
                          angryFreq = snapshot.data.docs[0]['angry'];
                          calmFreq = snapshot.data.docs[0]['calm'];
                          fearFreq = snapshot.data.docs[0]['fear'];
                          return EmotionChart(
                            chartData: [
                              ChartData('BLUE', blueFreq),
                              ChartData('FEAR', fearFreq),
                              ChartData('ANGRY', angryFreq),
                              ChartData('HAPPY', happyFreq),
                              ChartData('CALM', calmFreq)
                            ],
                          );
                        }
                      }
                    )
                      ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Center(
                    child: Ink(
                        decoration: const ShapeDecoration(
                            color: const Color(0xfff6f7f9),
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.elliptical(30, 30),
                                  right: Radius.elliptical(30, 30)),
                            )),
                        ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      '감정 진단하기',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Container(
                    //padding: EdgeInsets.only(left: 16.0),
                      margin: EdgeInsets.all(12),
                      // color: const Color(0xfff6f7f9),
                      // height: 300,
                      // width: 500,
                      child: Ink(
                        height: 270,
                        width: 550,
                        decoration: const ShapeDecoration(
                            color: const Color(0xfff6f7f9),
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.elliptical(30, 30),
                                  right: Radius.elliptical(30, 30)),
                            )),
                        child: Column(
                          // heightFactor: 3,
                          // widthFactor: 5,
                          children: <Widget>[
                            SizedBox(
                              height: 50,
                            ),
                            SvgPicture.asset('assets/itd/ITD_camera_faceicon.svg'),
                            //SizedBox(height: 10,),
                            //icon
                            //SvgPicture.asset('assets/itd/ITD_camera_start.svg')
                            SizedBox(
                              height: 100,
                              width: 300,
                              child: new IconButton(
                                icon: SvgPicture.asset(
                                  'assets/itd/ITD_camera_start.svg',
                                ),
                                onPressed: () {
                                  print('Camera button is clicked');
                                  Navigator.push(
                                    //getImage(ImageSource.camera);
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EmotionDetect()));
                                  //클릭 시 감정 분석 카메라로 이동
                                  //현재 임시 이미지 넣어둠
                                },
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 24.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      '오늘의 감정 키워드',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5, bottom: 0, top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                            width: 191,
                            height:124.54,
                            child:
                            IconButton(
                              icon:SvgPicture.asset(
                                'assets/itd/ITD_button_HAPPY.svg',
                                width: 191,
                                height:124.54,
                                fit: BoxFit.fill,
                              ),
                              onPressed: () async {
                                await setData("happy");
                                await ClientTest().readAndWrite("happy");
                                AudioManager.emotion = "happy";
                                Navigator.push(
                                  //getImage(ImageSource.camera);
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        MusicPlayerPage()));
                              },
                            )
                        ),
                        SizedBox(
                          width: 0
                        ),
                        SizedBox(
                            width: 191,
                            height:124.54,
                            child:
                            IconButton(
                              icon:SvgPicture.asset(
                                'assets/itd/ITD_button_BLUE.svg',
                                width: 191,
                                height:124.54,
                                fit: BoxFit.fill,
                              ),
                              onPressed: () async {
                                await setData("sad");
                                await ClientTest().readAndWrite("sad");
                                AudioManager.emotion = "sad";
                                Navigator.push(
                                  //getImage(ImageSource.camera);
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        MusicPlayerPage()));
                              },
                            )
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                            width: 191,
                            height:124.54,
                            child:
                            IconButton(
                              icon:SvgPicture.asset(
                                'assets/itd/ITD_button_ANGRY.svg',
                                width: 191,
                                height:124.54,
                                fit: BoxFit.fill,
                              ),
                              onPressed: () async {
                                await setData("angry");
                                await ClientTest().readAndWrite("angry");
                                AudioManager.emotion = "angry";
                                Navigator.push(
                                  //getImage(ImageSource.camera);
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        MusicPlayerPage()));
                              },
                            )
                        ),
                        SizedBox(
                          width: 0,
                        ),
                        SizedBox(
                            width: 191,
                            height:124.54,
                            child:
                            IconButton(
                              icon:SvgPicture.asset(
                                'assets/itd/ITD_button_CALM.svg',
                                width: 191,
                                height:124.54,
                                fit: BoxFit.fill,
                              ),
                              onPressed: () async {
                                await setData("calm");
                                await ClientTest().readAndWrite("calm");
                                AudioManager.emotion = "calm";
                                Navigator.push(
                                  //getImage(ImageSource.camera);
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        MusicPlayerPage()));
                              },
                            )
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                            width: 191,
                            height:124.54,
                            child:
                            IconButton(
                              icon:SvgPicture.asset(
                                'assets/itd/ITD_button_FEAR.svg',
                                width: 191,
                                height:124.54,
                                fit: BoxFit.fill,
                              ),
                              onPressed: () async {
                                await setData("fear");
                                await ClientTest().readAndWrite("fear");
                                AudioManager.emotion = "fear";
                                Navigator.push(
                                  //getImage(ImageSource.camera);
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        MusicPlayerPage()));
                              },
                            )
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                ],
              ))),
    );
  }

  Future<void> setData(String emotionState) async{
    await firestore.collection("current").doc("state").update({"emotion":emotionState});
  }
}