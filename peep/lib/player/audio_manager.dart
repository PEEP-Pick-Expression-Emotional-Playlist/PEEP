import 'dart:io';
import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path/path.dart' as path;

import '../db_manager.dart';
import 'model/audio_metadata.dart';
import 'model/position_data.dart';

enum RecommendationType { RANDOM_ALL, RANDOM_TAG }

class NoFoundSearchResultException implements Exception {
  String cause;

  NoFoundSearchResultException(this.cause);
}

throwResultException() {
  throw new NoFoundSearchResultException('No results were found for search');
}

class AudioManager {
  //노래 재생을 담당하는 클래스
  // Singleton pattern
  //밑의 세 개 변수는 오디오를 전역변수처럼 쓰려고(메인에서 하단바 플레이어도 있으니까 동시에 관리하려고)선언한거니 신경안써도됨
  static AudioManager _instance = AudioManager._();

  static AudioManager get instance => _instance;
  static AudioPlayer _player;
  Duration duration;

  final _playlist = ConcatenatingAudioSource(children: []); //곡 정보를 저장하는 플레이 리스트
  var ref = DBManager.instance.ref.child("songs"); //파이어베이스에

  static String emotion;
  static String year;
  static String genre;

  AudioManager._() {
    _init();
    _player = AudioPlayer(); //플레이를 관리하는 객체 생성
    emotion = "happy"; //초기에는 happy로 설정. 파이어베이스에 감정에 따른 곡 검색할때 보냄
    year = "all"; //변수 만들기만하고 딱히 영향이없음.
    genre = "all";
  }

  AudioPlayer get player {
    if (_player == null) {
      //플레이어 생성안됐을때 설정 및 생성
      _init();
      _player = AudioPlayer();
    }
    return _player;
  }

  Future<void> _init() async {
    //초기 설정
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
  }

  static List<String> passList = []; // 패스한 곡 저장하려고 만들었는데 아직 쓰지를 못했음

