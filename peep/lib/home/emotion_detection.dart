import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class EmotionDetect{
  final WebSocketChannel channel = IOWebSocketChannel.connect('ws://localhost:3000');
  String emotion;
  Future<String> sendImage(File image) async{
    List<int> imageBytes = image.readAsBytesSync();
    var base64Image = base64Encode(imageBytes);
    channel.stream.listen((message){
      log("connected");
      channel.sink.add(base64Image);
      channel.sink.close(status.goingAway);
      emotion = message;
    }, onDone: () => print("socket closed"));

    log(emotion);
    return emotion;
  }
  
}


//log("take picture");
//String emo;
//emo = EmotionDetect().sendImage(_image) as String;
//print(emo);