import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'saveEmotion.dart';


class ClientTest {
  Dio dio = new Dio();
  String testData;
  Future<void> getResult() async {
    try {
      var response = await dio.get('http://10.0.2.2:5000/result');
      print(response);
      testData = response.data;
      print(testData);
      await SaveEmotion().setData(testData);
    } catch (e) {
      print(e);
    }
  }
  Future<bool> test(String imageTest) async {
    try {
      Response response = await dio.post(
          'http://10.0.2.2:5000/peep/image/emotion_read',
          data: {
            'image': json.encode(imageTest)
          }
      );
      return true;
    } catch (e) {
      Exception(e);
    } finally {
      print("post done");
      await getResult();
      dio.close();
    }
    return false;
  }

}