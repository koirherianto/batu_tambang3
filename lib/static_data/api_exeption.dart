import 'package:dio/dio.dart';

class ApiExeption {
  Map<String, dynamic> getExeptionMessage(
      DioException exception, String lokasiError) {
    switch (exception.type) {
      case DioExceptionType.badCertificate:
        return {
          'catch': 'Koneksi Bermasalah',
          'message': 'Check your internet connection',
          'type': 'DioExceptionType: Bad Certificate',
          'lokasiError': lokasiError,
          'pesanError': exception.message ?? 'N/A'
        };

      case DioExceptionType.badResponse:
        return {
          'catch': 'Terjadi Kesalahan',
          'message': 'Check API URL or parameter are invalid',
          'type': 'DioExceptionType: Bad Response',
          'lokasiError': lokasiError,
          'pesanError': exception.message ?? 'N/A'
        };

      case DioExceptionType.cancel:
        return {
          'catch': 'Permintaan di tolak',
          'message': 'Check your internet connection',
          'type': 'DioExceptionType: Cancel',
          'lokasiError': lokasiError,
          'pesanError': exception.message ?? 'N/A'
        };

      case DioExceptionType.connectionError:
        return {
          'catch': 'Koneksi Bermasalah',
          'message': 'Check your internet connection',
          'type': 'DioExceptionType: Connection Error',
          'lokasiError': lokasiError,
          'pesanError': exception.message ?? 'N/A'
        };

      case DioExceptionType.connectionTimeout:
        return {
          'catch': 'Koneksi Bermasalah',
          'message': 'Check your internet connection',
          'type': 'DioExceptionType: Connection Timeout',
          'lokasiError': lokasiError,
          'pesanError': exception.message ?? 'N/A'
        };

      case DioExceptionType.receiveTimeout:
        return {
          'catch': 'Koneksi Bermasalah',
          'message': 'Check your internet connection',
          'type': 'DioExceptionType: Receive Timeout',
          'lokasiError': lokasiError,
          'pesanError': exception.message ?? 'N/A'
        };

      case DioExceptionType.sendTimeout:
        return {
          'catch': 'Koneksi Bermasalah',
          'message': 'Check your internet connection',
          'type': 'DioExceptionType: Send Timeout',
          'lokasiError': lokasiError,
          'pesanError': exception.message ?? 'N/A'
        };

      case DioExceptionType.unknown:
        return {
          'catch': 'Terjadi Kesalahan',
          'message': 'Check your internet connection',
          'type': 'DioExceptionType: Unknown',
          'lokasiError': lokasiError,
          'pesanError': exception.message ?? 'N/A'
        };

      default:
        return {
          'catch': 'Terjadi Kesalahan',
          'message': 'Check your internet connection',
          'type': 'DioExceptionType: Default',
          'lokasiError': lokasiError,
          'pesanError': exception.message ?? 'N/A'
        };
    }
  }
}




// import 'package:dio/dio.dart' as http_dio;

// class ErrorResponseApi {
//   // Saat server merespon, tapi dengan status salah, seperti 404, 503...
//   Map<String, String> response = {'catch': 'Terjadi Kesalahan'};
//   // terjadi ketika url dibuka batas waktu.
//   Map<String, String> connectTimeout = {'catch': 'Koneksi waktu habis'};
//   //  terjadi saat menerima batas waktu.
//   Map<String, String> receiveTimeout = {'catch': 'Jaringan Bermasalah'};
//   // terjadi ketika url dikirim batas waktu.
//   Map<String, String> sendTimeout = {'catch': 'Jaringan Bermasalah'};
//   // Ketika permintaan dibatalkan, dio akan melempar kesalahan dengan tipe ini.
//   Map<String, String> cancel = {'catch': 'Permintaan di tolak'};
//   // kesalahan default, Beberapa Kesalahan lainnya.
//   Map<String, String> other = {'catch': 'Terjadi Kesalahan'};
//   //kesalahan tidak diketahui
//   Map<String, String> tidakDiketahui = {'catch': 'Kesalahan Tidak diketahui'};

//   Map<String, String> responseDefault({
//     required http_dio.DioErrorType dioErrorType,
//     String lokasiError = '',
//   }) {
//     Map<String, String> res = {};
//     if (dioErrorType == http_dio.DioErrorType.response) {
//       res['catch'] = '${response['catch']!} $lokasiError';
//       return res;
//     } else if (dioErrorType == http_dio.DioErrorType.connectTimeout) {
//       res['catch'] = '${connectTimeout['catch']!} $lokasiError';
//       return res;
//     } else if (dioErrorType == http_dio.DioErrorType.receiveTimeout) {
//       res['catch'] = '${receiveTimeout['catch']!} $lokasiError';
//       return res;
//     } else if (dioErrorType == http_dio.DioErrorType.sendTimeout) {
//       res['catch'] = '${sendTimeout['catch']!} $lokasiError';
//       return res;
//     } else if (dioErrorType == http_dio.DioErrorType.cancel) {
//       res['catch'] = '${cancel['catch']!} $lokasiError';
//       return res;
//     } else if (dioErrorType == http_dio.DioErrorType.other) {
//       res['catch'] = '${other['catch']!} $lokasiError';
//       return res;
//     }

//     return tidakDiketahui;
//   }
// }
