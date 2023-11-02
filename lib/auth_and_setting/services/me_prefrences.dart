import 'package:batu_tambang/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MePrefrences {
  UserModel? userModel;

  Future<bool> setMe({
    int id = 0,
    String namaLengkap = '',
    String namaPanggilan = '',
    String email = '',
    String role = '',
    String urlProfil = '',
  }) async {
    final SharedPreferences local = await SharedPreferences.getInstance();

    await local.setInt('meId', id);
    await local.setString('meNamaLengkap', namaLengkap);
    await local.setString('meNamaPanggilan', namaPanggilan);
    await local.setString('meEmail', email);
    await local.setString('meRole', role);
    await local.setString('meUrlProfil', urlProfil);

    userModel = UserModel(
      id: id,
      namaLengkap: namaLengkap,
      namaPanggilan: namaPanggilan,
      email: email,
      role: role,
    );

    return Future<bool>.value(true);
  }

  Future<Map<String, dynamic>> getMe() async {
    final SharedPreferences local = await SharedPreferences.getInstance();

    Map<String, dynamic> me = {
      'id': local.getInt('meId'),
      'namaLengkap': local.getString('meNamaLengkap'),
      'namaPanggilan': local.getString('meNamaPanggilan'),
      'email': local.getString('meEmail'),
      'role': local.getString('meRole'),
      'urlProfil': local.getString('meUrlProfil'),
    };

    if (me['id'] == null || me['id'] == 0) {
      me['id'] = 0;
    }

    userModel = UserModel(
      id: local.getInt('meId') ?? 0,
      namaLengkap: local.getString('meNamaLengkap') ?? '',
      namaPanggilan: local.getString('meNamaPanggilan') ?? '',
      email: local.getString('meEmail') ?? '',
      role: local.getString('meRole') ?? '',
      photoUrl: local.getString('meUrlProfil'),
    );

    return Future<Map<String, dynamic>>.value(me);
  }

  Future<UserModel> getModelMe() async {
    final SharedPreferences local = await SharedPreferences.getInstance();

    UserModel userModel = UserModel(
      id: local.getInt('meId') ?? 0,
      namaLengkap: local.getString('meNamaLengkap') ?? '',
      namaPanggilan: local.getString('meNamaPanggilan') ?? '',
      email: local.getString('meEmail') ?? '',
      role: local.getString('meRole') ?? '',
      photoUrl: local.getString('meUrlProfil'),
    );

    this.userModel = userModel;

    return userModel;
  }

  Future<bool> deleteMe() async {
    final SharedPreferences local = await SharedPreferences.getInstance();

    await local.remove('meId');
    await local.remove('meNamaLengkap');
    await local.remove('meNamaPanggilan');
    await local.remove('meEmail');
    await local.remove('meRole');
    await local.remove('meUrlProfil');

    userModel = null;

    return true;
  }
}
