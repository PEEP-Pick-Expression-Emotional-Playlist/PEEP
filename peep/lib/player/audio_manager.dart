import 'dart:io';
import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path/path.dart' as path;

import '../db_manager.dart';
import 'model/audio_metadata.dart';
import 'model/query_video.dart';

class AudioManager { //노래 재생을 담당하는 클래스
  // Singleton pattern
  //밑의 세 개 변수는 오디오를 전역변수처럼 쓰려고(메인에서 하단바 플레이어도 있으니까 동시에 관리하려고)선언한거니 신경안써도됨
  static AudioManager _instance = AudioManager._();

  static AudioManager get instance => _instance;
  static AudioPlayer _player;

  final _playlist = ConcatenatingAudioSource(children: []); //곡 정보를 저장하는 플레이 리스트
  var ref = DBManager.instance.ref.child("songs"); //파이어베이스에

  static String emotion; //선택된 감정
  static String year; //연도

  AudioManager._() { //클래스 생성자
    _init();
    _player = AudioPlayer(); //플레이를 관리하는 객체 생성
    emotion = "happy"; //초기에는 happy로 설정. 파이어베이스에 감정에 따른 곡 검색할때 보냄
    year = 'all';  //변수 만들기만하고 딱히 영향이없음.
  }

  AudioPlayer get player {
    if (_player == null) { //플레이어 생성안됐을때 설정 및 생성
      _init();
      _player = AudioPlayer();
    }
    return _player;
  }

  Future<void> _init() async { //초기 설정
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
  }

  // static List playList = [];
  // static List
  static List<String> passList = []; // 패스한 곡 저장하려고 만들었는데 아직 쓰지를 못했음

  // String query = "Beautiful Mistakes Maroon 5, Megan Thee Stallion";

  static YoutubeExplode yt = YoutubeExplode(); //유튜브에 검색하고 다운로드하는 라이브러리
  static QueryVideo videoInfo; //유튜브에서 검색된 영상 정보

