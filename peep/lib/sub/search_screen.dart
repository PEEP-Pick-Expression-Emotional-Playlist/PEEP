import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:peep/db_manager.dart';
import 'package:peep/home/emotion_detection.dart';
import 'package:peep/login/user_manager.dart';
import 'package:peep/player/audio_manager.dart';
import 'package:peep/player/music_player_page.dart';
import 'package:shake/shake.dart';
import 'package:flutter_svg/svg.dart';

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
    detector = ShakeDetector.autoStart(onPhoneShake: () {
      print('Phone shaking detected');
      DetectEmotion().readFile().then((value) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MusicPlayerPage()));
        AudioManager.instance.addSong(RecommendationType.RANDOM_TAG,context);
      });
    });
  }

  @override
  void dispose() {
    detector.stopListening();
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final ref = fb.reference();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: TextFormField(
          controller: _filter,
          decoration: InputDecoration(
            hintText: '검색할 곡을 입력하세요',
            filled: true,
            prefixIcon: IconButton(
              icon: Icon(Icons.search, color: Colors.grey),
              onPressed: () {
                SongList.clear();
                controlSearching(_searchText);
              },
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _filter.clear();
                  SongList.clear();
                });
              },
            ),
          ),
          //onFieldSubmitted: controlSearching(_searchText),
        ),
      ),
      body: SongList.isEmpty? displayNoSearchResultScreen():
          SingleChildScrollView(
        child: diplaySearchResultScreen(),
          ),
      );
  }
}

List SongList = [];
List HappySongList = [];
List BlueSongList = [];
List AngrySongList = [];
List CalmSongList = [];
List FearSongList = [];

