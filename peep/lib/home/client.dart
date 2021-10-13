import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:peep/login/user_manager.dart';
import '../player/player_controller.dart';
import '../sub/home_page.dart';
import '../sub/home_page.dart';
import '../sub/home_page.dart';
import 'saveEmotion.dart';
import 'package:peep/sub/home_page.dart';
import 'saveEmotion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClientTest {
  Dio dio = new Dio();
  String testData;
  String emotionResult;
  Future<void> getResult() async {
    try {
      var response = await dio.get('http://3.38.93.39:5000/result');
      print(response);
      testData = response.data;
      print(testData);
      emotionResult = await SaveEmotion().setData(testData).then((value) =>
      AudioManager.emotion = value
      );
    } catch (e) {
      print(e);
    }
  }
  Future<String> test(String imageTest) async {

    try {
      Response response = await dio.post(
          'http://3.38.93.39:5000/peep/image/emotion_read',
          data: {
            'image': json.encode(imageTest)
          }
      );
      return emotionResult;
    } catch (e) {
      Exception(e);
    } finally {
      print("post done");
      await getResult();
      //print("emotionResult");
      //print(emotionResult);
      //print("emotionResult2");
      await readAndWrite(emotionResult);
      dio.close();
    }
    return emotionResult;
  }

  Future<void> readAndWrite(String emotionField) async{
    int freqValue;
    // FirebaseFirestore firestore = FirebaseFirestore.instance;
    var uid;
    final user = FirebaseAuth.instance.currentUser;
    final databaseReference = FirebaseDatabase.instance.reference().child("emotion");

    if(user!=null){
      uid=user.uid;
    }

    await databaseReference.child(uid +"/"+ "freq" + emotionField).once().then((DataSnapshot snapshot){
      freqValue = snapshot.value;
    });
    // await firestore.collection("emotion").doc("freq").get().then((DocumentSnapshot ds) async{
    //   freqValue = ds[emotionField];
    // });
    print("freqvalue");
    print(freqValue);
    freqValue = freqValue + 10;
    print(freqValue);
    
    await databaseReference.child(uid +"/"+ "freq").update({
      emotionField : freqValue
    });
    await databaseReference.child(uid +"/"+ "current").update({
      "emotion" : emotionField
    });
    // await firestore.collection("emotion").doc("freq").update({emotionField:freqValue});
    // await firestore.collection("current").doc("state").update({"emotion":emotionField});
  }

}