import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../db_manager.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final fb = FirebaseDatabase.instance;
  final TextEditingController _filter = TextEditingController();

  void dispose(){
    _filter.dispose();
    super.dispose();
  }

  String _searchText = "";

  _SearchScreenState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
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
            prefixIcon: IconButton(
              icon: Icon(Icons.search, color: Colors.grey),
              onPressed: (){
                controlSearching(_searchText);
              },),

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
      body: Center(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SongList.isEmpty ? displayNoSearchResultScreen()
                      : diplaySearchResultScreen(),
                ]),
          )),
    );
  }
}


List SongList=[];
bool sIsFind = false;

controlSearching(str) {
  String _searchText = str;
  if (_searchText != "") {
    //final ref = FirebaseDatabase.instance.reference();
    var ref = DBManager.instance.ref.child("songs");
    ref
        .orderByChild("title")
        .startAt(_searchText)
        .endAt(_searchText + "\uf8ff")
        .once()
        .then((value) {
      if (value != null) {
        value.value.
        forEach((key, values) {
          SongList.add(values);
        });

      }
      else {
        print('일치하는 곡이 없습니다.');
      }
    });

    ref
        .orderByChild("artist")
        .startAt(_searchText)
        .endAt(_searchText + "\uf8ff")
        .once()
        .then((value) {
      if (value != null) {
        value.value.
        forEach((key, values) {
          SongList.add(values);
        });

      }
      else {
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

  String getEmotion(String emo){
    if(emo == '(happy)'){
      return 'assets/itd/ITD_icon_happy.svg';
    }
    else if(emo == '(blue)'){
      return 'assets/itd/ITD_icon_blue.svg';
    }
    else if(emo=='(angry)'){
      return 'assets/itd/ITD_icon_angry.svg';
    }
    else if(emo=='(calm)'){
      return 'assets/itd/ITD_icon_calm.svg';
    }
    else if(emo=='(fear)'){
      return 'assets/itd/ITD_icon_fear.svg';
    }
  }
  @override
  Widget build(BuildContext context) {
    for(int i=0;i<SongList.length;i++){
      var item = SongList[i];
      debugPrint(
          "songlist "+
              item['title'] +
              ' ' +
              item['artist'] +
              ' ' +
              item['artwork']+' '+item['emotions'].keys.toString())
      ;
    }

    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: SongList.length,
      itemBuilder: (BuildContext context, int i){
        return ListTile(
          leading: (
              Image.network(SongList[i]['artwork'])),


          title: Text(SongList[i]['title'],
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          subtitle: Text(SongList[i]['artist'],
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
            ),
          ),
          trailing: SvgPicture.asset(getEmotion(SongList[i]['emotions'].keys.toString())),

        );
      },
    );

  }
}