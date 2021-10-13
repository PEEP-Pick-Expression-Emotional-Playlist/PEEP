import 'dart:math';

import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:peep/player/ui/animated_wave.dart';
import 'package:peep/player/ui/seekbar.dart';
import '../globals.dart';
import 'ui/dropdown_demo.dart';
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

  AudioMetadata songMeta;
  String playingEmotion = "default";

  @override
  Widget build(BuildContext topContext) {
    return Scaffold(
        body: StreamBuilder<SequenceState>(
            stream: AudioManager.instance.player.sequenceStateStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final playingData = snapshot.data;
                songMeta = playingData.currentSource.tag as AudioMetadata;
                final playingEmotions = songMeta.emotions;
                int rand = Random().nextInt(songMeta.emotions.length);
                playingEmotion = playingEmotions[rand];
              }
              return Container(
                  color: EmotionColor.getNormalColorFor(playingEmotion),
                  child: SafeArea(
                      bottom: false,
                      child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            /// Back button, year, genre, emotion in [ExpansionTileCard]
                            ExpansionTileCard(
                              baseColor: Colors.transparent,
                              expandedColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              elevation: 0.0,
                              title: Row(children: <Widget>[
                                /// Back button
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
                                        /// year
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

                                        /// genre
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
                                /// emotion button
                                Padding(
                                    padding: EdgeInsets.all(4.0),
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

                            /// Playing song's title, artist in [Padding]
                            Padding(
                                padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                                child: Column(children: [
                                  /// title
                                  Text(
                                    songMeta.title,
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

                                  /// artist
                                  Text(
                                    songMeta.artist,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black54),
                                  )
                                ])),

                            /// gesture, artwork and waves in [Expanded]
                            Expanded(

                                /// gesture
                                child: GestureDetector(
                                    onPanUpdate: (dis) {
                                      if (dis.delta.dx < 0) {
                                        //User swiped from left to right
                                        //pass
                                      } else if (dis.delta.dy < 0) {
                                        AudioManager.instance
                                            .addRandomSong2(context);
                                      }
                                    },
                                    child: Stack(children: [
                                      /// artwork
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 32.0, vertical: 16.0),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black45,
                                              spreadRadius: 1,
                                              blurRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: Image.network(
                                          songMeta.artwork,
                                          width: 480,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),

                                      /// waves
                                      AnimatedWave(
                                        animation: animation,
                                        bottom: 10,
                                        opacity: 0.35,
                                        color: EmotionColor.getDarkColorFor(
                                            playingEmotion),
                                        isLeftToRight: true,
                                      ),
                                      AnimatedWave(
                                        animation: animation4,
                                        bottom: 10,
                                        opacity: 0.5,
                                        color: EmotionColor.getDarkColorFor(
                                            playingEmotion),
                                        isLeftToRight: true,
                                      ),
                                      AnimatedWave(
                                        animation: animation4,
                                        bottom: -16,
                                        opacity: 0.7,
                                        color: EmotionColor.getDarkColorFor(
                                            playingEmotion),
                                        isLeftToRight: true,
                                      ),
                                      AnimatedWave(
                                        animation: animation3,
                                        bottom: -42,
                                        opacity: 0.6,
                                        color: EmotionColor.getDarkColorFor(
                                            playingEmotion),
                                        isLeftToRight: false,
                                      ),
                                      AnimatedWave(
                                        animation: animation3,
                                        bottom: -55,
                                        opacity: 0.7,
                                        color: EmotionColor.getLightColorFor(
                                            playingEmotion),
                                        isLeftToRight: false,
                                      ),
                                      AnimatedWave(
                                        animation: animation2,
                                        bottom: -100,
                                        opacity: 1,
                                        color: Colors.white,
                                        isLeftToRight: true,
                                      )
                                    ]))),

                            /// SeekBar, playing time, player controller in [Container]
                            Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    /// favorite button
                                    Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Row(children: [
                                          IconButton(
                                              padding: EdgeInsets.only(right:4.0),
                                              constraints: BoxConstraints(),
                                              onPressed: () {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: const Text(
                                                        'Favorite button clicked'),
                                                  ),
                                                );
                                              },
                                              icon: Icon(
                                                Icons.favorite,
                                                color: Colors.pinkAccent,
                                                size: 24.0,
                                              )),
                                          // TODO : 총 좋아요 수를 곡 정보에서 가져오기
                                          Text("777"),
                                        ])),

                                    /// SeekBar
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

                                    /// playing time
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

                                    /// player controller
                                    Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                84.0, 8.0, 84.0, 48.0),
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
                          ])));
            }));
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 10), vsync: this);
    controller.repeat(reverse: true);

    //[begin]: -600 ~ 0
    animation = Tween<double>(begin: -255, end: 0).animate(CurvedAnimation(
        parent: controller, curve: Curves.linear, reverseCurve: Curves.linear));
    animation2 = Tween<double>(begin: -200, end: 0).animate(CurvedAnimation(
        parent: controller, curve: Curves.linear, reverseCurve: Curves.linear));
    animation3 = Tween<double>(begin: -300, end: 0).animate(CurvedAnimation(
        parent: controller, curve: Curves.linear, reverseCurve: Curves.linear));
    animation4 = Tween<double>(begin: -400, end: 0).animate(CurvedAnimation(
        parent: controller, curve: Curves.linear, reverseCurve: Curves.linear));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
          color: AudioManager.emotion == emotion
              // ?Colors.white
              ? ((emotion == "angry" || emotion == "fear")
                  ? EmotionColor.getLightColorFor(emotion)
                  : EmotionColor.getDarkColorFor(emotion))
              : Colors.transparent,
        ),
      ),
    );
  }
}
