import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  String userId = "";
  String userName = "";
  String email = "";
  String password = "";
  List<String> groups = [];

  UserModel(
      {this.userId = "",
      this.userName = "",
      this.email = "",
      this.password = "",
      this.groups = const []});

  static String userNameKey = "UserNameSF";
  static String userEmailKey = "UserEmailSF";

  //* Set User Model
  static Future<bool> setUserNameSF(String userNameSF) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userNameSF);
  }

  static Future<bool> setUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  //* Get User Model
  Future<String?> getUserNameSF() async {
    SharedPreferences userShared = await SharedPreferences.getInstance();
    return userShared.getString(userNameKey);
  }

  Future<String?> getUserEmailSF() async {
    SharedPreferences userShared = await SharedPreferences.getInstance();
    return userShared.getString(userEmailKey);
  }
}
