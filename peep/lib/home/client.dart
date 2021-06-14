import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../player/player_controller.dart';
import '../sub/home_page.dart';
import '../sub/home_page.dart';
import '../sub/home_page.dart';
import 'saveEmotion.dart';
import 'package:peep/sub/home_page.dart';
import 'saveEmotion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientTest {
  Dio dio = new Dio();
  String testData;
  String emotionResult;
  Future<void> getResult() async {
    try {
      var response = await dio.get('http://10.0.2.2:5000/result');
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
          'http://10.0.2.2:5000/peep/image/emotion_read',
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
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection("emotion").doc("freq").get().then((DocumentSnapshot ds) async{
      freqValue = ds[emotionField];
    });
    print("freqvalue");
    print(freqValue);
    freqValue = freqValue + 10;
    print(freqValue);
    await firestore.collection("emotion").doc("freq").update({emotionField:freqValue});
  }

}