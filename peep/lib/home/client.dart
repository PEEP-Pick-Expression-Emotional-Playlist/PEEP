import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:peep/home/emotion_manage.dart';
import '../player/player_controller.dart';
import 'saveEmotion.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClientTest {
  String testData;
  String emotionResult;

  Dio dio = new Dio();
  EmotionManger emotionManger = new EmotionManger();

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

      await emotionManger.readWriteEmotion(emotionResult);
      dio.close();
    }
    return emotionResult;
  }

}