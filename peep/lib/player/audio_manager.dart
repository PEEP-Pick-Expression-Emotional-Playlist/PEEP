import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:peep/login/user_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

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

  static double downloadPercentage;

  static List<String> passList = [];
  List<String> sendingData = [];

  static YoutubeExplode yt = YoutubeExplode(); //유튜브에 검색하고 다운로드하는 라이브러리

  final userRatingRef = DBManager.instance.ref
      .child("ratings")
      .child(UserManager.instance.user.uid);

  AudioManager._() {
    _init();
    _player = AudioPlayer(); //플레이를 관리하는 객체 생성
    emotion = "happy"; //초기에는 happy로 설정. 파이어베이스에 감정에 따른 곡 검색할때 보냄
    year = "모든 연도";
    genre = "모든 장르";
  }

  AudioPlayer get player {
    if (_player == null) {
      //플레이어 생성안됐을때 설정 및 생성
      _init();
      _player = AudioPlayer();
    }
    return _player;
  }

  ConcatenatingAudioSource get playlist {
    return _playlist;
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

  Stream<PositionData> get positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
              (position, bufferedPosition, duration) =>
              PositionData(
                  position, bufferedPosition, duration ?? Duration.zero));

  play(context) {
    if (_player.sequence == null || _player.sequence.isEmpty) {
      //만약 플레이어에 현재 곡이 없다면
      //선택된 감정에 맞는 곡들 중 랜덤으로 곡을 검색하고 다운로드해서 재생함
      addSong(RecommendationType.RANDOM_ALL, context);
    } else {
      _player.play(); //현재 있는 곡 재생
    }
  }

  addSong(recommendationType, context) async {
    debugPrint('##### 선택된 조건: 감정-'+emotion+' // 장르-'+genre+' // 연도-'+year+' #####');

    List<dynamic> items = [];

    switch (recommendationType) {
      case RecommendationType.RANDOM_ALL:
        debugPrint('##### 전체 곡 중, 조건에 맞는 5곡을 랜덤 추천하겠습니다 #####');
        items = await _getByRandom();
        break;
      case RecommendationType.RANDOM_TAG:
        try {
          debugPrint('##### 콘텐츠 기반 필터링과 아이템 기반 협업 필터링을 이용해 추천합니다 #####');
          items = await getRecommendedSongs();
        } catch (e) {
          debugPrint('##### 전체 곡 중, 조건에 맞는 5곡을 랜덤 추천하겠습니다 #####');
          items = await _getByRandom();
        }
        break;
    }

    if(items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("조건에 맞는 곡이 없습니다")));
      debugPrint('##### 조건에 맞는 곡이 없습니다 #####');
    }

    items.forEach((item) async {
      var query = item['title'] + ' ' + item['artist'];

      debugPrint('##### 추천된 곡을 유튜브에서 다운로드 합니다 #####');

      // debugPrint('추천된 곡의 정보: ' +
      //     '곡 ID- '+item['key'] +
      //     '//곡 명- ' +
      //     item['title'] +
      //     '//아티스트 명- ' +
      //     item['artist'] +
      //     '//연도- ' +
      //     item['year'] +
      //     '//감정- ' +
      //     item['emotions'].keys.toList().toString() +
      //     '//장르- ' +
      //     item['genre'].keys.toList().toString() +
      //     '//태그- ' +
      //     item['tags'].keys.toList().toString() +
      //     '//좋아요 수- ' +
      //     item['favorite'].toString());

      final list = await getAudioInfo(query);
      var audioInfo = list[0];
      Duration duration = list[1];
      if (audioInfo == null) {
        throwResultException();
      } else {
        var path = await getPath(audioInfo, query);
        var rating = await getRating(item['key']);
        //다운로드 되면 플레이리스트에 정보 추가
        _playlist
            .add(AudioSource.uri(
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
              duration,
              rating
          ),
        ))
            .then((value) {
          //처음으로 넣으면 플레이리스트 변수를 등록
          if (_player.sequence == null || _player.sequence.isEmpty) {
            try {
              // await _player.setAudioSource(BufferAudioSource(await file.readAsBytes()));
              _player.setAudioSource(_playlist, preload: false);
              var prePercentage = -1;
              download(path, audioInfo).listen((event) {
                if (prePercentage < event) {
                  prePercentage = event;
                  // print(event);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                    Text("다운로드 후 자동실행됩니다 $event %"),
                  ));
                }
              }, onDone: () {
                // debugPrint("ddddddddd" + path);
                _player.pause();
                _player.play();
              });
            } catch (e) {
              // Catch load errors: 404, invalid url ...
              print("Error loading playlist: $e");
            }
          } else {
            download(path, audioInfo).listen((event) {}
                , onDone: () {
                  // debugPrint("ddddddddd" + path);
                  _player.play();
                });
          }

          debugPrint('추천 후 유튜브에서 다운로드 한 곡의 정보: ' +
              '곡 ID- '+item['key'] +
              ' // 곡 명- ' +
              item['title'] +
              ' // 아티스트 명- ' +
              item['artist'] +
              ' // 연도- ' +
              item['year'] +
              ' // 감정- ' +
              item['emotions'].keys.toList().toString() +
              ' // 장르- ' +
              item['genre'].keys.toList().toString() +
              ' // 태그- ' +
              item['tags'].keys.toList().toString() +
              ' // 좋아요 수- ' +
              item['favorite'].toString()+
              ' // 평점 -'+
              rating.toString()
          );
        });
      }
    });
  }

  getRecommendedSongs() async {
    var metadata = _playlist.sequence[_player.currentIndex]
        .tag as AudioMetadata;
    List<Map> ret = [];
    var url = Uri.parse('http://3.38.93.39:5000/peep/ml/get_data');
    try {
      var response = await http.post(
          url,
          body: json.encode({
            'emotion': json.encode(emotion),
            'genre': json.encode(genre),
            'year': json.encode(year),
            'target_id': json.encode(metadata.key),
            'user_id': json.encode(UserManager.instance.uid),
          }),
        headers: {"Content-Type" : "application/json"},
      );

      Map res = json.decode(response.body);

     for (String k in res.keys){
       var value = await DBManager.instance.ref.child("songs/" + k)
           .get();
       Map val = value.value;
       val['key'] = k;
       ret.add(val);
     }
      return ret;
    } catch (e) {
      print("server connect failed");
      Exception(e);
    }

    return ret;
  }

  Future<List> getAudioInfo(query) async {
    var resList = await yt.search.getVideos(query);

    if (resList == null || resList.isEmpty) {
      return null;
    } else {
      var res = resList.first;
      duration = res.duration;
      // debugPrint("durationnnnnn" + res.duration.inSeconds.toString());

      await Permission.storage.request();

      var manifest = await yt.videos.streamsClient.getManifest(res.id);
      var streams = manifest.audioOnly.toList(growable: false);
      var audioInfo = streams.first;

      return [audioInfo, res.duration];
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

  Stream<int> download(filePath, audioInfo) async* {
    // Open the file to write.
    var file = File(filePath);
    var fileStream = file.openWrite();

    var length = audioInfo.size.totalBytes;
    var received = 0;

    StreamController<int> streamController = StreamController();
    try {
      yt.videos.streamsClient
          .get(audioInfo)
          .map((s) {
        received += s.length;
        var percentage;
        if(length < 1){
          percentage = 0;
        } else
          {
            percentage = ((received / length) * 100).toInt();
          }

        var checkList = [1, 5, 10, 20, 40, 50, 70, 90, 99];
        if (checkList.contains(percentage)) {
          streamController.add(percentage);
        }
        // print("${(received / length)} %");
        return s;
      })
          .pipe(fileStream)
          .whenComplete(() {
        streamController.close();
      });
      yield* streamController.stream;
    } catch (e) {
      throw e;
    }

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

  }

  _getByGenre(Map map) {
    Map res = Map();
    for (var entry in map.entries){
      List list = entry.value['genre'].keys.toList();
      if (list.contains(genre)) {
        res[entry.key] = entry.value;
      }
    }
    return res;
  }

  _getByYear(Map map) {
    Map res = Map();
    for (var entry in map.entries) {
      if (entry.value['year'] == year) {
        res[entry.key] = entry.value;
      }
    }
    return res;
  }

  _removeByPass(Map map) {
    Map res = Map();
    for (var entry in map.entries){
      if (!passList.contains(entry.value['key'])) {
        res[entry.key] = entry.value;
      }
    }
    return map;
  }

  _getByRandom() async {
    var value =
    await ref.orderByChild("emotions/" + emotion).equalTo(true).once();

    Map queryResult = value.value;
    queryResult = _removeByPass(queryResult);
    // value.value type: _InternalLinkedHashMap
    // debugPrint("now genre:"+genre+", year"+year);
    if (genre != "모든 장르") {
      queryResult = _getByGenre(queryResult);
    }
    if (year != "모든 연도") {
      queryResult = _getByYear(queryResult);
    }

    List tmp = [];
    // debugPrint("value.value type is..."+value.value.runtimeType.toString());
    for (var entry in queryResult.entries) {
      entry.value['key'] = entry.key;
      tmp.add(entry.value);
    }

    List res = [];
    if (tmp.length>0){
      for (int i = 0; i < 5; i++) {
        int random = Random().nextInt(tmp.length);
        res.add(tmp[random]);
      }
    }

    return res;
  }

  getRating(songKey) async {
    var value = await userRatingRef.child(songKey).get();
    if (!value.exists) {
      // debugPrint('평점 정보 없음');
      return 0.0;
    } else {
      // debugPrint('평점 정보 키'+songKey);
      // debugPrint('평점 정보'+value.value.toDouble().toString());
      return value.value.toDouble();
    }
  }
}