  play(context) {
    if (_player.sequence == null || _player.sequence.isEmpty) { //만약 플레이어에 현재 곡이 없다면
      addRandomSong(context); //선택된 감정에 맞는 곡들 중 랜덤으로 곡을 검색하고 다운로드해서 재생함

      // lists.add(value.value);

      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text(lists[0]["title"] + ' ' + lists[0]["artist"])));
      // debugPrint("peep "+playList[0]["title"] + ' ' + playList[0]["artist"]);
    } else {
      _player.play(); //현재 있는 곡 재생
    }
  }

  addRandomSong2(context) { //랜덤으로 노래뽑고 다운로드
    debugPrint(emotion);
    var metadata = _playlist.sequence[_player.currentIndex].tag as AudioMetadata;
    var tags = metadata.tags;
    var randomTag = tags[Random().nextInt(metadata.tags.length)];
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar( //선택된 감정과 연도를 보여줌
    //     content: Text("선정된 태그: #"+randomTag)));
    debugPrint(randomTag);
    ref
        .orderByChild("tags/" + randomTag) //파이어베이스에서 감정 검색
        .equalTo(true)
        .once()
        .then((value) {
      List tmp = [];
      value.value.forEach((key, values) {
        List list = values['emotions'].keys.toList();
        if(list.contains(emotion))//검색된거 다받아옴
          tmp.add(values);
      });

      int random = Random().nextInt(tmp.length); //그중 랜덤으로 인덱스 뽑음

      var item = tmp[random]; //아이템 하나 담음
      debugPrint(_playlist.length.toString() +
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
          item['tags'].keys.toList().toString());
      //뽑은 것 정보로 다운로드 함수 호출
      download(context, item['title']+' '+item['artist']).then((value) {
        //다운로드 되면 플레이리스트에 정보 추가
        _playlist.add(AudioSource.uri(
          Uri.file(value),
          tag: AudioMetadata(
            item['title'],
            item['artist'],
            item['artwork'],
            item['year'],
            item['emotions'].keys.toList(),
            item['genre'].keys.toList(),
            item['tags'].keys.toList(),
          ),
        ));

        debugPrint(_playlist.length.toString() +
            ' ' +
            Uri.file(value).toString() +
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
            item['tags'].keys.toList().toString());
        // await _player.setAudioSource(BufferAudioSource(await file.readAsBytes()));
        //처음으로 넣으면 플레이리스트 변수를 등록
        if (_player.sequence == null || _player.sequence.isEmpty) {
          try {
            _player.setAudioSource(_playlist);
          } catch (e) {
            // Catch load errors: 404, invalid url ...
            print("Error loading playlist: $e");
          }
          _player.play(); //플레이함
        }
      });
    }
    ).catchError((onError){
      addRandomSong(context);
    });
  }

  addRandomSong(context) { //랜덤으로 노래뽑고 다운로드
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar( //선택된 감정과 연도를 보여줌
    //     content: Text("선택된 감정:"+emotion)));
    debugPrint(emotion);
    ref
        .orderByChild("emotions/" + emotion) //파이어베이스에서 감정 검색
        .equalTo(true)
        .once()
        .then((value) {
      List tmp = [];
      value.value.forEach((key, values) { //검색된거 다받아옴
        tmp.add(values);
      });

      int random = Random().nextInt(tmp.length); //그중 랜덤으로 인덱스 뽑음

      var item = tmp[random]; //아이템 하나 담음
      debugPrint(_playlist.length.toString() +
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
          item['tags'].keys.toList().toString());
      //뽑은 것 정보로 다운로드 함수 호출
      download(context, item['title']+' '+item['artist']).then((value) {
        //다운로드 되면 플레이리스트에 정보 추가
        _playlist.add(AudioSource.uri(
          Uri.file(value),
          tag: AudioMetadata(
            item['title'],
            item['artist'],
            item['artwork'],
            item['year'],
            item['emotions'].keys.toList(),
            item['genre'].keys.toList(),
            item['tags'].keys.toList(),
          ),
        ));

        debugPrint(_playlist.length.toString() +
            ' ' +
            Uri.file(value).toString() +
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
            item['tags'].keys.toList().toString());
        // await _player.setAudioSource(BufferAudioSource(await file.readAsBytes()));
        //처음으로 넣으면 플레이리스트 변수를 등록
        if (_player.sequence == null || _player.sequence.isEmpty) {
          try {
            _player.setAudioSource(_playlist);
          } catch (e) {
            // Catch load errors: 404, invalid url ...
            print("Error loading playlist: $e");
          }
          _player.play(); //플레이함
        }
      });
    });
  }

  pass(context) { //다음 곡
    if (_player.hasNext) { //다음 곡이 있으면
      //다음 곡 정보를 가져온다
      var metadata = _playlist.sequence[_player.currentIndex+1].tag as AudioMetadata;
      debugPrint(metadata.title+' '+metadata.artist);
      //곡명이랑 가수명으로 다운로드한다
      download(context,metadata.title+' '+metadata.artist).then(
              (value) => _player.seekToNext() //다음으로 넘긴다
      );
    }
  }

  prev(context){ //이전 곡
    if(_player.hasPrevious) { //이전 곡이 있으면
      //이전 곡 정보를 가져온다
      var metadata = _playlist.sequence[_player.currentIndex-1].tag as AudioMetadata;
      debugPrint(metadata.title+' '+metadata.artist);
      //곡명이랑 가수명으로 다운로드한다
      download(context,metadata.title+' '+metadata.artist).then(
              (value) => _player.seekToPrevious() //이전으로 넘긴다
      );
    }
  }


  Future<String> download(context, query) async { // 다운로드. query는 검색할 내용
    var resList =
    await yt.search.getVideos(query);

    if (resList == null || resList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No results were found for search')));
      return null;
    } else {
      Video res = resList.first;
      videoInfo = QueryVideo(res.title, res.id.value, res.duration);


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
      //test.(확장자) 라는 이름으로 저장. 다 이름 같아서 덮어씀
      //->query로 따로 저장
      var filePath = path.join(dir, query+'.${audioInfo.container.name}');

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

      return filePath;

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
  }

}