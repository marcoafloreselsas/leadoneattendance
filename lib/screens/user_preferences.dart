import 'package:shared_preferences/shared_preferences.dart';
class UserPreferences {
  String userid = 'UserID';
  String userrole = 'Role';
  String usertoken = 'Token';

  saveUserId(int userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(userid, userId);
  }
  saveRole(String role) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(userrole, role);
  }
  saveToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(usertoken, token);
  }

  Future<int?> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final result = preferences.getInt(userid);
    return result;
  }
    Future<String?> getUserRole() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final result = preferences.getString(userrole);
    return result;
  }
    Future<String?> getUserToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final result = preferences.getString(usertoken);
    return result;
  }
}