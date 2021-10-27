
class SaveEmotion{
  Future<String> setData(String emotionTest) async{

    List<String> str;
    str = emotionTest.split("<");

    switch(str[1]){
      case 'h1>Angry':
        print("Angry");
        return "angry";
        break;
      case 'h1>Happy':
        print("Happy");
        return "happy";
        break;
      case 'h1>Sad':
        print("Blue");
        return "blue";
        break;
      case 'h1>Fearful':
        print("Fear");
        return "fear";
        break;
      case 'h1>Neutral':
        print("Calm");
        return "calm";
        break;
      default:
        print("default");
    }
    return "nothing";
  }

}
