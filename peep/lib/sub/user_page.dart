import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:peep/login/user_manager.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../db_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peep/home/emotion_detection.dart';
import 'package:peep/login/google_sign_in.dart';
import 'package:peep/player/music_player_page.dart';
import 'package:provider/provider.dart';
import 'package:shake/shake.dart';
import 'package:peep/player/audio_manager.dart';
import 'package:firebase_database/firebase_database.dart';


class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  ShakeDetector detector;
  @override
  void initState() {
    super.initState();
    detector = ShakeDetector.autoStart(onPhoneShake: (){
      print('Phone shaking detected');
      DetectEmotion().readFile().then((value) {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MusicPlayerPage()));
        print("init state done");
      });
    });
  }

  @override
  void dispose() {
    detector.stopListening();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    var name, photo, email, uid;
    if (user != null) {
      uid = user.uid;
      name = user.displayName;
      photo = user.photoURL;
      email = user.email;
    }
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 35.0, 15.0, 0.0),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  //user 이미지
                  radius: 50,
                  backgroundImage: NetworkImage(photo),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Center(
                child: Text(
                  name, //user이름
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: Text(
                  '안녕하세요. 반갑습니다 :)',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8.0,),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xfff6f7f9),
                    ),
                  //logout 버튼
                  onPressed: () {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.logout(); //logout method 호출
                  },
                  child: Text('Logout'),
                ),
              ),
              SizedBox(
                height: 35.0,
              ),
              Text(
                'MY 플레이리스트',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              /*SizedBox(
                height: 3.0,
              ),*/
              
              Container(
          // 수평적으로 대칭(symmetric)의 마진을 추가 -> 화면 위, 아래에 20픽세의 마진 삽입
          margin: EdgeInsets.symmetric(vertical: 20.0),
          // 컨테이너의 높이를 200으로 설정
          height: 50.0,
          // 리스트뷰 추가
          child: ListView(
            // 스크롤 방향 설정. 수평적으로 스크롤되도록 설정
            scrollDirection: Axis.horizontal,
            // 컨테이너들을 ListView의 자식들로 추가
            children: <Widget>[
              Container(
                child: SvgPicture.asset('assets/itd/ITD_button_1-1.svg')
                /*child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xfff6f7f9),
                    ),
                    onPressed: () {
                      //버튼 클릭 시 사용자가 커스터마이징한 CALM 플레이리스트
                    },
                    child: Text(
                      'HAPPY',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),*/
              ),
              Container(
                  child: SvgPicture.asset('assets/itd/ITD_button_1-2.svg')
                /*child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xfff6f7f9),
                    ),
                    onPressed: () {
                      //버튼 클릭 시 사용자가 커스터마이징한 CALM 플레이리스트
                    },
                    child: Text(
                      'BLUE',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),*/
              ),
              Container(
                  child: SvgPicture.asset('assets/itd/ITD_button_1-3.svg')
                /*child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xfff6f7f9),
                    ),
                    onPressed: () {
                      //버튼 클릭 시 사용자가 커스터마이징한 CALM 플레이리스트
                    },
                    child: Text(
                      'ANGRY',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),*/
              ),
              Container(
                  child: SvgPicture.asset('assets/itd/ITD_button_1-4.svg')
                /*child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xfff6f7f9),
                    ),
                    onPressed: () {
                      //버튼 클릭 시 사용자가 커스터마이징한 CALM 플레이리스트
                    },
                    child: Text(
                      'CALM',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),*/
              ),
              Container(
                  child: SvgPicture.asset('assets/itd/ITD_button_1-5.svg')
                /*child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xfff6f7f9),
                    ),
                    onPressed: () {
                      //버튼 클릭 시 사용자가 커스터마이징한 CALM 플레이리스트
                    },
                    
                    child: Text(
                      'FEAR',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),*/
                )
                    ],
                  ),
                ),
                SizedBox(
                height: 10.0,
                ),
                // SizedBox(
                //   width: double.infinity,
                //   height: 50,
                //   child: Container(
                //     alignment: Alignment.centerLeft,
                //     color: Color(0xFFF3F4F6),
                //     child: Text(
                //       '   좋아요 한 곡',
                //       style: TextStyle(
                //           color: Colors.black,
                //           fontSize: 15,
                //           fontWeight: FontWeight.bold),
                //     ),
                    
                //   ),
                  

                // ),
                Container(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xfff6f7f9),
                      minimumSize: Size.fromHeight(45),
                      shadowColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => likeSongs()),
                      );
                    },
                    
                    child: Text(
                      '좋아요 한 곡',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                height: 10.0,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    
                    style: ElevatedButton.styleFrom(
                      
                      primary: Color(0xfff6f7f9),
                      minimumSize: Size.fromHeight(45),
                      shadowColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => recentPlayList()),
                      );
                    },
                    
                    child: Text(
                      '최근에 들은 곡',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                          
                    ),
                  ),
                ),
              SizedBox(
                height: 35.0,
              ),
              ],
            )),
          ));
  }
}



