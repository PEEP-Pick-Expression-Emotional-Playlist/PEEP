import 'package:flutter/material.dart';
import 'emotion_chart.dart';
import 'emotion_chart.dart';

class SaveEmotion{

  Future<void> setData(String emotionTest) async{

    List<String> str;
    str = emotionTest.split("<");

    switch(str[1]){
      case 'h1>Angry':
        print("Angry");

        break;
      case 'h1>Happy':
        print("Happy");

        break;
      case 'h1>Sad':
        print("Sad");

        break;
      case 'h1>Fearful':
        print("Fear");

        break;
      case 'h1>Neutral':
        print("Calm");

        break;
      default:
        print("default");
    }
    return "nothing";

  }
}
