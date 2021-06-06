import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'client.dart';
import 'package:peep/player/music_player_page.dart';


class EmotionDetect extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _EmotionDetect();
}
class _EmotionDetect extends State<EmotionDetect>{

  final ImagePicker imagePicker = ImagePicker();

  File _image;
  String emotionResult;
  var resultImg;



  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async{
    //await readFile();
    //await readFile().then((value) => resultImg);
    await readFile();
    Navigator.push(
      //getImage(ImageSource.camera);
        context,
        MaterialPageRoute(builder: (context) => MusicPlayerPage()));
    print("init state done");
  }

  Future<void> takePicture() async{
    print("take picture");
    final imageFile = await imagePicker.getImage(source: ImageSource.gallery);
    if(imageFile == null){
      print("no image");
      return;
    }
    //final appDir = await getApplicationDocumentsDirectory();
    //await File(appDir.path+'/test.jpg').create(recursive: true);
    //final File newImage = await imageFile.
    setState(() {
      _image = File(imageFile.path);
    });
    print("took pic");
  }

  Future<void> readFile() async{
    await takePicture();
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

    // var file = await File(dir.path + '/test.jpg').readAsBytes();
    var file = await _image.readAsBytes();
    var base64Image = base64.encode(file);
    print("image to byte success");
    //await ClientTest().getHttp();
    await ClientTest().test(base64Image);
    /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ClientTest(base64Image)))
    ;*/
    //return base64Image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: SvgPicture.asset('assets/itd/ITD_logo_leftside.svg'),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Center(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                CircularProgressIndicator(),
              ],
            ),
          )
      ),
    );
  }

}
