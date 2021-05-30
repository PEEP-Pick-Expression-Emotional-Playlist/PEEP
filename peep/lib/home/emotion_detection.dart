import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class EmotionDetect extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _EmotionDetect();
}

class _EmotionDetect extends State<EmotionDetect>{


  @override
  void initState() {
    super.initState();
    readFile();
    print("done");
    initData();
  }

  void initData() async{
    var result = await sendImage();
    setState(() {
      emotion = result;
    });
}
  final WebSocketChannel channel = IOWebSocketChannel.connect('ws://localhost:3000');
  final ImagePicker imagePicker = ImagePicker();
  String emotion = "";

  Future<String> readFile() async{
    var key ='first';
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool firstCheck = pref.getBool(key);
    var dir = await getApplicationDocumentsDirectory();
    //bool fileExist = await File(dir.path+'test.jpg').exists();

    /*if(firstCheck == null || firstCheck == false || fileExist == false){
      pref.setBool(key, true);
      //var file = await DefaultAssetBundle.of(context).loadString('assets/test/test.jpg');
      var file = await DefaultAssetBundle.of(context).load('assets/test/test.jpg');
      //File(dir.path + '/test.jpg').writeAsStringSync(file);
        File(dir.path+'/test.jpg').writeAsBytes(file);
      //final bytes = await File(file).readAsBytes();
      var base64Image = base64.encode(bytes);

      return base64Image;
      print("fail");

    }else{
      var file = await File(dir.path + '/test.jpg').readAsBytes();
      var base64Image = base64.encode(file);
      print("image to byte success");
      return base64Image;
    }*/

    var file = await File(dir.path + '/test.jpg').readAsBytes();
    var base64Image = base64.encode(file);
    print("image to byte success");
    return base64Image;
  }

  Future<String> sendImage() async{
    print("send image start");
    var test = await readFile();
    print("read file done");
    channel.stream.listen((message){
      print("socket connected");
      channel.sink.add(test);
      channel.sink.close(status.goingAway);
      emotion = message;
    }, onDone: () => print("socket closed"));

    print(emotion);
    return emotion;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
      title: Text(
      'PEEP',
      style: TextStyle(color: Colors.grey),
      ),
      backgroundColor: Colors.white,
      elevation: 0.0,
      ),
      body: Container(
        child: Center(
          child: Text(
            emotion,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}


//log("take picture");
//String emo;
//emo = EmotionDetect().sendImage(_image) as String;
//print(emo);