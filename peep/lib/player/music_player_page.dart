import 'dart:math';

import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:peep/player/ui/animated_wave.dart';
import 'package:peep/player/ui/seekbar.dart';
import '../globals.dart';
import 'audio_manager.dart';
import 'model/audio_metadata.dart';
import 'model/position_data.dart';
import 'ui/dropdown_demo.dart';
import 'player_controller.dart';

class MusicPlayerPage extends StatefulWidget {
  @override
  _MusicPlayerPageState createState() => new _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage>
    with TickerProviderStateMixin {
  final List<String> _yearValues = ['모든 연도', '2020', '2010', '2000', '1990'];
  final List<String> _genreValues = ['모든 장르', '댄스', '발라드', '랩∙힙합', '록∙메탈'];

  bool _isExpanding = false;

  Animation<double> _animation;
  Animation<double> _animation2;
  Animation<double> _animation3;
  Animation<double> _animation4;

  AnimationController _controller;

  AudioMetadata _songMeta;
  String playingEmotion = "default";

  @override
  Widget build(BuildContext topContext) {
    return Scaffold(
        body: StreamBuilder<SequenceState>(
            stream: AudioManager.instance.player.sequenceStateStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final playingData = snapshot.data;
                _songMeta = playingData.currentSource.tag as AudioMetadata;
                final playingEmotions = _songMeta.emotions;
                int rand = Random().nextInt(_songMeta.emotions.length);
                playingEmotion = playingEmotions[rand];
              }
              return Container(
                  color: EmotionColor.getNormalColorFor(playingEmotion),
                  child: SafeArea(
                      bottom: false,
                      child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisSize: MainAxisSize.max,
                          children: [
                            /// Back button, year, genre, emotion in [ExpansionTileCard]
                            ExpansionTileCard(
                              baseColor: Colors.transparent,
                              expandedColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              elevation: 0.0,
                              onExpansionChanged: (val) => setState(() {
                                _isExpanding = val;
                              }),
                              title: _isExpanding
                                  ? Row(children: [
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          child: Row(
                                            children: [
                                              /// year
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.horizontal(
                                                      left:
                                                          Radius.circular(10.0),
                                                    ),
                                                    border: Border.all(
                                                      color: Colors.black,
                                                      width: 1,
                                                    )),
                                                child: DropDownDemo(
                                                  hint: "연도",
                                                  items: _yearValues,
                                                  backgroundColor: EmotionColor
                                                      .getLightColorFor(
                                                          playingEmotion),
                                                ),
                                              ),

                                              /// genre
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.horizontal(
                                                      right:
                                                          Radius.circular(10.0),
                                                    ),
                                                    border: Border.all(
                                                      color: Colors.black,
                                                      width: 1,
                                                    )),
                                                child: DropDownDemo(
                                                  hint: "장르",
                                                  items: _genreValues,
                                                  backgroundColor: EmotionColor
                                                      .getLightColorFor(
                                                          playingEmotion),
                                                ),
                                              ),
                                            ],
                                          ))
                                    ])
                                  : SizedBox(width: 0.0),
                              children: [
                                /// emotion button
                                Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: draggableEmotion("happy",
                                              "assets/itd/ITD_icon_happy.svg"),
                                        ),
                                        Expanded(
                                          child: draggableEmotion("angry",
                                              "assets/itd/ITD_icon_angry.svg"),
                                        ),
                                        Expanded(
                                          child: draggableEmotion("calm",
                                              "assets/itd/ITD_icon_calm.svg"),
                                        ),
                                        Expanded(
                                          child: draggableEmotion("blue",
                                              "assets/itd/ITD_icon_blue.svg"),
                                        ),
                                        Expanded(
                                          child: draggableEmotion("fear",
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
                                    (_songMeta == null ||
                                            _songMeta.title == null)
                                        ? "재생 중인 곡이 없습니다"
                                        : _songMeta.title,
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
                                    (_songMeta == null ||
                                            _songMeta.artist == null)
                                        ? "감정 선택 후 재생을 눌러보세요"
                                        : _songMeta.artist,
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
                                        /// down to up
                                      } else if (dis.delta.dy > 0) {
                                        /// up to down
                                        // Navigator.of(context).pop();
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
                                      }
                                    },
                                    onDoubleTap: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text("좋아요 기능 예정")));
                                    },
                                    child: DragTarget<String>(
                                      builder: (context, candidateItems,
                                          rejectedItems) {
                                        return Stack(children: [
                                          /// artwork
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 32.0,
                                                vertical: 16.0),
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
                                              (_songMeta == null ||
                                                      _songMeta.artwork == null)
                                                  ? 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'
                                                  : _songMeta.artwork,
                                              width: 480,
                                              fit: BoxFit.contain,
                                            ),
                                          ),

                                          /// waves
                                          AnimatedWave(
                                            animation: _animation,
                                            bottom: 10,
                                            opacity: 0.35,
                                            color: EmotionColor.getDarkColorFor(
                                                playingEmotion),
                                            isLeftToRight: true,
                                          ),
                                          AnimatedWave(
                                            animation: _animation4,
                                            bottom: 10,
                                            opacity: 0.5,
                                            color: EmotionColor.getDarkColorFor(
                                                playingEmotion),
                                            isLeftToRight: true,
                                          ),
                                          AnimatedWave(
                                            animation: _animation4,
                                            bottom: -16,
                                            opacity: 0.7,
                                            color: EmotionColor.getDarkColorFor(
                                                playingEmotion),
                                            isLeftToRight: true,
                                          ),
                                          AnimatedWave(
                                            animation: _animation3,
                                            bottom: -42,
                                            opacity: 0.6,
                                            color: EmotionColor.getDarkColorFor(
                                                playingEmotion),
                                            isLeftToRight: false,
                                          ),
                                          AnimatedWave(
                                            animation: _animation3,
                                            bottom: -55,
                                            opacity: 0.7,
                                            color:
                                                EmotionColor.getLightColorFor(
                                                    playingEmotion),
                                            isLeftToRight: false,
                                          ),
                                          AnimatedWave(
                                            animation: _animation2,
                                            bottom: -100,
                                            opacity: 1,
                                            color: Colors.white,
                                            isLeftToRight: true,
                                          )
                                        ]);
                                      },
                                      onAccept: (emotion) {
                                        AudioManager.emotion = emotion;
                                        try {
                                          AudioManager.instance.addSong(
                                              RecommendationType.RANDOM_TAG);
                                        } on NoFoundSearchResultException catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                              content: Text(e.toString())));
                                        }
                                      },
                                    ))),

                            /// favorite button, SeekBar, player controller in [Container]
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
                                              padding:
                                                  EdgeInsets.only(right: 4.0),
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
                                          Text(
                                              "${_songMeta?.favorite ?? "좋아요 정보가 없어요"}"),
                                        ])),

                                    /// SeekBar
                                    StreamBuilder<PositionData>(
                                      stream: AudioManager
                                          .instance.positionDataStream,
                                      builder: (context, snapshot) {
                                        final positionData = snapshot.data;
                                        return SeekBar(
                                          duration: positionData?.duration ??
                                              Duration.zero,
                                          position: positionData?.position ??
                                              Duration.zero,
                                          bufferedPosition:
                                              positionData?.bufferedPosition ??
                                                  Duration.zero,
                                          onChangeEnd: (newPosition) {
                                            AudioManager.instance.player
                                                .seek(newPosition);
                                          },
                                          emotionColor:
                                              EmotionColor.getLightColorFor(
                                                  playingEmotion),
                                        );
                                      },
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
    _controller =
        AnimationController(duration: Duration(seconds: 10), vsync: this);
    _controller.repeat(reverse: true);

    //[begin]: -600 ~ 0
    _animation = Tween<double>(begin: -255, end: 0).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
        reverseCurve: Curves.linear));
    _animation2 = Tween<double>(begin: -200, end: 0).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
        reverseCurve: Curves.linear));
    _animation3 = Tween<double>(begin: -300, end: 0).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
        reverseCurve: Curves.linear));
    _animation4 = Tween<double>(begin: -400, end: 0).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
        reverseCurve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget draggableEmotion(String emotion, String svgIcon) {
    return LongPressDraggable(
      data: emotion,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: DraggingItem(
        emotion: emotion,
        svgIcon: svgIcon,
      ),
      child: Container(
        child: Column(
          children: [
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
      ),
    );
  }
}

class DraggingItem extends StatelessWidget {
  const DraggingItem({
    Key key,
    this.emotion,
    this.svgIcon,
  }) : super(key: key);

  final String emotion;
  final String svgIcon;

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: const Offset(-0.5, -0.5),
      child: Container(
        child: Column(
          children: [
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
        width: 64.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (emotion == "happy" || emotion == "fear")
                ? EmotionColor.getLightColorFor(emotion).withOpacity(0.7)
                : EmotionColor.getDarkColorFor(emotion).withOpacity(0.5)),
      ),
    );
  }
}
