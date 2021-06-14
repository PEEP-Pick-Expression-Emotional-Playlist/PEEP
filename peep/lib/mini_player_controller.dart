import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:peep/player/music_player_page.dart';
import 'package:peep/player/player_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MiniPlayerController extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => MiniPlayerControllerState();

}

class MiniPlayerControllerState extends State<MiniPlayerController> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String emotion;
  var processColor;
  var barColor;

  @override
  Widget build(BuildContext context) {
    return /*Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        LinearProgressIndicator(
            value: 0.5,
            backgroundColor: Colors.black26,
            valueColor: AlwaysStoppedAnimation<Color>(processColor)),*/
      Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: firestore.collection("current").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                emotion = snapshot.data.docs[0]['emotion'];
                switch (emotion) {
                  case "happy":
                    processColor = Color(0xFFE8C147);
                    barColor = Color(0xFFF6E7B7);
                    break;
                  case "sad":
                    processColor = Color(0xFF469DE2);
                    barColor = Color(0xFFB7DAF4);
                    break;
                  case "angry":
                    processColor = Color(0xFFCC6065);
                    barColor = Color(0xFFEBC2C4);
                    break;
                  case "calm":
                    processColor = Color(0xFF448265);
                    barColor = Color(0xFFB6CEC3);
                    break;
                  case "fear":
                    processColor = Color(0xFF61558E);
                    barColor = Color(0xFFC2BDD4);
                    break;
                  default:
                    processColor = Color(0xFFE8C147);
                    //processColor = Colors.black;
                    barColor = Color(0xFFF6E7B7);
                    break;
                }
                return new Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      LinearProgressIndicator(
                          value: 0.5,
                          backgroundColor: Colors.black26,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              processColor)),
                      Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.5, 1],
                                colors: [Colors.white, barColor],
                              )
                          ),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 6,
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 16.0,
                                        top: 16.0,
                                        bottom: 16.0,
                                        right: 8.0),
                                    child: Text(

                                        'Beautiful Mistakes'
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType
                                                .bottomToTop,
                                            child: MusicPlayerPage()));
                                  },
                                ),
                              ),
                              Expanded(
                                  flex: 4,
                                  child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(left: 8.0,
                                          top: 16.0,
                                          bottom: 16.0,
                                          right: 16.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceAround,
                                        children: <Widget>[
                                          PlayerController(
                                            prevIconName: 'player_mini_prev',
                                            playIconName: 'player_mini_play',
                                            nextIconName: 'player_mini_next',
                                            previousSize: 24.0,
                                            playSize: 36.0,
                                            nextSize: 24.0,
                                          ),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: BoxConstraints(),
                                            icon: SvgPicture.asset(
                                                'assets/icons/player_mini_list.svg'),
                                            iconSize: 24.0,
                                            onPressed: () {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                  new SnackBar(
                                                      content:
                                                      Text(
                                                          'onPressed Playlist Button')));
                                            },
                                          )
                                        ],
                                      ))),
                            ],
                          )
                      )
                    ]);
              }
            }
        ),
      );
  }
}