controlSearching(str) {
  bool hasItem = false;
  String _searchText = str;
  if (_searchText != "") {
    //final ref = FirebaseDatabase.instance.reference();
    var ref = FirebaseDatabase.instance.reference().child("songs");
    ref
        .orderByChild("title")
        .startAt(_searchText)
        .endAt(_searchText + "\uf8ff")
        .once()
        .then((value) {
      if (value.value != null) {
        value.value.forEach((key, values) {
          values['key'] = key;
          for(Map map in SongList){
            if(map.containsKey("key")){
              if(map["key"]==key){
                hasItem = true;
              }
            }
          }
          if (!hasItem){
            SongList.add(values);
          }
        });
      } else {
        print('일치하는 곡이 없습니다.');
      }
    });

    ref
        .orderByChild("artist")
        .startAt(_searchText)
        .endAt(_searchText + "\uf8ff")
        .once()
        .then((value) {
      if (value.value != null) {
        value.value.forEach((key, values) {
          values['key'] = key;
          for(Map map in SongList){
            if(map.containsKey("key")){
              if(map["key"]==key){
                hasItem = true;
              }
            }
          }
          if (!hasItem){
            SongList.add(values);
          }
        });
      } else {
        print('일치하는 곡이 없습니다.');
      }
    });
  }
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
  var uid;
  final user = FirebaseAuth.instance.currentUser;
  final userDB = FirebaseDatabase.instance
      .reference()
      .child("user")
      .child(UserManager.instance.user.uid);

  String getEmotionImage(String emo) {
    if (emo == '(happy)') {
      return 'assets/itd/ITD_icon_happy.svg';
    } else if (emo == '(blue)') {
      return 'assets/itd/ITD_icon_blue.svg';
    } else if (emo == '(angry)') {
      return 'assets/itd/ITD_icon_angry.svg';
    } else if (emo == '(calm)') {
      return 'assets/itd/ITD_icon_calm.svg';
    } else if (emo == '(fear)') {
      return 'assets/itd/ITD_icon_fear.svg';
    }
  }

  String getEmotion(String emo) {
    if (emo == '(happy)') {
      return 'happy';
    } else if (emo == '(blue)') {
      return 'blue';
    } else if (emo == '(angry)') {
      return 'angry';
    } else if (emo == '(calm)') {
      return 'calm';
    } else if (emo == '(fear)') {
      return 'fear';
    }
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < SongList.length; i++) {
      var item = SongList[i];
      debugPrint("songlist " +
          item['title'] +
          ' ' +
          item['artist'] +
          ' ' +
          item['artwork'] +
          ' ' +
          item['emotions'].keys.toString());
    }

    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: SongList.length,
      itemBuilder: (BuildContext context, int i) {
        return ListTile(
          leading: (Image.network(SongList[i]['artwork'])),
          title: Text(
            SongList[i]['title'],
          ),
          subtitle: Text(
            SongList[i]['artist'],

          ),
          trailing: InkWell(
            child: SvgPicture.asset(
                getEmotionImage(SongList[i]['emotions'].keys.toString())),
            onTap: () => showMessage(
                i, getEmotion(SongList[i]['emotions'].keys.toString())),
          ),
        );
      },
    );
  }

  void showMessage(int i, String emotion) {
    bool hasItem = false;

    if (emotion == 'happy') {
      for(Map map in HappySongList){
        if(map.containsKey("key")){
          if(map["key"]==SongList[i]['key']){
            hasItem = true;
          }
        }
      }
      if (!hasItem){
        HappySongList.add(SongList[i]);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('플레이리스트에 추가되었습니다.'),
        ));
      }
      else if (hasItem){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('이미 추가된 곡입니다'),
        ));
      }

      for (int i = 0; i < HappySongList.length; i++) {
        var item = HappySongList[i];
        debugPrint("HappySongList " +
            item['title'] +
            ' ' +
            item['artist'] +
            ' ' +
            item['artwork'] +
            ' ' +
            item['emotions'].keys.toString());
      }
    } else if (emotion == 'blue') {
      for(Map map in BlueSongList){
        if(map.containsKey("key")){
          if(map["key"]==SongList[i]['key']){
            hasItem = true;
          }
        }
      }
      if (!hasItem){
        BlueSongList.add(SongList[i]);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('플레이리스트에 추가되었습니다.'),
        ));
      }
      else if (hasItem){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('이미 추가된 곡입니다'),
        ));
      }
      for (int i = 0; i < BlueSongList.length; i++) {
        var item = BlueSongList[i];
        debugPrint("BlueSongList " +
            item['title'] +
            ' ' +
            item['artist'] +
            ' ' +
            item['artwork'] +
            ' ' +
            item['emotions'].keys.toString());
      }
    } else if (emotion == 'angry') {
      for(Map map in AngrySongList){
        if(map.containsKey("key")){
          if(map["key"]==SongList[i]['key']){
            hasItem = true;
          }
        }
      }
      if (!hasItem){
        AngrySongList.add(SongList[i]);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('플레이리스트에 추가되었습니다.'),
        ));
      }
      else if (hasItem){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('이미 추가된 곡입니다'),
        ));
      }
      for (int i = 0; i < AngrySongList.length; i++) {
        var item = AngrySongList[i];
        debugPrint("AngrySongList " +
            item['title'] +
            ' ' +
            item['artist'] +
            ' ' +
            item['artwork'] +
            ' ' +
            item['emotions'].keys.toString());
      }
    } else if (emotion == 'calm') {
      for(Map map in CalmSongList){
        if(map.containsKey("key")){
          if(map["key"]==SongList[i]['key']){
            hasItem = true;
          }
        }
      }
      if (!hasItem){
        CalmSongList.add(SongList[i]);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('플레이리스트에 추가되었습니다.'),
        ));
      }
      else if (hasItem){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('이미 추가된 곡입니다'),
        ));
      }
      for (int i = 0; i < CalmSongList.length; i++) {
        var item = CalmSongList[i];
        debugPrint("CalmSongList " +
            item['title'] +
            ' ' +
            item['artist'] +
            ' ' +
            item['artwork'] +
            ' ' +
            item['emotions'].keys.toString());
      }
    } else if (emotion == 'fear') {
      for(Map map in FearSongList){
        if(map.containsKey("key")){
          if(map["key"]==SongList[i]['key']){
            hasItem = true;
          }
        }
      }
      if (!hasItem){
        FearSongList.add(SongList[i]);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('플레이리스트에 추가되었습니다.'),
        ));
      }
      else if (hasItem){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('이미 추가된 곡입니다'),
        ));
      }
      for (int i = 0; i < FearSongList.length; i++) {
        var item = FearSongList[i];
        debugPrint("FearSongList " +
            item['title'] +
            ' ' +
            item['artist'] +
            ' ' +
            item['artwork'] +
            ' ' +
            item['emotions'].keys.toString());
      }
    }
    Map tmpVal = SongList[i];
    String tmpKey = SongList[i]['key'];
    tmpVal.forEach((key, value) {
      DBManager.instance.ref
          .child('playlist')
          .child(UserManager.instance.uid)
      .child(emotion)
          .child(tmpKey).child(key).set(value);
    });
  }
}

class Todo {
  final String title;
  final String artist;

  Todo(this.title, this.artist);
}
