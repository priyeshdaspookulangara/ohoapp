import 'package:dio/dio.dart';
import 'package:local_business_directory/features/auth/data/datasources/auth_data_source.dart';

class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource localDataSource;

  AuthInterceptor({required this.localDataSource});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await localDataSource.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Handle logout or refresh token logic here
      localDataSource.clearToken();
    }
    super.onError(err, handler);
  }
}
