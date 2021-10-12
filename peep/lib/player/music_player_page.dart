import 'dart:math';

import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:peep/player/ui/seekbar.dart';
import '../globals.dart';
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

  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 10), vsync: this);
    controller.repeat(reverse: true);

    animation = Tween<double>(begin: -255, end: 0).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
        reverseCurve: Curves.linear));
    animation2 = Tween<double>(begin: -200, end: 0).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
        reverseCurve: Curves.linear));
    animation3 = Tween<double>(begin: -300, end: 0).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
        reverseCurve: Curves.linear));
    animation4 = Tween<double>(begin: -400, end: 0).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
        reverseCurve: Curves.linear));
    //we have set begin to -600 and end to 0, it will provide the value for
    //left or right position for Positioned() widget to creat movement from left to right
    // animation.addListener(() {
    //   setState(() {}); //update UI on every animation value update
    // });
    //
    // animation2.addListener(() {
    //   setState(() {}); //update UI on every animation value update
    // });
    // animation3.addListener(() {
    //   setState(() {}); //update UI on every animation value update
    // });
    // animation4.addListener(() {
    //   setState(() {}); //update UI on every animation value update
    // });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose(); //destory anmiation to free memory on last
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanUpdate: (dis) {
          if (dis.delta.dx < 0) {
            //User swiped from left to right
            //pass
          } else if (dis.delta.dy < 0) {
            AudioManager.instance.addRandomSong2(context);
          }
        },
        child: StreamBuilder<SequenceState>(
            stream: AudioManager.instance.player.sequenceStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              var playingEmotion;
              // var playingEmotion = CurrentEmotion.of(context).emotion; // default value
              // TODO: 아무 곡이 없을 때(`state==null`) 처리
              if (state == null ||
                      state.sequence == null ||
                      state.sequence.isEmpty ??
                  true) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                  "재생 중인 곡이 없습니다. 위로 스와이프해주세요",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20, foreground: Paint()..strokeWidth = 2
                      // fontWeight: FontWeight.bold
                      ),
                )));
              } else {
                final metad = state.currentSource.tag as AudioMetadata;
                final emotion1 = metad.emotions;
                int rand = Random().nextInt(emotion1.length);
                playingEmotion = emotion1[rand];
                if (playingEmotion == null || playingEmotion == "") {
                  playingEmotion = "default";
                }
              }
              return Scaffold(
                  body: Container(
                      color: EmotionColor.getNormalColorFor(playingEmotion),
                      child: SafeArea(
                          child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                            ExpansionTileCard(
                              baseColor: EmotionColor.getNormalColorFor(
                                  playingEmotion),
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
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
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
                            Padding(
                              padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                              child: StreamBuilder<SequenceState>(
                                stream: AudioManager
                                    .instance.player.sequenceStateStream,
                                builder: (context, snapshot) {
                                  final state = snapshot.data;
                                  if (state.sequence.isEmpty ?? true)
                                    return Column(children: [
                                      Text(
                                        "재생 중인 곡이 없습니다",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20,
                                            foreground: Paint()..strokeWidth = 2
                                            // fontWeight: FontWeight.bold
                                            ),
                                      ),
                                      Text(
                                        "위로 스와이프해주세요",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      )
                                    ]);
                                  final metadata =
                                      state.currentSource.tag as AudioMetadata;
                                  return Column(children: [
                                    Text(
                                      metadata.title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          foreground: Paint()..strokeWidth = 2
                                          // fontWeight: FontWeight.bold
                                          ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      metadata.artist,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black54),
                                    )
                                  ]);
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
                              child: StreamBuilder<SequenceState>(
                                stream: AudioManager
                                    .instance.player.sequenceStateStream,
                                builder: (context, snapshot) {
                                  final state = snapshot.data;
                                  if (state.sequence.isEmpty ?? true)
                                    return Text(
                                      "재생 중인 곡이 없습니다. 위로 스와이프해주세요",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          foreground: Paint()..strokeWidth = 2
                                          // fontWeight: FontWeight.bold
                                          ),
                                    );
                                  final metadata =
                                      state.currentSource.tag as AudioMetadata;
                                  final emotions = metadata.emotions;
                                  int random =
                                      Random().nextInt(emotions.length);
                                  final randomEmotion = emotions[random];

                                  ///An artwork and waves in [Stack]
                                  return Stack(children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Image.network(
                                        metadata.artwork,
                                        width: 480,
                                        height: 480,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    AnimatedWave(
                                      animation: animation,
                                      bottom: 10,
                                      opacity: 0.35,
                                      color: EmotionColor.getDarkColorFor(randomEmotion),
                                    ),
                                    AnimatedWave(
                                      animation: animation4,
                                      bottom: 10,
                                      opacity: 0.5,
                                      color: EmotionColor.getDarkColorFor(randomEmotion),
                                    ),
                                    AnimatedWave(
                                      animation: animation4,
                                      bottom: -16,
                                      opacity: 0.7,
                                      color: EmotionColor.getDarkColorFor(randomEmotion),
                                    ),
                                    AnimatedWave(
                                      animation: animation3,
                                      bottom: -42,
                                      opacity: 0.6,
                                      color: EmotionColor.getDarkColorFor(randomEmotion),
                                    ),
                                    AnimatedWave(
                                      animation: animation3,
                                      bottom: -55,
                                      opacity: 0.7,
                                      color: EmotionColor.getLightColorFor(randomEmotion),
                                    ),
                                    AnimatedWave(
                                      animation: animation2,
                                      bottom: -100,
                                      opacity: 1,
                                      color: Colors.white,
                                    )
                                    // Positioned(
                                    //   bottom: 10,
                                    //   right: animation.value,
                                    //   child: ClipPath(
                                    //     clipper: MyWaveClipper(),
                                    //     child: Opacity(
                                    //       opacity: 0.35,
                                    //       child: Container(
                                    //         color: EmotionColor.getDarkColorFor(emotion),
                                    //         width: 900,
                                    //         height: 200,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    // Positioned(
                                    //     bottom: 10,
                                    //     right: animation4.value,
                                    //     child: ClipPath(
                                    //       clipper: MyWaveClipper(),
                                    //       child: Opacity(
                                    //         opacity: 0.5,
                                    //         child: Container(
                                    //           color: EmotionColor.getDarkColorFor(emotion),
                                    //           width: 900,
                                    //           height: 200,
                                    //         ),
                                    //       ),
                                    //     )),
                                    // Positioned(
                                    //     bottom: -16,
                                    //     right: animation4.value,
                                    //     child: ClipPath(
                                    //       clipper: MyWaveClipper(),
                                    //       child: Opacity(
                                    //         opacity: 0.7,
                                    //         child: Container(
                                    //           color: EmotionColor.getDarkColorFor(emotion),
                                    //           width: 900,
                                    //           height: 200,
                                    //         ),
                                    //       ),
                                    //     )),
                                    // Positioned(
                                    //   //helps to position widget where ever we want
                                    //   bottom: -42,
                                    //   //position at the bottom
                                    //   left: animation3.value,
                                    //   //value of left from animation controller
                                    //   child: ClipPath(
                                    //     clipper: MyWaveClipper(),
                                    //     //applying our custom clipper
                                    //     child: Opacity(
                                    //       opacity: 0.6,
                                    //       child: Container(
                                    //         color: EmotionColor.getDarkColorFor(emotion),
                                    //         width: 900,
                                    //         height: 200,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    // Positioned(
                                    //   //helps to position widget where ever we want
                                    //   bottom: -55,
                                    //   //position at the bottom
                                    //   left: animation3.value,
                                    //   //value of left from animation controller
                                    //   child: ClipPath(
                                    //     clipper: MyWaveClipper(),
                                    //     //applying our custom clipper
                                    //     child: Opacity(
                                    //       opacity: 0.7,
                                    //       child: Container(
                                    //         color: EmotionColor.getLightColorFor(emotion),
                                    //         width: 900,
                                    //         height: 200,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    // Positioned(
                                    //   //helps to position widget where ever we want
                                    //   bottom: -100,
                                    //   //position at the bottom
                                    //   right: animation2.value,
                                    //   //value of left from animation controller
                                    //   child: ClipPath(
                                    //     clipper: MyWaveClipper(),
                                    //     //applying our custom clipper
                                    //     child: Opacity(
                                    //       opacity: 1,
                                    //       child: Container(
                                    //         color: Colors.white,
                                    //         width: 900,
                                    //         height: 200,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ]);
                                },
                              ),
                            ),
                            Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    StreamBuilder<Duration>(
                                      stream: AudioManager
                                          .instance.player.durationStream,
                                      builder: (context, snapshot) {
                                        final duration =
                                            snapshot.data ?? Duration.zero;
                                        return StreamBuilder<PositionData>(
                                          stream: Rx.combineLatest2<Duration,
                                                  Duration, PositionData>(
                                              AudioManager.instance.player
                                                  .positionStream,
                                              AudioManager.instance.player
                                                  .bufferedPositionStream,
                                              (position, bufferedPosition) =>
                                                  PositionData(position,
                                                      bufferedPosition)),
                                          builder: (context, snapshot) {
                                            final positionData =
                                                snapshot.data ??
                                                    PositionData(Duration.zero,
                                                        Duration.zero);
                                            var position =
                                                positionData.position;
                                            if (position > duration) {
                                              position = duration;
                                            }
                                            var bufferedPosition =
                                                positionData.bufferedPosition;
                                            if (bufferedPosition > duration) {
                                              bufferedPosition = duration;
                                            }
                                            return SeekBar(
                                              duration: duration,
                                              position: position,
                                              bufferedPosition:
                                                  bufferedPosition,
                                              onChangeEnd: (newPosition) {
                                                AudioManager.instance.player
                                                    .seek(newPosition);
                                              },
                                              emotionColor: Colors.black,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Row(
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
                                    ),
                                    Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 16.0,
                                                horizontal: 96.0),
                                            child: PlayerController(
                                              prevIconName: 'player_prev',
                                              playIconName: 'player_play',
                                              nextIconName: 'player_next',
                                              previousSize: 36.0,
                                              playSize: 72.0,
                                              nextSize: 36.0,
                                            ))),
                                  ],
                                ))
                          ]))));
            }));
  }

  Widget emotionButton(String emotion, String svgIcon) {
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
                svgIcon,
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

class AnimatedWave extends AnimatedWidget {
  final Color color;
  final double opacity;
  final double bottom;

  const AnimatedWave({
    Key key,
    Animation<double> animation,
    this.bottom,
    this.opacity,
    this.color
  }): super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
  final animation = listenable as Animation<double>;
    return Positioned(
      bottom: bottom,
      right: animation.value,
      child: ClipPath(
        clipper: MyWaveClipper(),
        child: Opacity(
          opacity: opacity,
          child: Container(
            color: color,
            width: 900,
            height: 200,
          ),
        ),
      ),
    );
  }
}
