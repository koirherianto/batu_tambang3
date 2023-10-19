import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  Future<bool> setLocalToken(String token) async {
    final SharedPreferences local = await SharedPreferences.getInstance();

    await local.setString('local_token', token);
    return Future.value(true);
  }

  Future<String> getLocalToken() async {
    final SharedPreferences local = await SharedPreferences.getInstance();

    final String? token = local.getString('local_token');
    if (token != null && token != '') return Future.value(token);
    return Future.value('');
  }

  Future<bool> isLogin() async {
    final SharedPreferences local = await SharedPreferences.getInstance();
    // await Database().initialDatabase();
    final String? token = local.getString('local_token');
    if (token != null && token != '') return Future.value(true);
    return Future.value(false);
  }

  Future<bool> deleteLocalToken() async {
    final SharedPreferences local = await SharedPreferences.getInstance();

    await local.setString('local_token', '');
    return Future.value(true);
  }
}