final userFavoriteRef = DBManager.instance.ref
      .child("favorite")
      .child(UserManager.instance.user.uid);

final user = FirebaseAuth.instance.currentUser;
var uid = user.uid;

final songsFavoriteRef = DBManager.instance.ref.child("songs");
DatabaseReference listLike = new FirebaseDatabase().reference();

final db = FirebaseDatabase.instance.reference().child("favorite").child(uid);

final ref = FirebaseDatabase.instance.reference();

class likeSongs extends StatefulWidget{
  _likeSongState createState() => _likeSongState();
}

class _likeSongState extends State<likeSongs>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
        title: Text(
          '좋아요 한 곡',
        ),),
        body: Container(
          margin: EdgeInsets.symmetric(
            vertical: 20.0
          ),
          child: StreamBuilder(
            stream: listLike.child("favorite").child(uid).onValue,
            builder: (context, AsyncSnapshot<Event> snap){
                if(!snap.hasData) return Text("loading");
               
                return Column(
                  children: <Widget>[
                    //Text(snap.data.snapshot.value.runtimeType.toString()),
                    
                    Text(snap.data.snapshot.value.toString()),
                    Text(snap.data.snapshot.value[1].toString()),
                    //controlSearching('-MnYGbGO4FDnYZIzp7qe'),
                      
                  ],
                );
              },
            )
          ),
        );
  }
}

class LikeSongs extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<LikeSongs> {
  final fb = FirebaseDatabase.instance;
  
  String _searchText = "";

  _SearchScreenState() {
    
  }

 

  @override
  Widget build(BuildContext context) {
    final ref = fb.reference();
    controlSearching("-MnYFlz3HZWuz10dTQD4");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              controlSearching("-MnYFlz3HZWuz10dTQD4"),
              futureSearchResults == null
                  ? displayNoSearchResultScreen()
                  : diplaySearchResultScreen(),
            ]),
      )),
    );
  }
}

displayNoSearchResultScreen() {
  return Container(
      child: Center(
    child: ListView(
      shrinkWrap: true,
      children: <Widget>[
        Text(
          '좋아요 한 곡이 없습니다.',
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
                
              ),
            ],
          ),
        ));
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
  String _searchText = '-MnYFlz3HZWuz10dTQD4';
  final ref = FirebaseDatabase.instance.reference();

  ref
      .child("songs")
      .equalTo("-MnYFlz3HZWuz10dTQD4")
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

// 최근에 들은 곡
class recentPlayList extends StatefulWidget{
  _recentPlayList createState() => _recentPlayList();
}

class _recentPlayList extends State<recentPlayList>{
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
        title: Text(
          '최근에 들은 곡',
        ),),
      body: Container(
        
        height: 480.0,
        child: StreamBuilder<SequenceState>(
          stream: AudioManager.instance.player.sequenceStateStream,
          builder: (context, snapshot) {
            //final user = FirebaseAuth.instance.currentUser;
            //var uid = user.uid;

            //final db = FirebaseDatabase.instance.reference().child("favorite").child(uid);
            final state = snapshot.data;
            final sequence = state?.sequence ?? [];
            // void findLikes(){
            //     db.once().then((DataSnapshot snapshot){
            //     Map<dynamic, dynamic> values = snapshot.value;
            //       values.forEach((key,values) {
            //         print(values["like"]);
            //       });
            //   });
            //   }

            return ReorderableListView(
              onReorder: (int oldIndex, int newIndex) {
                if (oldIndex < newIndex) newIndex--;
                AudioManager.instance.playlist.move(oldIndex, newIndex);
              },
              children: [
                 for (var i = 0; i < sequence.length; i++)
                    Material(
                      key: ValueKey(sequence[i]),
                      color: i == state.currentIndex
                          ? Colors.grey.shade300
                          : null,
                      child: ListTile(
                        title: Text(sequence[i].tag.title as String),
                        subtitle: Text(sequence[i].tag.artist as String),
                        
                        onTap: () {
                          AudioManager.instance.player.seek(Duration.zero, index: i);
                        },
                      ),
                    ),
              ],
            );
          },
        ),
      ),
    );
  }

}




