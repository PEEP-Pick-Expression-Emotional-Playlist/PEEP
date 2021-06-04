import 'package:firebase_database/firebase_database.dart';

class DBManager {
  // Singleton pattern
  static DBManager _instance = DBManager._();
  static DBManager get instance => _instance;

  static DatabaseReference _ref;

  DBManager._(){
    _ref = FirebaseDatabase.instance.reference();
  }

  DatabaseReference get ref {
    if (_ref == null) {
      _ref = FirebaseDatabase.instance.reference();
    }
    return _ref;
  }
}