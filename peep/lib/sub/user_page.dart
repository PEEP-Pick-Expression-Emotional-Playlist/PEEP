import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:peep/login/user_manager.dart';
import 'package:peep/sub/search_screen.dart';
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
                child: InkWell(child:SvgPicture.asset('assets/itd/ITD_button_1-1.svg'),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHappyPlayList()),
                  );
                },)

              ),
              Container(
                  child: InkWell(child:SvgPicture.asset('assets/itd/ITD_button_1-2.svg'),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyBluePlayList()),
                      );
                    },)

              ),
              Container(
                  child: InkWell(child:SvgPicture.asset('assets/itd/ITD_button_1-3.svg'),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyAngryPlayList()),
                      );
                    },)

              ),
              Container(
                  child: InkWell(child:SvgPicture.asset('assets/itd/ITD_button_1-4.svg'),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyCalmPlayList()),
                      );
                    },)

              ),
              Container(
                  child: InkWell(child:SvgPicture.asset('assets/itd/ITD_button_1-5.svg'),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyFearPlayList()),
                      );
                    },)

                )
                    ],
                  ),
                ),
                SizedBox(
                height: 10.0,
                ),


                Container(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xfff6f7f9),
                      minimumSize: Size.fromHeight(45),
                      shadowColor: Colors.transparent,
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
                      shadowColor: Colors.transparent,
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
final songdb = FirebaseDatabase.instance.reference().child("songs");

final ref = FirebaseDatabase.instance.reference();

class likeSongs extends StatefulWidget{
  _likeSongState createState() => _likeSongState();
}

List likesonglist = [];

class _likeSongState extends State<likeSongs>{
  
  @override
  Widget build(BuildContext context){
    listLike.child("favorite").child(uid).get().then((value) {

      value.value.forEach((k,v) {
        String tmp_key= k;
              Map tmp_song = Map();

      bool hasItem = false;
      
      songdb.child(tmp_key).get().then((value) {
          tmp_song['key'] = tmp_key;
        value.value.forEach((k,v){
          tmp_song[k] = v;
        });
      for(Map map in likesonglist){
        if(map.containsKey("key")){
          if(map["key"]==tmp_song['key']){
            hasItem = true;
          }
        }
      }
      if (!hasItem){
            likesonglist.add(tmp_song);
      }
      
      });

        });

  
      

      }
      );

   
    
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
        title: Text(
          '좋아요 한 곡',
        ),),
        // body: Container(
        //   margin: EdgeInsets.symmetric(
        //     vertical: 20.0
        //   ),
         body: likesonglist.isEmpty?Container(width: 50,height: 50,): ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: likesonglist.length,
          itemBuilder: (BuildContext context, int i){

            return ListTile(
              leading: (
                  Image.network(likesonglist[i]['artwork'])),


              title: Text(likesonglist[i]['title'],
                style: TextStyle(
                    color: Colors.black,
                    // fontSize: 20,
                    // fontWeight: FontWeight.bold
                    ),
              ),
              subtitle: Text(likesonglist[i]['artist'],
                style: TextStyle(
                  color: Colors.black,
                  //fontSize: 13,
                ),
              ),
              trailing: InkWell(child: SvgPicture.asset('assets/icons/player_mini_play.svg'),
                onTap: (){},),
            );
          }));
          }
        
  }


class favoriteSongs extends StatefulWidget{
  _favoriteSongs createState() => _favoriteSongs();
}

class _favoriteSongs extends State<favoriteSongs>{
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
        title: Text(
          '좋아요 한 곡',
        ),),
      body: Container(
        
        height: 480.0,
        child: StreamBuilder<SequenceState>(
          //stream: DBManager.instance.ref.child("songs"),
          builder: (context, snapshot) {
           
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
                        leading: (
                        Image.network(sequence[i].tag.artwork)),
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
        
        height: double.infinity,
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
                        leading: (
                        Image.network(sequence[i].tag.artwork)),
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


class MyHappyPlayList extends StatefulWidget {
  _MyHappyPlayList createState() => _MyHappyPlayList();
}

class _MyHappyPlayList extends State<MyHappyPlayList>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Happy PlayList',
        ),),
      body: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: HappySongList.length,
          itemBuilder: (BuildContext context, int i){
            return ListTile(
                leading: (
                Image.network(HappySongList[i]['artwork'])),


            title: Text(HappySongList[i]['title'],
            style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold),
            ),
            subtitle: Text(HappySongList[i]['artist'],
            style: TextStyle(
            color: Colors.black,
            fontSize: 13,
            ),
            ),
              trailing: InkWell(child: SvgPicture.asset('assets/icons/player_mini_play.svg'),
              onTap: (){},),
            );
          }),
      );
  }
}

class MyBluePlayList extends StatefulWidget {
  _MyBluePlayList createState() => _MyBluePlayList();
}

class _MyBluePlayList extends State<MyBluePlayList>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Blue PlayList',
        ),),
      body: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: BlueSongList.length,
          itemBuilder: (BuildContext context, int i){
            return ListTile(
              leading: (
                  Image.network(BlueSongList[i]['artwork'])),


              title: Text(BlueSongList[i]['title'],
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(BlueSongList[i]['artist'],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              trailing: InkWell(child: SvgPicture.asset('assets/icons/player_mini_play.svg'),
                onTap: (){},),
            );
          }),
    );
  }
}

class MyAngryPlayList extends StatefulWidget {
  _MyAngryPlayList createState() => _MyAngryPlayList();
}

class _MyAngryPlayList extends State<MyAngryPlayList>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Angry PlayList',
        ),),
      body: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: AngrySongList.length,
          itemBuilder: (BuildContext context, int i){
            return ListTile(
              leading: (
                  Image.network(AngrySongList[i]['artwork'])),


              title: Text(AngrySongList[i]['title'],
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(AngrySongList[i]['artist'],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              trailing: InkWell(child: SvgPicture.asset('assets/icons/player_mini_play.svg'),
                onTap: (){},),
            );
          }),
    );
  }
}

class MyCalmPlayList extends StatefulWidget {
  _MyCalmPlayList createState() => _MyCalmPlayList();
}

class _MyCalmPlayList extends State<MyCalmPlayList>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Calm PlayList',
        ),),
      body: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: CalmSongList.length,
          itemBuilder: (BuildContext context, int i){
            return ListTile(
              leading: (
                  Image.network(CalmSongList[i]['artwork'])),


              title: Text(CalmSongList[i]['title'],
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(CalmSongList[i]['artist'],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              trailing: InkWell(child: SvgPicture.asset('assets/icons/player_mini_play.svg'),
                onTap: (){},),
            );
          }),
    );
  }
}

class MyFearPlayList extends StatefulWidget {
  _MyFearPlayList createState() => _MyFearPlayList();
}

class _MyFearPlayList extends State<MyFearPlayList>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Fear PlayList',
        ),),
      body: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: FearSongList.length,
          itemBuilder: (BuildContext context, int i){
            return ListTile(
              leading: (
                  Image.network(FearSongList[i]['artwork'])),


              title: Text(FearSongList[i]['title'],
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(FearSongList[i]['artist'],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
              trailing: InkWell(child: SvgPicture.asset('assets/icons/player_mini_play.svg'),
                onTap: (){},),
            );
          }),
    );
  }
}

