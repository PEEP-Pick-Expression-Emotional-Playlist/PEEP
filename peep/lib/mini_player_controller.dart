import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:page_transition/page_transition.dart';
import 'package:peep/globals.dart';
import 'package:peep/player/audio_manager.dart';
import 'package:peep/player/model/audio_metadata.dart';
import 'package:peep/player/model/position_data.dart';
import 'package:peep/player/music_player_page.dart';
import 'package:peep/player/player_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peep/player/playing_list_page.dart';

class MiniPlayerController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MiniPlayerControllerState();
}

class MiniPlayerControllerState extends State<MiniPlayerController> {
  AudioMetadata _songMeta;
  String _playingEmotion = "default";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<SequenceState>(
          stream: AudioManager.instance.player.sequenceStateStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final playingData = snapshot.data;
              _songMeta = playingData.currentSource.tag as AudioMetadata;
              final playingEmotions = _songMeta.emotions;
              int rand = Random().nextInt(_songMeta.emotions.length);
              _playingEmotion = playingEmotions[rand];
            }
            return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              StreamBuilder<Duration>(
                stream: AudioManager.instance.player.durationStream,
                builder: (context, snapshot) {
                  return StreamBuilder<PositionData>(
                    stream: AudioManager.instance.positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      final duration = _songMeta?.duration ?? Duration.zero;
                      final position = positionData?.position ?? Duration.zero;

                      return LinearProgressIndicator(
                          value: (position == Duration.zero &&
                                  duration == Duration.zero)
                              ? 0.0
                              : (position.inMilliseconds /
                                      duration.inMilliseconds)
                                  .toDouble(),
                          backgroundColor: Colors.black26,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              EmotionColor.getProcessColorFor(_playingEmotion)));
                    },
                  );
                },
              ),
              Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.5, 1],
                    colors: [
                      Colors.white,
                      EmotionColor.getBarColorFor(_playingEmotion)
                    ],
                  )),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 6,
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 16.0,
                                top: 16.0,
                                bottom: 16.0,
                                right: 8.0),
                            child: Text(
                                (_songMeta == null || _songMeta.title == null)
                                    ? "재생 중인 곡이 없습니다"
                                    : _songMeta.title),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.bottomToTop,
                                    child: MusicPlayerPage()));
                          },
                        ),
                      ),
                      Expanded(
                          flex: 4,
                          child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                  left: 8.0,
                                  top: 16.0,
                                  bottom: 16.0,
                                  right: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
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
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType.bottomToTop,
                                              child: NowPlayingPage()));
                                    },
                                  )
                                ],
                              ))),
                    ],
                  ))
            ]);
          }),
    );
  }
}
