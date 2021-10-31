import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';

import 'audio_manager.dart';

class PlayerController extends StatefulWidget {
  const PlayerController({
    Key key,
    this.previousSize,
    this.playSize,
    this.nextSize,
    this.prevIconName,
    this.playIconName,
    this.nextIconName,
  }) : super(key: key);

  final double previousSize;
  final double playSize;
  final double nextSize;

  final String prevIconName;
  final String playIconName;
  final String nextIconName;

  @override
  State createState() => _PlayerController();
}

class _PlayerController extends State<PlayerController> {
  var _player = AudioManager.instance.player;
  AudioManager audioManager = AudioManager.instance;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        /// previous Button
        StreamBuilder<SequenceState>(
            stream: _player.sequenceStateStream,
            builder: (context, snapshot) =>
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: SvgPicture.asset(
                    'assets/icons/' + widget.prevIconName + '.svg',
                    fit: BoxFit.contain,
                  ),
                  iconSize: widget.previousSize,
                  onPressed: _player.hasPrevious ? _player.seekToPrevious : null,

                  //     (){
                  //   audioManager.prev(context);
                  // }
                )),
        /// Play Button
        StreamBuilder<PlayerState>(
          stream: _player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            var processingState = playerState?.processingState;
            final playing = playerState?.playing;
            //로딩중일때
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                width: widget.playSize,
                height: widget.playSize,
                child: CircularProgressIndicator(),
              );
            } else if (playing != true) { //재생중이 아닐때 재생할 수 있는 버튼
              return IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: SvgPicture.asset(
                  'assets/icons/' + widget.playIconName + '.svg',
                  fit: BoxFit.scaleDown,
                ),
                iconSize: widget.playSize,
                // onPressed: () => search(query)
                // _player.play,
                onPressed: () { //재생하는 버튼 눌렀을 때
                  // ScaffoldMessenger.of(context)
                  //     .showSnackBar(SnackBar(content: Text('Wait a minute')));

                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar( //선택된 감정과 연도를 보여줌
                  //     content: Text(AudioManager.emotion +
                  //         ' ' +
                  //         AudioManager.year)));

                  audioManager.play(context); //노래 재생하는 함수
                  // if (_player.sequence == null || _player.sequence.isEmpty)
                  //   {
                  //     // search(query)
                  //
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //         SnackBar(content: Text('재생할 수 있는 노래가 존재하지 않습니다')))
                  //   }
                  // else
                  //   {audioManager.play(context)}
                },
              );
            } else if (processingState != ProcessingState.completed) { //재생중일때
              return IconButton( //멈춤아이콘
                icon: Icon(Icons.pause),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                iconSize: widget.playSize,
                onPressed: () {
                  _player.pause();
                },
              );
            } else {
              return IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: SvgPicture.asset(
                  'assets/icons/' + widget.playIconName + '.svg',
                  fit: BoxFit.scaleDown,
                ),
                iconSize: widget.playSize,
                onPressed: () { //재생하는 버튼 눌렀을 때
                  audioManager.play(context); //노래 재생하는 함수
                },
              );
            }
          },
        ),
        //다음곡(패스) 버튼
        StreamBuilder<SequenceState>(
            stream: _player.sequenceStateStream,
            builder: (context, snapshot) =>
                IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: SvgPicture.asset(
                        'assets/icons/' + widget.nextIconName + '.svg'),
                    iconSize: widget.nextSize,
                    onPressed: _player.hasNext ? _player.seekToNext : null,
                    // audioManager.pass(context)

                )),
        //패스 버튼 눌렸을 때
      ],

    );
  }
}

class BufferAudioSource extends StreamAudioSource { //이 클래스는 무시하세요
  Uint8List _buffer;

  BufferAudioSource(this._buffer) : super("Bla");

  @override
  Future<StreamAudioResponse> request([int start, int end]) {
    start = start ?? 0;
    end = end ?? _buffer.length;

    return Future.value(
      StreamAudioResponse(
        sourceLength: _buffer.length,
        contentLength: end - start,
        offset: start,
        contentType: 'audio/mpeg',
        stream:
        Stream.value(List<int>.from(_buffer.skip(start).take(end - start))),
      ),
    );
  }
}



