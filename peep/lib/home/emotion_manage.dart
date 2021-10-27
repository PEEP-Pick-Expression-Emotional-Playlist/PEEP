import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Firebase에 현재 사용자 감정 입력 & 사용자 감정 빈도 값 축적
class EmotionManger{
  ///Firebase Auth 기반 사용자 id
  var uid;

  final user = FirebaseAuth.instance.currentUser;
  final databaseReference = FirebaseDatabase.instance.reference().child("emotion");

  Future<void> readWriteEmotion(String emotionField) async{

    ///emotion 빈도수
    int freqValue;

    if(user!=null){
      uid=user.uid;
    }

    await databaseReference.child(uid +"/"+ "freq" + emotionField).once().then((DataSnapshot snapshot){
      freqValue = snapshot.value;
    });
    ///데이터 값이 없는 감정일 경우 디폴트값 0 선언
    if(freqValue == null){
      await databaseReference.child(uid +"/"+ "freq").update({
        emotionField : 0
      });
      freqValue = 0;
    }

    print("freqvalue");
    print(freqValue);

    ///테스트를 위해 빈도수 기본 + 10
    freqValue = freqValue.toInt() + 10;
    print(freqValue);

    ///빈도수 값 업데이트
    await databaseReference.child(uid +"/"+ "freq").update({
      emotionField : freqValue
    });
    ///사용자 현재 감정 업데이트
    await databaseReference.child(uid +"/"+ "current").update({
      "emotion" : emotionField
    });
  }

  ///사용자 감정 각각의 빈도수 읽기
  Future<void> getEmotionFreq() async{
  }

  ///사용자 감정 DB 디폴트 값 설정
  Future<void> setEmotionFreqDefault() async{
    if(user!=null){
      uid=user.uid;
    }

    await databaseReference.child(uid +"/"+ "freq").update({
      "angry" : 0,
      "blue" : 0,
      "calm" : 0,
      "fear" : 0,
      "happy" : 0
    });
  }

}