  static YoutubeExplode yt = YoutubeExplode(); //유튜브에 검색하고 다운로드하는 라이브러리

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  play() {
    if (_player.sequence == null || _player.sequence.isEmpty) {
      //만약 플레이어에 현재 곡이 없다면
      //선택된 감정에 맞는 곡들 중 랜덤으로 곡을 검색하고 다운로드해서 재생함
      addSong(RecommendationType.RANDOM_ALL);

      // if (_player.sequence == null || _player.sequence.isEmpty) {
      //   try {
      //     _player.setAudioSource(_playlist);
      //   } catch (e) {
      //     // Catch load errors: 404, invalid url ...
      //     print("Error loading playlist: $e");
      //   }
      //   _player.play(); //플레이함
      // }

      // lists.add(value.value);

      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text(lists[0]["title"] + ' ' + lists[0]["artist"])));
      // debugPrint("peep "+playList[0]["title"] + ' ' + playList[0]["artist"]);
    }
    _player.play(); //현재 있는 곡 재생
  }

  addSong(recommendationType) async {
    debugPrint(emotion);

    var item;

    switch (recommendationType) {
      case RecommendationType.RANDOM_ALL:
        item = await getRandomAllItem();
        break;
      case RecommendationType.RANDOM_TAG:
        try {
          item = await getRandomTagItem();
        } catch (e) {
          item = await getRandomAllItem();
        }
        break;
    }

    var query = item['title'] + ' ' + item['artist'];

    debugPrint(_playlist.length.toString() +
        ' ' +
        item['key']+
        ' ' +
        item['title'] +
        ' ' +
        item['artist'] +
        ' ' +
        item['year'] +
        ' ' +
        item['emotions'].keys.toList().toString() +
        ' ' +
        item['genre'].keys.toList().toString() +
        ' ' +
        item['tags'].keys.toList().toString() +
        ' ' +
        item['favorite'].toString());

    var audioInfo = await getAudioInfo(query);
    if (audioInfo == null) {
      throwResultException();
    } else {
      var path = await getPath(audioInfo, query);
      //다운로드 되면 플레이리스트에 정보 추가
      _playlist.add(AudioSource.uri(
        Uri.file(path),
        tag: AudioMetadata(
          item['key'],
          item['title'],
          item['artist'],
          item['artwork'],
          item['year'],
          item['emotions'].keys.toList(),
          item['genre'].keys.toList(),
          item['tags'].keys.toList(),
          item['favorite'],
        ),
      ));

      debugPrint(_playlist.length.toString() +
          ' ' +
          Uri.file(path).toString() +
          ' ' +
          item['key']+
          ' ' +
          item['title'] +
          ' ' +
          item['artist'] +
          ' ' +
          item['year'] +
          ' ' +
          item['emotions'].keys.toList().toString() +
          ' ' +
          item['genre'].keys.toList().toString() +
          ' ' +
          item['tags'].keys.toList().toString() +
          ' ' +
          item['favorite'].toString());

      //처음으로 넣으면 플레이리스트 변수를 등록
      if (_player.sequence == null || _player.sequence.isEmpty) {
        try {
          // await _player.setAudioSource(BufferAudioSource(await file.readAsBytes()));
          _player.setAudioSource(_playlist);
        } catch (e) {
          // Catch load errors: 404, invalid url ...
          print("Error loading playlist: $e");
        }
        download(path, audioInfo).then((value) {
          debugPrint("ddddddddd" + path);
          _player.play();
        }); //플레이함
      } else {
        // if (_player.sequence == null || _player.sequence.isEmpty) {
        //   download(path, audioInfo).then;
        // } else {
        //   download(path, audioInfo);
        // }
        download(path, audioInfo);
      }
    }
  }

  getAudioInfo(query) async {
    var resList = await yt.search.getVideos(query);

    if (resList == null || resList.isEmpty) {
      return null;
    } else {
      var res = resList.first;
      // TODO: get total length
      duration = res.duration;
      debugPrint("durationnnnnn" + res.duration.inSeconds.toString());

      await Permission.storage.request();

      var manifest = await yt.videos.streamsClient.getManifest(res.id);
      var streams = manifest.audioOnly.toList(growable: false);
      var audioInfo = streams.first;
      return audioInfo;
    }
  }

  getPath(audioInfo, query) async {
    // Build the directory.
    Directory documents;
    if (Platform.isAndroid) {
      documents = await getExternalStorageDirectory();
    } else {
      // documents = await getApplicationDocumentsDirectory();
      documents = await getTemporaryDirectory();
    }
    var dir = documents.path;

    var filePath = path.join(dir, query + '.${audioInfo.container.name}');

    return filePath;
  }

  Future<void> download(filePath, audioInfo) async {
    // Open the file to write.
    var file = File(filePath);
    var fileStream = file.openWrite();

    // TODO: bb
    // var length = audioInfo.size.totalBytes;
    // var received = 0;

    await yt.videos.streamsClient.get(audioInfo).map((s) {
      // received += s.length;
      // TODO: ㅠㅠ
      // print("${(received / length) * 100} %");
      return s;
    }).pipe(fileStream);

    // Pipe all the content of the stream into our file.
    // await yt.videos.streamsClient.get(audioInfo).pipe(fileStream);
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
  }

  getRandomTagItem() async {
    var metadata =
        _playlist.sequence[_player.currentIndex].tag as AudioMetadata;
    var tags = metadata.tags;
    var randomTag = tags[Random().nextInt(metadata.tags.length)];
    debugPrint(randomTag);

    var value =
        await ref.orderByChild("tags/" + randomTag).equalTo(true).once();

    List tmp = [];
    value.value.forEach((key, values) {
      List list = values['emotions'].keys.toList();
      if (list.contains(emotion)) {
        values['key']=key;
        tmp.add(values);
      }
    });

    int random = Random().nextInt(tmp.length);

    return tmp[random];
  }

  getRandomAllItem() async {
    var value =
        await ref.orderByChild("emotions/" + emotion).equalTo(true).once();

    List tmp = [];
    value.value.forEach((key, values) {
      values['key']=key;
      tmp.add(values);
    });

    int random = Random().nextInt(tmp.length);

    return tmp[random];
  }
}
