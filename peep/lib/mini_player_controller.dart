import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:page_transition/page_transition.dart';
import 'package:peep/globals.dart';
import 'package:peep/player/music_player_page.dart';
import 'package:peep/player/player_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peep/player/ui/seekbar.dart';
import 'package:rxdart/rxdart.dart';

class MiniPlayerController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MiniPlayerControllerState();
}

class MiniPlayerControllerState extends State<MiniPlayerController> {
  AudioMetadata songMeta;
  String playingEmotion = "default";

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
      child: StreamBuilder<SequenceState>(
          stream: AudioManager.instance.player.sequenceStateStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final playingData = snapshot.data;
              songMeta = playingData.currentSource.tag as AudioMetadata;
              final playingEmotions = songMeta.emotions;
              int rand = Random().nextInt(songMeta.emotions.length);
              playingEmotion = playingEmotions[rand];
            }
            return Column(mainAxisAlignment: MainAxisAlignment.end, children: <
                Widget>[
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
                      return LinearProgressIndicator(
                          value: position.inMilliseconds.toDouble(),
                          backgroundColor: Colors.black26,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              EmotionColor.getProcessColorFor(playingEmotion)));
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
                      EmotionColor.getBarColorFor(playingEmotion)
                    ],
                  )),
                  child: Row(
                    children: <Widget>[
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
                                (songMeta == null || songMeta.title == null)
                                    ? "재생 중인 곡이 없습니다"
                                    : songMeta.title),
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
                                          .showSnackBar(new SnackBar(
                                              content: Text(
                                                  'onPressed Playlist Button')));
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
