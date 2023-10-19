import 'dart:convert';

import 'package:batu_tambang/auth/services/token_service.dart';
import 'package:batu_tambang/static_data/api_exeption.dart';
import 'package:batu_tambang/static_data/url_api.dart';
import 'package:dio/dio.dart' as http_dio;
import 'package:flutter/widgets.dart';

class AuthApi {
  String baseURL = URLAPI.apiURL;
  http_dio.Dio dio = http_dio.Dio(
    http_dio.BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {'Accept': 'application/json'},
    ),
  );

  ApiExeption apiExeption = ApiExeption();

  Future<Map<String, dynamic>> registerApi({
    String namaLengkap = '',
    String namaPanggilan = '',
    String email = '',
    String password = '',
  }) async {
    try {
      dio.options.headers['Accept'] = 'application/json';

      final String url = '${baseURL}auth/register';

      http_dio.Response response = await dio.post(url, data: {
        'nama_lengkap': namaLengkap,
        'nama_panggilan': namaPanggilan,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final responeBody = jsonDecode(jsonEncode(response.data));
        return Future.value(responeBody);
      } else {
        throw http_dio.DioException(
          requestOptions: http_dio.RequestOptions(path: url),
          response: response,
          type: http_dio.DioExceptionType.connectionError,
        );
      }
    } on http_dio.DioException catch (ex) {
      Map<String, dynamic> exeption =
          apiExeption.getExeptionMessage(ex, 'register');
      debugPrintApi(exeption);
      return {'success': false, 'exeption': exeption};
    }
  }

  Future<Map<String, dynamic>> loginApi({
    String email = '',
    String password = '',
  }) async {
    try {
      dio.options.headers['Accept'] = 'application/json';

      final String url = '${baseURL}auth/login';

      http_dio.Response response = await dio.post(url, data: {
        'email': email,
        'password': password,
        'device': 'redmi note 7'
      });

      if (response.statusCode == 200) {
        final responeBody = jsonDecode(jsonEncode(response.data));
        return Future.value(responeBody);
      } else {
        throw http_dio.DioException(
          requestOptions: http_dio.RequestOptions(path: url),
          response: response,
          type: http_dio.DioExceptionType.connectionError,
        );
      }
    } on http_dio.DioException catch (ex) {
      Map<String, dynamic> exeption =
          apiExeption.getExeptionMessage(ex, 'login');
      debugPrintApi(exeption);
      return {'success': false, 'exeption': exeption};
    }
  }

  Future<Map<String, dynamic>> logoutApi(TokenService tokenService) async {
    try {
      String token = await tokenService.getLocalToken();

      dio.options.headers["authorization"] = "Bearer $token";
      final String url = '${baseURL}auth/logout';

      http_dio.Response response = await dio.post(url);

      if (response.statusCode == 200) {
        final responeBody = jsonDecode(jsonEncode(response.data));
        return Future.value(responeBody);
      } else {
        throw http_dio.DioException(
          requestOptions: http_dio.RequestOptions(path: url),
          response: response,
          type: http_dio.DioExceptionType.connectionError,
        );
      }
    } on http_dio.DioException catch (ex) {
      Map<String, dynamic> exeption =
          apiExeption.getExeptionMessage(ex, 'register');
      debugPrintApi(exeption);
      return {'success': false, 'exeption': exeption};
    }
  }

  // Future updatePassword({
  //   required String passLama,
  //   required String passBaru,
  //   required String passConfirm,
  // }) async {
  //   try {
  //     String token = await getLocalToken();

  //     dio.options.headers["authorization"] = "Bearer $token";
  //     dio.options.headers['Accept'] = 'application/json';

  //     String url = '${baseURL}auth/updatePassword';

  //     http_dio.Response response = await dio.put(
  //       url,
  //       data: {
  //         '_method': 'PUT',
  //         'passwordLama': passLama,
  //         'passwordBaru': passBaru,
  //         'passwordConfirm': passConfirm
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final responeBody = jsonDecode(jsonEncode(response.data));
  //       return Future.value(responeBody);
  //     } else {
  //       throw http_dio.DioException(
  //         requestOptions: http_dio.RequestOptions(path: url),
  //         response: response,
  //         type: http_dio.DioExceptionType.connectionError,
  //       );
  //     }
  //   } on http_dio.DioException catch (ex) {
  //     List<String> exeption = apiExeption.getExeptionMessage(ex, 'register');
  //     debugPrintApi(exeption);
  //     return null;
  //   }
  // }

  // Future updateProfile({
  //   required int? id,
  //   required String newName,
  //   required String newContact,
  //   required String newEmail,
  //   required String newAlamat,
  // }) async {
  //   try {
  //     String token = await getLocalToken();

  //     dio.options.headers["authorization"] = "Bearer $token";
  //     dio.options.headers['Accept'] = 'application/json';

  //     http_dio.Response response = await dio.put(
  //       '${baseURL}auth/update/$id',
  //       data: {
  //         '_method': 'PUT',
  //         'name': newName,
  //         'contact': newContact,
  //         'email': newEmail,
  //         'alamat': newAlamat
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final responeBody = jsonDecode(jsonEncode(response.data));
  //       return Future.value(responeBody);
  //     }
  //     return errorResponseApi.tidakDiketahui;
  //   } on http_dio.DioException catch (ex) {
  //     List<String> exeption = apiExeption.getExeptionMessage(ex, 'register');
  //     debugPrintApi(exeption);

  //     return null;
  //   }
  // }

  // Future meApi() async {
  //   try {
  //     String token = await getLocalToken();

  //     dio.options.headers["authorization"] = "Bearer $token";
  //     dio.options.headers['Accept'] = 'application/json';

  //     http_dio.Response response = await dio.post('${baseURL}auth/me');

  //     if (response.statusCode == 200) {
  //       final responeBody = jsonDecode(jsonEncode(response.data));
  //       return Future.value(responeBody);
  //     }
  //     return errorResponseApi.tidakDiketahui;
  //   } on http_dio.DioException catch (ex) {
  //     List<String> exeption = apiExeption.getExeptionMessage(ex, 'register');
  //     debugPrintApi(exeption);

  //     return null;
  //   }
  // }

  // Future updateFoto({required int idRelawan, File? gambarProfil}) async {
  //   try {
  //     String token = await getLocalToken();

  //     dio.options.headers["authorization"] = "Bearer $token";
  //     dio.options.headers['Accept'] = 'application/json';

  //     http_dio.FormData formImage = http_dio.FormData.fromMap({
  //       'gambar_profil': gambarProfil != null
  //           ? await http_dio.MultipartFile.fromFile(gambarProfil.path)
  //           : null
  //     });

  //     http_dio.Response response = await dio
  //         .post('${baseURL}relawans/updateimage/$idRelawan', data: formImage);

  //     if (response.statusCode == 200) {
  //       final responeBody = jsonDecode(jsonEncode(response.data));
  //       return Future.value(responeBody);
  //     }
  //     return errorResponseApi.tidakDiketahui;
  //   } on http_dio.DioException catch (ex) {
  //     List<String> exeption = apiExeption.getExeptionMessage(ex, 'register');
  //     debugPrintApi(exeption);

  //     return null;
  //   }
  // }

  void debugPrintApi(Map<String, dynamic> exeption) {
    debugPrint('======================');
    debugPrint(exeption['type']);
    debugPrint(exeption['lokasiError']);
    debugPrint(exeption['pesanError']);
    debugPrint('======================');
  }
}
