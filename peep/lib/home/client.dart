import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:peep/home/emotion_manage.dart';
import 'package:peep/player/audio_manager.dart';
import 'package:peep/secret/secret.dart';
import 'package:peep/secret/secret_loader.dart';
import 'saveEmotion.dart';

class ClientTest {
  String testData;
  String emotionResult;

  Dio dio = new Dio();
  EmotionManger emotionManger = new EmotionManger();

  Future<void> getResult() async {
    try {
      Secret secret = await SecretLoader(secretPath: "secrets.json").load();
      var response = await dio.get(secret.webUrl+ '/result');
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
      Secret secret = await SecretLoader(secretPath: "secrets.json").load();
      Response response = await dio.post(
          secret.webUrl+'/peep/image/emotion_read',
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