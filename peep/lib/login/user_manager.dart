import 'package:firebase_auth/firebase_auth.dart';

class UserManager {
  // Singleton pattern
  static UserManager _instance = UserManager._();
  static UserManager get instance => _instance;

  static User _user;

  set user(User user){
    _user = user;
  }

  UserManager._();

  User get user {
    if (_user == null) {
      return null;
    }
    return _user;
  }

  String get uid {
    if (_user == null) {
      return "";
    }
    return _user.uid;
  }

  String get name {
    if (_user == null) {
      return "";
    }
    return _user.displayName;
  }

  String get photo {
    if (_user == null) {
      return "";
    }
    return _user.photoURL;
  }

  String get email {
    if (_user == null) {
      return "";
    }
    return _user.email;
  }
}