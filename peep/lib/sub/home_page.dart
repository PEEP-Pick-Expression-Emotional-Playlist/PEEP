import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peep/home/emotion_chart.dart';
import 'package:peep/home/play_cards.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peep/home/emotion_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
//import 'package:flutter_svg_provider/flutter_svg_provider.dart';

//홈페이지

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<ChartData> chartData = [
    ChartData('BLUE', 94),
    ChartData('FEAR', 100),
    ChartData('ANGRY', 20),
    ChartData('HAPPY', 30),
    ChartData('CALM', 55)
  ];



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
              name + ' 님의 감정 분석',
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
              child: EmotionChart(
            chartData: chartData,
          )),
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
                    )
              ),
              child: IconButton(
                
            icon: const Icon(Icons.pause),
            onPressed: () {
              print('Camera button is clicked');
              Navigator.push(
                  //getImage(ImageSource.camera);
                  context,
                  MaterialPageRoute(builder: (context) => EmotionDetect()));
              //클릭 시 감정 분석 카메라로 이동
              //현재 임시 이미지 넣어둠
            },
          )
          ),
          ),
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
            margin: EdgeInsets.only(left: 20, bottom: 15, top: 10),
            child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                       Container(
                        child:SvgPicture.asset(
                        'assets/itd/ITD_button_1-1.svg',
                        width: 180,
                        ),
                       ),
                       SizedBox(width: 10,),
                       Container(
                         child:SvgPicture.asset(
                        'assets/itd/ITD_button_1-2.svg',
                        width: 180,
                        ),
                       ),
                       
                      ],
                     
            
              ),
              
          ),          
          Container(
            margin: EdgeInsets.only(left: 20, bottom: 15),
            child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                       Container(
                        child:SvgPicture.asset(
                        'assets/itd/ITD_button_1-3.svg',
                        width: 180,
                        ),
                       ),
                       SizedBox(width: 10,),
                       Container(
                         child:SvgPicture.asset(
                        'assets/itd/ITD_button_1-4.svg',
                        width: 180,
                        ),
                       ),
                       
                      ],
                     
            
              ),
              
          ),       
          Container(
            margin: EdgeInsets.only(left: 20),
            child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                       Container(
                        child:SvgPicture.asset(
                        'assets/itd/ITD_button_1-5.svg',
                        width: 180,
                        ),
                       ),
                       
                       
                      ],
                     
            
              ),
              
          ),       
          // Padding(
          //     padding: EdgeInsets.only(left: 16.0),
          //     child: PlayCards(
          //       cards: [
          //         // Card(
          //         //   color: Colors.black12,
          //         //   shadowColor: Colors.transparent,
          //         //   child: Row(
          //         //     mainAxisAlignment: MainAxisAlignment.start,
          //         //     children: <Widget>[
          //         //       Text('    '),
          //         //       SvgPicture.asset(
          //         //       'assets/itd/ITD_icon_happy.svg',
          //         //       height: 20,
          //         //       width: 20,
          //         //       ),
                    
          //         //   Row(
          //         //     mainAxisAlignment: MainAxisAlignment.end,
          //         //     children: <Widget>[
          //         //       Text('    '),
          //         //       Text('HAPPY')
          //         //     ],),
          //         //     ],
          //         //   ), 
          //         //  ),//happy
                   
          //         // Card(
          //         //   color: Colors.black12,
          //         //   shadowColor: Colors.transparent,
          //         //   child: Row(
          //         //     mainAxisAlignment: MainAxisAlignment.start,
          //         //     children: <Widget>[
          //         //       Text('    '),
          //         //       SvgPicture.asset(
          //         //       'assets/itd/ITD_icon_calm.svg',
          //         //       height: 20,
          //         //       width: 20,
          //         //       ),
                    
          //         //   Row(
          //         //     mainAxisAlignment: MainAxisAlignment.end,
          //         //     children: <Widget>[
          //         //       Text('    '),
          //         //       Text('CALM')
          //         //     ],),
          //         //     ],
          //         //   ), 
          //         // ),//calm
          //         // Card(
          //         //   color: Colors.black12,
          //         //   shadowColor: Colors.transparent,
          //         //   child: Row(
          //         //     mainAxisAlignment: MainAxisAlignment.start,
          //         //     children: <Widget>[
          //         //       Text('    '),
          //         //       SvgPicture.asset(
          //         //       'assets/itd/ITD_icon_blue.svg',
          //         //       height: 20,
          //         //       width: 20,
          //         //       ),
                    
          //         //   Row(
          //         //     mainAxisAlignment: MainAxisAlignment.end,
          //         //     children: <Widget>[
          //         //       Text('    '),
          //         //       Text('BLUE')
          //         //     ],),
          //         //     ],
          //         //   ), 
          //         // ),//blue
          //         // Card(
          //         //   color: Colors.black12,
          //         //   shadowColor: Colors.transparent,
          //         //   child: Row(
          //         //     mainAxisAlignment: MainAxisAlignment.start,
          //         //     children: <Widget>[
          //         //       Text('    '),
          //         //       SvgPicture.asset(
          //         //       'assets/itd/ITD_icon_fear.svg',
          //         //       height: 20,
          //         //       width: 20,
          //         //       ),
                    
          //         //   Row(
          //         //     mainAxisAlignment: MainAxisAlignment.end,
          //         //     children: <Widget>[
          //         //       Text('    '),
          //         //       Text('FEAR')
          //         //     ],),
          //         //     ],
          //         //   ), 
          //         // ),
          //         // Card(
          //         //   color: Colors.black12,
          //         //   shadowColor: Colors.transparent,
          //         //   child: Row(
          //         //     mainAxisAlignment: MainAxisAlignment.start,
          //         //     children: <Widget>[
          //         //       Text('    '),
          //         //       SvgPicture.asset(
          //         //       'assets/itd/ITD_icon_angry.svg',
          //         //       height: 20,
          //         //       width: 20,
          //         //       ),
                    
          //         //   Row(
          //         //     mainAxisAlignment: MainAxisAlignment.end,
          //         //     children: <Widget>[
          //         //       Text('    '),
          //         //       Text('ANGRY')
          //         //     ],),
          //         //     ],
          //         //   ), 
          //         // ),//angry
          //         Card(
          //           color: Colors.white,
          //           shadowColor: Colors.transparent,
          //           child: SvgPicture.asset('assets/itd/ITD_button_1-1.svg'),
          //         ),
          //         Card(
          //           color: Colors.white,
          //           shadowColor: Colors.transparent,
          //           child: SvgPicture.asset('assets/itd/ITD_button_1-2.svg'),
          //         ),
          //         Card(
          //           color: Colors.white,
          //           shadowColor: Colors.transparent,
          //           child: SvgPicture.asset('assets/itd/ITD_button_1-3.svg'),
          //         ),
          //         Card(
          //           color: Colors.white,
          //           shadowColor: Colors.transparent,
          //           child: SvgPicture.asset('assets/itd/ITD_button_1-4.svg'),
          //         ),
          //         Card(
          //           color: Colors.white,
          //           shadowColor: Colors.transparent,
                    
          //           child: SvgPicture.asset('assets/itd/ITD_button_1-5.svg'),

          //         ),
          //       ],
          //     )),
          SizedBox(
            height: 24.0,
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
          margin: EdgeInsets.all(20),
          // color: const Color(0xfff6f7f9),
          // height: 300,
          // width: 500,
          child: Ink(
            height: 300,
            width: 500,
              decoration: const ShapeDecoration(
                color: const Color(0xfff6f7f9),
                shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.elliptical(30, 30),
                          right: Radius.elliptical(30, 30)),
                    )
              ),
          
          child: Column(
            
            // heightFactor: 3,
            // widthFactor: 5,
            children: <Widget>[
              
              SizedBox(height: 50,),
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
                      MaterialPageRoute(builder: (context) => EmotionDetect()));
                  //클릭 시 감정 분석 카메라로 이동
                  //현재 임시 이미지 넣어둠
                },
              ),),
              
            ],
            
            
            ),
          
          ),
        
        )],
      ))),
    );
  }
  Future<void> setEmoData(String emo) async{

  }
}
