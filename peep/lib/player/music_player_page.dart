import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:just_audio/just_audio.dart';
import 'package:peep/login/user_manager.dart';
import 'package:peep/player/ui/animated_wave.dart';
import 'package:peep/player/ui/draggable_emotion.dart';
import 'package:peep/player/ui/seekbar.dart';
import 'package:peep/player/ui/two_sticky_border_dropdown.dart';
import '../db_manager.dart';
import '../globals.dart';
import 'audio_manager.dart';
import 'model/audio_metadata.dart';
import 'model/position_data.dart';
import 'player_controller.dart';

class MusicPlayerPage extends StatefulWidget {
  @override
  _MusicPlayerPageState createState() => new _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage>
    with TickerProviderStateMixin {
  final List<String> _yearValues = ['모든 연도', '2020', '2010', '2000', '1990'];
  final List<String> _genreValues = ['모든 장르', '댄스', '발라드', '랩∙힙합', '록∙메탈'];

  final Map<String, String> _emotionIcons = {
    "happy": "assets/itd/ITD_icon_happy.svg",
    "angry": "assets/itd/ITD_icon_angry.svg",
    "calm": "assets/itd/ITD_icon_calm.svg",
    "blue": "assets/itd/ITD_icon_blue.svg",
    "fear": "assets/itd/ITD_icon_fear.svg"
  };

  bool _isExpanding = false;

  List<Animation<double>> _animations = [];
  AnimationController _controller;

  AudioMetadata _songMeta;
  String playingEmotion = "default";

  final userFavoriteRef = DBManager.instance.ref
      .child("favorite")
      .child(UserManager.instance.user.uid);

  final songsFavoriteRef = DBManager.instance.ref.child("songs");

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
                  child: SafeArea(bottom: false, child: _musicPlayerContent()));
            }));
  }

  Widget _musicPlayerContent() {
    return Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.max,
        children: [
          /// year, genre, emotion in [ExpansionTileCard]
          ExpansionTileCard(
            baseColor: Colors.transparent,
            expandedColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0.0,
            onExpansionChanged: (val) => setState(() {
              _isExpanding = val;
            }),

            /// year, genre
            title: _isExpanding
                ? TwoStickyBorderDropdown(
                    leftHint: "장르",
                    leftItem: _genreValues,
                    rightHint: "연도",
                    rightItem: _yearValues,
                    backgroundColor:
                        EmotionColor.getLightColorFor(playingEmotion),
                    leftOnChanged: (String val) {
                      setState(() {
                      AudioManager.genre = val;
                      });
                    },
                    rightOnChanged: (String val) {
                      setState(() {
                      AudioManager.year = val;
                      });
                    },
                  )
                : SizedBox(width: 0.0),
            children: [
              /// emotion button
              Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Row(
                    children: _emotionIcons.entries
                        .map((entry) => DraggableEmotion(
                            emotion: entry.key, svgIcon: entry.value))
                        .toList(),
                  ))
            ],
          ),

          /// Playing song's title, artist in [Padding]
          Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
              child: Column(children: [
                /// title
                Text(
                  (_songMeta == null || _songMeta.title == null)
                      ? "재생 중인 곡이 없습니다"
                      : _songMeta.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20, foreground: Paint()..strokeWidth = 2
                      // fontWeight: FontWeight.bold
                      ),
                ),
                SizedBox(
                  height: 8,
                ),

                /// artist
                Text(
                  (_songMeta == null || _songMeta.artist == null)
                      ? "감정 선택 후 재생을 눌러보세요"
                      : _songMeta.artist,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
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
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  },

                  // TODO 2: SEARCH USING GENRE AND YEAR
                  onDoubleTap: () => _favoriteHandling()
                  ,
                  child: DragTarget<String>(
                    builder: (context, candidateItems, rejectedItems) {
                      return Stack(children: [
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
                            (_songMeta == null || _songMeta.artwork == null)
                                ? 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'
                                : _songMeta.artwork,
                            width: 480,
                            fit: BoxFit.contain,
                          ),
                        ),

                        /// waves
                        AnimatedWave(
                          animation: _animations[0],
                          bottom: 10,
                          opacity: 0.35,
                          color: EmotionColor.getDarkColorFor(playingEmotion),
                          isLeftToRight: true,
                        ),
                        AnimatedWave(
                          animation: _animations[3],
                          bottom: 10,
                          opacity: 0.5,
                          color: EmotionColor.getDarkColorFor(playingEmotion),
                          isLeftToRight: true,
                        ),
                        AnimatedWave(
                          animation: _animations[3],
                          bottom: -16,
                          opacity: 0.7,
                          color: EmotionColor.getDarkColorFor(playingEmotion),
                          isLeftToRight: true,
                        ),
                        AnimatedWave(
                          animation: _animations[2],
                          bottom: -42,
                          opacity: 0.6,
                          color: EmotionColor.getDarkColorFor(playingEmotion),
                          isLeftToRight: false,
                        ),
                        AnimatedWave(
                          animation: _animations[2],
                          bottom: -55,
                          opacity: 0.7,
                          color: EmotionColor.getLightColorFor(playingEmotion),
                          isLeftToRight: false,
                        ),
                        AnimatedWave(
                          animation: _animations[1],
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
                        AudioManager.instance
                            .addSong(RecommendationType.RANDOM_TAG, context);
                      } on NoFoundSearchResultException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    },
                  ))),

          /// favorite info, SeekBar, player controller in [Container]
          Container(
              color: Colors.white,
              child: Column(
                children: [
                  /// favorite info
                  Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Row(children: [
                        Icon(
                          Icons.favorite_rounded,
                          color: Colors.pinkAccent,
                          size: 24.0,
                        ),
                        SizedBox(width: 4),
                        Text("${_songMeta?.favorite ?? "좋아요 정보가 없어요"}"),
                      ])),

                  /// SeekBar
                  StreamBuilder<PositionData>(
                    stream: AudioManager.instance.positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return SeekBar(
                        duration: _songMeta?.duration ?? Duration.zero,
                        position: positionData?.position ?? Duration.zero,
                        bufferedPosition:
                            positionData?.bufferedPosition ?? Duration.zero,
                        onChangeEnd: (newPosition) {
                          AudioManager.instance.player.seek(newPosition);
                        },
                        emotionColor:
                            EmotionColor.getLightColorFor(playingEmotion),
                      );
                    },
                  ),

                  /// player controller
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(84.0, 8.0, 84.0, 48.0),
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
        ]);
  }

  void _favoriteHandling() {
    // debugPrint(FirebaseAuth.instance.currentUser.uid);
    // debugPrint(UserManager.instance.user.uid);
    // debugPrint("keyyy" + _songMeta.key);
    userFavoriteRef.child(_songMeta.key).get().then((value) {
      // debugPrint("get " + value.value.toString());
      if (!value.exists) {
        userFavoriteRef.child(_songMeta.key).set(true).then((value) =>
            songsFavoriteRef
                .child(_songMeta.key)
                .child("favorite")
                .set(ServerValue.increment(1))
                .then((value)
            {ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("이 음악을 좋아합니다")));
            _updateFavoriteCount();
            }));
        // debugPrint("item " + _songMeta.key + " add");
        return true;
      } else {
        userFavoriteRef.child(_songMeta.key).remove().then((value) =>
            songsFavoriteRef
                .child(_songMeta.key)
                .child("favorite")
                .set(ServerValue.increment(-1))
                .then((value)
            {ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("이 음악을 좋아하지 않습니다")));
            _updateFavoriteCount();
            }));
        // debugPrint("item " + _songMeta.key + " removed");
        return false;
      }
    }).catchError((error, stackTrace) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("다시 시도해 주시기 바랍니다")));
    });
  }

  void _updateFavoriteCount(){
    songsFavoriteRef
        .child(_songMeta.key)
        .child("favorite")
        .get()
        .then((value) {
      setState(() {
        print(value.value.toString());
        _songMeta.favorite = value.value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 10), vsync: this);
    _controller.repeat(reverse: true);

    final CurvedAnimation curvedAnimation = CurvedAnimation(
        parent: _controller, curve: Curves.linear, reverseCurve: Curves.linear);

    //[begin]: -600 ~ 0
    _animations.addAll([
      Tween<double>(begin: -255, end: 0).animate(curvedAnimation),
      Tween<double>(begin: -200, end: 0).animate(curvedAnimation),
      Tween<double>(begin: -300, end: 0).animate(curvedAnimation),
      Tween<double>(begin: -400, end: 0).animate(curvedAnimation)
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
