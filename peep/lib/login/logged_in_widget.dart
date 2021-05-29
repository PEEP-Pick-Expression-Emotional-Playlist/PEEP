import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:peep/login/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';

class LoggedInWidget extends StatelessWidget{
  final fb = FirebaseDatabase.instance;
  @override
  Widget build(BuildContext context){
    final ref = fb.reference();
    final user = FirebaseAuth.instance.currentUser;
    var name, photo, email, uid;
    if(user!=null){
      uid=user.uid;
      name=user.displayName;
      photo=user.photoURL;
      email=user.email;
    }
    ref.child("user").child("uid").set(uid);//db에 user필드 만들고 현재 user의 uid입력

    return Container(
      alignment: Alignment.center,
      color: Colors.blueGrey.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Logged In',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height:8),
          CircleAvatar(//user 이미지
            maxRadius: 25,
            backgroundImage: NetworkImage(photo),
          ),
          SizedBox(height:8),
           Text(//user 이름
            name,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height:8),
          Text(//user email
            email,
            style: TextStyle(color: Colors.white),
          ),
          
          SizedBox(height: 8),
          ElevatedButton(//logout 버튼
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();//logout method 호출
            },
            child: Text('Logout'),
          ),
          ElevatedButton(//logout 버튼
            onPressed: () {
              ref.child("user").child("playlist").set("music1");//(테스트) 누르면 플레이리스트에 곡 추가
            },
            child: Text('add'),
          )
        ],
      ),
    );
  }
}