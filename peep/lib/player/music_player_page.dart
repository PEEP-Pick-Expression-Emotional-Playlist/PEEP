import 'dart:math';

import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:peep/player/ui/seekbar.dart';
import 'ui/dropdown_demo.dart';
import 'ui/my_wave_clipper.dart';
import 'player_controller.dart';
import 'package:rxdart/rxdart.dart';

class MusicPlayerPage extends StatefulWidget {
  @override
  _MusicPlayerPageState createState() => new _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage>
    with TickerProviderStateMixin {
  final List<String> _yearValues = [
    "2020",
    "2010",
    "2000",
    "1990",
  ];

  final List<String> _genreValues = ['댄스', '발라드', '랩∙힙합', '록∙메탈'];

  // String _emotionValue = AudioManager.emotion;

  Animation<double> animation;
  Animation<double> animation2;
  Animation<double> animation3;
  Animation<double> animation4;

  AnimationController _controller;
  AnimationController _controller2;
  AnimationController _controller3;
  AnimationController _controller4;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 7), vsync: this);
    _controller.repeat();
    //we set animation duration, and repeat for infinity
    _controller2 =
      AnimationController(duration: Duration(seconds: 8), vsync: this);
      //두번째 웨이브 컨트롤러
    _controller2.repeat();

    _controller3 =
      AnimationController(duration: Duration(seconds: 9), vsync: this);
      //두번째 웨이브 컨트롤러
    _controller3.repeat();

    _controller4 =
      AnimationController(duration: Duration(seconds: 3), vsync: this);
      //두번째 웨이브 컨트롤러
    _controller4.repeat();

    animation = Tween<double>(begin: -400, end: 0).animate(_controller);
    animation2 = Tween<double>(begin: -400, end: 0).animate(_controller2);
    animation3 = Tween<double>(begin: -400, end: 0).animate(_controller3);
    animation4 = Tween<double>(begin: -400, end: 0).animate(_controller4);
    //we have set begin to -600 and end to 0, it will provide the value for
    //left or right position for Positioned() widget to creat movement from left to right
    animation.addListener(() {
      setState(() {}); //update UI on every animation value update
    });

    animation2.addListener(() {
      setState(() {}); //update UI on every animation value update
    });
    animation3.addListener(() {
      setState(() {}); //update UI on every animation value update
    });
    animation4.addListener(() {
      setState(() {}); //update UI on every animation value update
    });

  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose(); //destory anmiation to free memory on last
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanUpdate: (dis) {
          if (dis.delta.dx < 0) {
            //User swiped from left to right
            //pass
          } else if(dis.delta.dy<0){
            AudioManager.instance.addRandomSong2(context);
          }
        },
        child: Scaffold(
            body: SafeArea(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 0.0),
                            child: ExpansionTileCard(
                              expandedColor: Colors.black12,
                              shadowColor: Colors.transparent,
                              elevation: 0.0,
                              title: Row(children: <Widget>[
                                Container(
                                  transform:
                                      Matrix4.translationValues(-16.0, 0, 0),
                                  child: IconButton(
                                      icon: Icon(Icons.arrow_back_rounded),
                                      onPressed: () {
                                        Navigator.of(context).popUntil((route) => route.isFirst);
                                      }),
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 4.0),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.horizontal(
                                                left: Radius.circular(10.0),
                                              ),
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 1,
                                              )),
                                          child: DropDownDemo(
                                              hint: "연도", items: _yearValues),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.horizontal(
                                                right: Radius.circular(10.0),
                                              ),
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 1,
                                              )),
                                          child: DropDownDemo(
                                            hint: "장르",
                                            items: _genreValues,
                                          ),
                                        ),
                                      ],
                                    ))
                              ]),
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        4.0, 4.0, 4.0, 24.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: emotionButton("happy",
                                              "assets/itd/ITD_icon_happy.svg"),
                                        ),
                                        Expanded(
                                          child: emotionButton("angry",
                                              "assets/itd/ITD_icon_angry.svg"),
                                        ),
                                        Expanded(
                                          child: emotionButton("calm",
                                              "assets/itd/ITD_icon_calm.svg"),
                                        ),
                                        Expanded(
                                          child: emotionButton("sad",
                                              "assets/itd/ITD_icon_blue.svg"),
                                        ),
                                        Expanded(
                                          child: emotionButton("fear",
                                              "assets/itd/ITD_icon_fear.svg"),
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                            child:
                            StreamBuilder<SequenceState>(
                              stream: AudioManager.instance.player.sequenceStateStream,
                              builder: (context, snapshot) {
                                final state = snapshot.data;
                                if (state.sequence.isEmpty ?? true) return Text(
                                  "재생 중인 곡이 없습니다. 위로 스와이프해주세요",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20, foreground: Paint()..strokeWidth = 2
                                  // fontWeight: FontWeight.bold
                                ),
                                );
                                final metadata = state.currentSource.tag as AudioMetadata;
                                return Text(
                                  metadata.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20, foreground: Paint()..strokeWidth = 2
                                  // fontWeight: FontWeight.bold
                                ),
                                );
                              },


                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4.0, bottom: 8.0),
                            child:
                            StreamBuilder<SequenceState>(
                              stream: AudioManager.instance.player.sequenceStateStream,
                              builder: (context, snapshot) {
                                final state = snapshot.data;
                                if (state.sequence.isEmpty ?? true) return Text(
                                  "재생 중인 곡이 없습니다. 위로 스와이프해주세요",
                                  textAlign: TextAlign.center,
                                  style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                                );
                                final metadata = state.currentSource.tag as AudioMetadata;
                                return Text(
                                  metadata.artist,
                                  textAlign: TextAlign.center,
                                  style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                                );
                              },


                            ),
                          ),
                          // Padding( //TODO: 태그 보여줌
                          //   padding: EdgeInsets.only(top: 2.0, bottom: 8.0),
                          //   child:
                          //   StreamBuilder<SequenceState>(
                          //     stream: AudioManager.instance.player.sequenceStateStream,
                          //     builder: (context, snapshot) {
                          //       final state = snapshot.data;
                          //       if (state.sequence.isEmpty ?? true) return Text(
                          //         "재생 중인 곡이 없습니다. 위로 스와이프해주세요",
                          //         textAlign: TextAlign.center,
                          //         style:
                          //         TextStyle(fontSize: 14, color: Colors.grey),
                          //       );
                          //       final metadata = state.currentSource.tag as AudioMetadata;
                          //       return Text(
                          //         metadata.getTags(),
                          //         textAlign: TextAlign.center,
                          //         style:
                          //         TextStyle(fontSize: 16, color: Colors.grey),
                          //       );
                          //     },
                          //
                          //
                          //   ),
                          // ),
                          Expanded(
                              child: Container(
                            // color: Colors.yellow,
                            // decoration: new BoxDecoration(//TODO
                            //     shape: BoxShape.circle, color: Colors.black12
                            //     //
                            //     // image: new DecorationImage(
                            //     //     fit: BoxFit.fill,
                            //     //     image: new NetworkImage(
                            //     //         "https://i.imgur.com/BoN9kdC.png")
                            //     // )
                            //     ),
                            child:                             StreamBuilder<SequenceState>(
                              stream: AudioManager.instance.player.sequenceStateStream,
                              builder: (context, snapshot) {
                                final state = snapshot.data;
                                if (state.sequence.isEmpty ?? true) return Text(
                                  "재생 중인 곡이 없습니다. 위로 스와이프해주세요",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20, foreground: Paint()..strokeWidth = 2
                                    // fontWeight: FontWeight.bold
                                  ),
                                );
                                final metadata = state.currentSource.tag as AudioMetadata;
                                final emotions = metadata.emotions;
                                int random = Random().nextInt(emotions.length);
                                final randomEmotion = emotions[random];
                                var pickColor = Colors.black;
                                if(randomEmotion == 'happy'){
                                  pickColor = const Color(0xFFFBC600);
                                }else if(randomEmotion == 'sad'){
                                  pickColor = const Color(0xFF00A0E9);
                                }else if(randomEmotion == 'angry'){
                                  pickColor = const Color(0xFFEA5966);
                                }else if(randomEmotion == 'calm'){
                                  pickColor = const Color(0xFF298966);
                                }else if(randomEmotion =='fear'){
                                  pickColor = const Color(0xFF68579A);
                                }
                                return Stack(
                                  children: [
                                    Center(
                                        child: Image.network(metadata.artwork)),
                                    Positioned(
                                        bottom: -10,
                                        right: animation.value,
                                        child: ClipPath(
                                          clipper: MyWaveClipper(),
                                          child: Opacity(
                                            opacity: 0.4,
                                            child: Container(
                                              color: pickColor,
                                              width: 900,
                                              height: 200,
                                            ),
                                          ),
                                        )),

                                    Positioned(
                                        bottom: 20,
                                        right: animation.value,
                                        child: ClipPath(
                                          clipper: MyWaveClipper(),
                                          child: Opacity(
                                            opacity: 0.2,
                                            child: Container(
                                              color: pickColor,
                                              width: 900,
                                              height: 200,
                                            ),
                                          ),
                                        )),

                                        Positioned(
                                        bottom: 20,
                                        right: animation4.value,
                                        child: ClipPath(
                                          clipper: MyWaveClipper(),
                                          child: Opacity(
                                            opacity: 0.1,
                                            child: Container(
                                              color: pickColor,
                                              width: 900,
                                              height: 200,
                                            ),
                                          ),
                                        )),

                                    Positioned(
                                      //helps to position widget where ever we want
                                      bottom: -40,
                                      //position at the bottom
                                      left: animation2.value,
                                      //value of left from animation controller
                                      child: ClipPath(
                                        clipper: MyWaveClipper(),
                                        //applying our custom clipper
                                        child: Opacity(
                                          opacity: 0.5,
                                          child: Container(
                                            color: pickColor,
                                            width: 900,
                                            height: 200,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      //helps to position widget where ever we want
                                      bottom: -55,
                                      //position at the bottom
                                      left: animation2.value,
                                      //value of left from animation controller
                                      child: ClipPath(
                                        clipper: MyWaveClipper(),
                                        //applying our custom clipper
                                        child: Opacity(
                                          opacity: 0.7,
                                          child: Container(
                                            color: pickColor,
                                            width: 900,
                                            height: 200,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Positioned(
                                      //helps to position widget where ever we want
                                      bottom: -100,
                                      //position at the bottom
                                      right: animation3.value,
                                      //value of left from animation controller
                                      child: ClipPath(
                                        clipper: MyWaveClipper(),
                                        //applying our custom clipper
                                        child: Opacity(
                                          opacity: 1,
                                          child: Container(
                                            color: Colors.white,
                                            width: 900,
                                            height: 200,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Positioned(
                                      //helps to position widget where ever we want
                                      bottom: -120,
                                      //position at the bottom
                                      right: animation3.value,
                                      //value of left from animation controller
                                      child: ClipPath(
                                        clipper: MyWaveClipper(),
                                        //applying our custom clipper
                                        child: Opacity(
                                          opacity: 1,
                                          child: Container(
                                            color: pickColor,
                                            width: 900,
                                            height: 200,
                                          ),
                                        ),
                                      ),
                                    ),

                                    Positioned(
                                      //helps to position widget where ever we want
                                      bottom: -128,
                                      //position at the bottom
                                      right: animation3.value,
                                      //value of left from animation controller
                                      child: ClipPath(
                                        clipper: MyWaveClipper(),
                                        //applying our custom clipper
                                        child: Opacity(
                                          opacity: 1,
                                          child: Container(
                                            color: Colors.white,
                                            width: 900,
                                            height: 200,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },


                            ),
                          )),
                          StreamBuilder<Duration>(
                            stream: AudioManager.instance.player.durationStream,
                            builder: (context, snapshot) {
                              final duration = snapshot.data ?? Duration.zero;
                              return StreamBuilder<PositionData>(
                                stream: Rx.combineLatest2<Duration, Duration, PositionData>(
                                    AudioManager.instance.player.positionStream,
                                    AudioManager.instance.player.bufferedPositionStream,
                                        (position, bufferedPosition) =>
                                        PositionData(position, bufferedPosition)),
                                builder: (context, snapshot) {
                                  final positionData = snapshot.data ??
                                      PositionData(Duration.zero, Duration.zero);
                                  var position = positionData.position;
                                  if (position > duration) {
                                    position = duration;
                                  }
                                  var bufferedPosition = positionData.bufferedPosition;
                                  if (bufferedPosition > duration) {
                                    bufferedPosition = duration;
                                  }
                                  return SeekBar(
                                    duration: duration,
                                    position: position,
                                    bufferedPosition: bufferedPosition,
                                    onChangeEnd: (newPosition) {
                                      AudioManager.instance.player.seek(newPosition);
                                    },
                                    emotionColor: Colors.black,
                                  );
                                },
                              );
                            },
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Text(
                                "02:34",
                                textAlign: TextAlign.left,
                              )),
                              Expanded(
                                child: Text(
                                  "5:55",
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 48.0),
                                  child: PlayerController(
                                    prevIconName: 'player_prev',
                                    playIconName: 'player_play',
                                    nextIconName: 'player_next',
                                    previousSize: 36.0,
                                    playSize: 72.0,
                                    nextSize: 36.0,
                                  ))),
                        ])))));
  }

  Widget emotionButton(String emotion, String svgicon) {
    return GestureDetector(
      onTap: () => setState(() => AudioManager.emotion = emotion),
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 25,
              width: 25,
              child: SvgPicture.asset(
                svgicon,
              ),
            ),
          ],
        ),
        height: 64.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AudioManager.emotion == emotion ? Colors.grey : Colors.black12,
        ),
      ),
    );
  }
}
