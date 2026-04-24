import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:local_business_directory/core/util/config.dart';
import 'package:local_business_directory/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthResponse {
  final UserModel user;
  final String token;

  AuthResponse({required this.user, required this.token});
}

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(String email, String password);
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String name,
    required String role,
  });
}

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthResponse> login(String email, String password) async {
    final response = await dio.post('${AppConfig.baseUrl}/login', data: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      return AuthResponse(
        user: UserModel.fromJson(response.data['user']),
        token: response.data['token'],
      );
    } else {
      throw Exception('Failed to login');
    }
  }

  @override
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    final response = await dio.post('${AppConfig.baseUrl}/register', data: {
      'email': email,
      'password': password,
      'name': name,
      'role': role,
    });

    if (response.statusCode == 201) {
      return AuthResponse(
        user: UserModel.fromJson(response.data['user']),
        token: response.data['token'],
      );
    } else {
      throw Exception('Failed to register');
    }
  }
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cachedTokenKey = 'CACHED_TOKEN';
  static const String cachedUserKey = 'CACHED_USER';

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheToken(String token) async {
    await sharedPreferences.setString(cachedTokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(cachedTokenKey);
  }

  @override
  Future<void> clearToken() async {
    await sharedPreferences.remove(cachedTokenKey);
    await sharedPreferences.remove(cachedUserKey);
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await sharedPreferences.setString(
      cachedUserKey,
      json.encode(user.toJson()),
    );
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = sharedPreferences.getString(cachedUserKey);
    if (jsonString != null) {
      return UserModel.fromJson(json.decode(jsonString));
    }
    return null;
  }
}
