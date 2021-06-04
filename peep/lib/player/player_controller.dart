import 'dart:io';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path/path.dart' as path;
import 'model/query_video.dart';

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
  final YoutubeExplode yt = YoutubeExplode();
  QueryVideo videoInfo;
  String query = "Beautiful Mistakes Maroon 5, Megan Thee Stallion";

  // @override
  // void initState() {
  //   super.initState();
  //
  // }
  //
  //
  //
  // @override
  // void dispose() {
  //   _player.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        StreamBuilder<SequenceState>(
            stream: _player.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: SvgPicture.asset(
                    'assets/icons/' + widget.prevIconName + '.svg',
                    fit: BoxFit.contain,
                  ),
                  iconSize: widget.previousSize,
                  onPressed:
                      _player.hasPrevious ? _player.seekToPrevious : null,
                )),
        StreamBuilder<PlayerState>(
          stream: _player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                width: widget.playSize,
                height: widget.playSize,
                child: CircularProgressIndicator(),
              );
            } else if (playing != true) {
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
                  onPressed: (_player.sequence==null ||_player.sequence.isEmpty)?()=>{
                    search(query)

                      // ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text('재생할 수 있는 노래가 존재하지 않습니다')))

                  }:_player.play
                  );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: Icon(Icons.pause),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                iconSize: widget.playSize,
                onPressed: _player.pause,
              );
            } else {
              return IconButton(
                icon: Icon(Icons.replay),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: () => _player.seek(Duration.zero,
                    index: _player.effectiveIndices.first),
              );
            }
          },
        ),
        StreamBuilder<SequenceState>(
            stream: _player.sequenceStateStream,
            builder: (context, snapshot) => IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: SvgPicture.asset(
                      'assets/icons/' + widget.nextIconName + '.svg'),
                  iconSize: widget.nextSize,
                  onPressed: _player.hasNext ? _player.seekToNext : null,
                )),
      ],
    );
  }

  Future<void> search(String query) async {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wait a minute')));

    var res_list =  await yt.search.getVideos(query);

    if (res_list == null || res_list.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No results were found for search')));
    } else {
      Video res = res_list.first;
      videoInfo = QueryVideo(res.title, res.id.value, res.duration);
    }

    await Permission.storage.request();

    var manifest = await yt.videos.streamsClient.getManifest(videoInfo.id);
    var streams = manifest.audioOnly.toList(growable: false);
    var audioInfo = streams.first;
    var audioStream = yt.videos.streamsClient.get(audioInfo);


    // Build the directory.
    Directory documents;
    if (Platform.isAndroid) {
      documents = await getExternalStorageDirectory();
    } else {
      documents = await getTemporaryDirectory();
    }
    var dir = documents.path;
    var filePath = path.join(dir, 'test.${audioInfo.container.name}');

    // Open the file to write.
    var file = File(filePath);
    var fileStream = file.openWrite();

    // Pipe all the content of the stream into our file.
    await yt.videos.streamsClient.get(audioInfo).pipe(fileStream);
    /*
                  If you want to show a % of download, you should listen
                  to the stream instead of using `pipe` and compare
                  the current downloaded streams to the totalBytes,
                  see an example ii example/video_download.dart
                   */

    // Close the file.
    await fileStream.flush();
    await fileStream.close();

    // Show that the file was downloaded.
    // await showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       content: Text(
    //           'Download completed and saved to: ${filePath}'),
    //     );
    //   },
    //
    // );
    
    await _player.setAudioSource(BufferAudioSource(await file.readAsBytes()));
    await _player.play();
  }

}

class BufferAudioSource extends StreamAudioSource {
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

class AudioManager {
  // Singleton pattern
  static AudioManager _instance = AudioManager._();
  // static final AudioManager _audioManager = new AudioManager._internal();
  // AudioManager._internal();
  // static AudioManager get instance => _audioManager;
  static AudioManager get instance => _instance;
  static AudioPlayer _player;
  AudioManager._() {
    _init();
    _player = AudioPlayer();
  }

  // final _initPlayerMemoizer = AsyncMemoizer<AudioPlayer>();

  AudioPlayer get player {
    if(_player == null){
      _init();
      _player = AudioPlayer();
    }
    return _player;
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
  }
}