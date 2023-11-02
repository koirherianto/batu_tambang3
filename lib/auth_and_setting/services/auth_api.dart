import 'dart:convert';
import 'dart:io';

import 'package:batu_tambang/auth_and_setting/services/token_service.dart';
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

  Future updateProfile({
    required String namaLengkap,
    required String namaPanggilan,
    required String email,
    required TokenService tokenService,
  }) async {
    try {
      String token = await tokenService.getLocalToken();
      dio.options.headers["authorization"] = "Bearer $token";
      final String url = '${baseURL}auth/updateProfil';

      http_dio.Response response = await dio.post(
        url,
        data: {
          'nama_lengkap': namaLengkap,
          'nama_panggilan': namaPanggilan,
          'email': email
        },
      );

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
          apiExeption.getExeptionMessage(ex, 'logout');
      debugPrintApi(exeption);
      return {'success': false, 'exeption': exeption};
    }
  }

  Future<Map<String, dynamic>> updatePassword({
    required String passLama,
    required String passBaru,
    required String passConfirm,
    required TokenService tokenService,
  }) async {
    try {
      String token = await tokenService.getLocalToken();

      dio.options.headers["authorization"] = "Bearer $token";

      String url = '${baseURL}auth/updatePassword';

      http_dio.Response response = await dio.post(
        url,
        data: {
          'password_lama': passLama,
          'password_baru': passBaru,
          'password_confirm': passConfirm
        },
      );

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
          apiExeption.getExeptionMessage(ex, 'update password');
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
      } else if (response.statusCode == 401) {
        return {'success': true, 'unauthenticated': response.data};
      } else {
        throw http_dio.DioException(
          requestOptions: http_dio.RequestOptions(path: url),
          response: response,
          type: http_dio.DioExceptionType.connectionError,
        );
      }
    } on http_dio.DioException catch (ex) {
      Map<String, dynamic> exeption =
          apiExeption.getExeptionMessage(ex, 'logout');
      debugPrintApi(exeption);
      return {'success': false, 'exeption': exeption};
    }
  }

  Future<Map<String, dynamic>> meApi({
    required TokenService tokenService,
  }) async {
    try {
      String token = await tokenService.getLocalToken();

      dio.options.headers["authorization"] = "Bearer $token";
      final String url = '${baseURL}auth/me';
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
          apiExeption.getExeptionMessage(ex, 'Me API');
      debugPrintApi(exeption);
      return {'success': false, 'exeption': exeption};
    }
  }

  Future updateFoto({
    File? gambarProfil,
    required TokenService tokenService,
  }) async {
    try {
      final String token = await tokenService.getLocalToken();

      dio.options.headers["authorization"] = "Bearer $token";

      http_dio.FormData formImage = http_dio.FormData.fromMap({
        'gambar_profil': gambarProfil != null
            ? await http_dio.MultipartFile.fromFile(gambarProfil.path)
            : null
      });

      final String url = '${baseURL}auth/updateimage';
      http_dio.Response response = await dio.post(url, data: formImage);

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
          apiExeption.getExeptionMessage(ex, 'Me API');
      debugPrintApi(exeption);
      return {'success': false, 'exeption': exeption};
    }
  }

  void debugPrintApi(Map<String, dynamic> exeption) {
    debugPrint('======================');
    debugPrint(exeption['type']);
    debugPrint(exeption['lokasiError']);
    debugPrint(exeption['pesanError']);
    debugPrint('======================');
  }
}
