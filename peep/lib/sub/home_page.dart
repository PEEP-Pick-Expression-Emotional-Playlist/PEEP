import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peep/home/emotion_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peep/login/user_manager.dart';
import 'package:peep/player/music_player_page.dart';
import 'package:peep/player/player_controller.dart';
import '../db_manager.dart';
import '../home/client.dart';
import '../home/emotion_chart.dart';

//홈페이지

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userEmotionRef = DBManager.instance.ref
      .child("emotion")
      .child(UserManager.instance.user.uid);
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
              child: StreamBuilder(
                  stream: userEmotionRef.child("freq").onValue,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    } else {
                      blueFreq = 0;
                      happyFreq = 0;
                      angryFreq = 0;
                      calmFreq = 0;
                      fearFreq = 0;
                      if (snapshot.hasData &&
                          !snapshot.hasError &&
                          snapshot.data.snapshot.value != null) {
                        var val = snapshot.data.snapshot.value;
                        blueFreq = val['blue'];
                        happyFreq = val['happy'];
                        angryFreq = val['angry'];
                        calmFreq = val['calm'];
                        fearFreq = val['fear'];
                      } else {
                        userEmotionRef
                            .child("freq")
                            .child("blue")
                            .set(blueFreq);
                        userEmotionRef
                            .child("freq")
                            .child("happy")
                            .set(happyFreq);
                        userEmotionRef
                            .child("freq")
                            .child("angry")
                            .set(angryFreq);
                        userEmotionRef
                            .child("freq")
                            .child("calm")
                            .set(calmFreq);
                        userEmotionRef
                            .child("freq")
                            .child("fear")
                            .set(fearFreq);
                      }
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
                  })),
          SizedBox(
            height: 16.0,
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
                    height: 124.54,
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/itd/ITD_button_HAPPY.svg',
                        width: 191,
                        height: 124.54,
                        fit: BoxFit.fill,
                      ),
                      onPressed: () async {
                        await setData("happy");
                        await ClientTest().readAndWrite("happy");
                        AudioManager.emotion = "happy";
                        Navigator.push(
                            //getImage(ImageSource.camera);
                            context,
                            MaterialPageRoute(
                                builder: (context) => MusicPlayerPage()));
                      },
                    )),
                SizedBox(width: 0),
                SizedBox(
                    width: 191,
                    height: 124.54,
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/itd/ITD_button_BLUE.svg',
                        width: 191,
                        height: 124.54,
                        fit: BoxFit.fill,
                      ),
                      onPressed: () async {
                        await setData("blue");
                        await ClientTest().readAndWrite("blue");
                        AudioManager.emotion = "blue";
                        Navigator.push(
                            //getImage(ImageSource.camera);
                            context,
                            MaterialPageRoute(
                                builder: (context) => MusicPlayerPage()));
                      },
                    )),
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
                    height: 124.54,
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/itd/ITD_button_ANGRY.svg',
                        width: 191,
                        height: 124.54,
                        fit: BoxFit.fill,
                      ),
                      onPressed: () async {
                        await setData("angry");
                        await ClientTest().readAndWrite("angry");
                        AudioManager.emotion = "angry";
                        Navigator.push(
                            //getImage(ImageSource.camera);
                            context,
                            MaterialPageRoute(
                                builder: (context) => MusicPlayerPage()));
                      },
                    )),
                SizedBox(
                  width: 0,
                ),
                SizedBox(
                    width: 191,
                    height: 124.54,
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/itd/ITD_button_CALM.svg',
                        width: 191,
                        height: 124.54,
                        fit: BoxFit.fill,
                      ),
                      onPressed: () async {
                        await setData("calm");
                        await ClientTest().readAndWrite("calm");
                        AudioManager.emotion = "calm";
                        Navigator.push(
                            //getImage(ImageSource.camera);
                            context,
                            MaterialPageRoute(
                                builder: (context) => MusicPlayerPage()));
                      },
                    )),
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
                    height: 124.54,
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/itd/ITD_button_FEAR.svg',
                        width: 191,
                        height: 124.54,
                        fit: BoxFit.fill,
                      ),
                      onPressed: () async {
                        await setData("fear");
                        await ClientTest().readAndWrite("fear");
                        AudioManager.emotion = "fear";
                        Navigator.push(
                            //getImage(ImageSource.camera);
                            context,
                            MaterialPageRoute(
                                builder: (context) => MusicPlayerPage()));
                      },
                    )),
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

  Future<void> setData(String emotionState) async {
    var uid;
    final user = FirebaseAuth.instance.currentUser;
    final databaseReference =
        FirebaseDatabase.instance.reference().child("emotion");

    if (user != null) {
      uid = user.uid;
    }
    await databaseReference
        .child(uid + "/" + "current")
        .update({"emotion": emotionState});
    //   await firestore
    //       .collection("current")
    //       .doc("state")
    //       .update({"emotion": emotionState});
  }
}
