import 'package:dio/dio.dart';

class ApiClient {
  late final Dio dio;
  String? _token;

  ApiClient({required String baseUrl}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 35),
        receiveTimeout: const Duration(seconds: 35),
        // Mencegah Dio melempar exception untuk status code 4xx agar logika checking manual provider tetap berjalan
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    // Interceptor untuk menyematkan JWT token secara otomatis di setiap request jika tersedia
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          print('API Error [${e.response?.statusCode}]: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  void updateToken(String? token) {
    _token = token;
  }

  void updateBaseUrl(String url) {
    dio.options.baseUrl = url;
  }
}
