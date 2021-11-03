import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:peep/home/emotion_detection.dart';
import 'package:shake/shake.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final fb = FirebaseDatabase.instance;
  final TextEditingController _filter = TextEditingController();

  String _searchText = "";

  _SearchScreenState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  ShakeDetector detector;
  @override
  void initState() {
    super.initState();
    detector = ShakeDetector.autoStart(onPhoneShake: (){
      print('Phone shaking detected');
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EmotionDetect()));
    });
  }

  @override
  void dispose() {
    detector.stopListening();
  }

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: TextFormField(
          controller: _filter,
          decoration: InputDecoration(
            hintText: '검색할 곡을 입력하세요',
            filled: true,
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _filter.clear();
                  _searchText = "";
                  futureSearchResults = null;
                });
              },
            ),
          ),
          onFieldSubmitted: controlSearching(_searchText),
        ),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              futureSearchResults == null
                  ? displayNoSearchResultScreen()
                  : diplaySearchResultScreen(),
            ]),
      )),
    );
  }
}

class SongInfo {
  String artist;
  //List<String> emotions;
  //List<String> genre;
  //List<String> tags;
  String title;
  //int year;

  SongInfo(String artist, String title) {
    this.artist = artist;
    this.title = title;
  }

  String getTitle() {
    return this.title;
  }

  String getArtist() {
    return this.artist;
  }
}

GetSongTitle(String sinfo) {
  String songTitle;
  String info;
  info = sinfo;

  String token = ', tags:';
  String token2 = 'title: ';
  int lastIndex = info.indexOf(token);
  int startIndex = info.indexOf(token2);
  songTitle = info.substring(startIndex + 7, lastIndex);
  return songTitle;
}

GetSongArtist(String sinfo) {
  String songArtist;
  String info;
  info = sinfo;

  String token = ', year:';
  String token2 = 'artist: ';
  int lastIndex = info.indexOf(token);
  int startIndex = info.indexOf(token2);
  songArtist = info.substring(startIndex + 8, lastIndex);
  return songArtist;
}

GetSongCover(String sinfo){
  String songCover;
  String info;
  info = sinfo;

  String token = ', title';
  String token2 = 'artwork: ';
  int lastIndex = info.indexOf(token);
  int startIndex = info.indexOf(token2);
  songCover = info.substring(startIndex + 9, lastIndex);
  return songCover;
}

String futureSearchResults;
controlSearching(str) {
  String _searchText = str;
  final ref = FirebaseDatabase.instance.reference();

  ref
      .child("songs")
      .orderByChild("title")
      .equalTo(_searchText)
      .once()
      .then((DataSnapshot data) {
    if (data != null) {
      print(data.value);
      print(GetSongTitle(data.value.toString()));
      print(GetSongArtist(data.value.toString()));
      futureSearchResults = data.value.toString();
    } else
      print('일치하는 곡이 없습니다.');
  });
}

displayNoSearchResultScreen() {
  return Container(
      child: Center(
    child: ListView(
      shrinkWrap: true,
      children: <Widget>[
        Text(
          '검색 결과가 없습니다.',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20),
        )
      ],
    ),
  ));
}

diplaySearchResultScreen() {
  return SongResult();
}

class SongResult extends StatefulWidget {
  @override
  _SongResultState createState() => _SongResultState();
}

class _SongResultState extends State<SongResult> {
  bool _favoriteSong = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(3),
        child: Container(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: (
                  Image.network(GetSongCover(futureSearchResults))),


                title: Text(
                  GetSongTitle(futureSearchResults),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  GetSongArtist(futureSearchResults),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                  ),
                ),
                trailing: Icon(
                    _favoriteSong ? Icons.favorite : Icons.favorite_border,
                    color: _favoriteSong ? Colors.red : null),
                onTap: () {
                  setState(() {
                    if (_favoriteSong == false) {
                      _favoriteSong = true;
                      //여기서 true 되면 좋아요 누른 곡에 추가되게
                    } else {
                      _favoriteSong = false;
                      //여기서 false 되면 좋아요 누른 곡에서 제외
                    }
                  });
                },
              ),
            ],
          ),
        ));
  }
}
