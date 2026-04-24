import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_business_directory/core/network/auth_interceptor.dart';
import 'package:local_business_directory/features/auth/data/datasources/auth_data_source.dart';
import 'package:local_business_directory/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:local_business_directory/features/auth/domain/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final localDataSource = ref.watch(authLocalDataSourceProvider);
  dio.interceptors.add(AuthInterceptor(localDataSource: localDataSource));
  return dio;
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRemoteDataSourceImpl(dio: dio);
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return AuthLocalDataSourceImpl(sharedPreferences: sharedPreferences);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final localDataSource = ref.watch(authLocalDataSourceProvider);
  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

enum AuthStatus { initial, authenticating, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  AuthState({required this.status, this.errorMessage});

  factory AuthState.initial() => AuthState(status: AuthStatus.initial);
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState.initial());

  Future<void> login(String email, String password) async {
    state = AuthState(status: AuthStatus.authenticating);
    final result = await _repository.login(email, password);
    result.fold(
      (failure) => state = AuthState(status: AuthStatus.error, errorMessage: failure.message),
      (user) => state = AuthState(status: AuthStatus.authenticated),
    );
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    state = AuthState(status: AuthStatus.authenticating);
    final result = await _repository.register(
      email: email,
      password: password,
      name: name,
      role: role,
    );
    result.fold(
      (failure) => state = AuthState(status: AuthStatus.error, errorMessage: failure.message),
      (user) => state = AuthState(status: AuthStatus.authenticated),
    );
  }

  Future<void> logout() async {
    await _repository.logout();
    state = AuthState(status: AuthStatus.unauthenticated);
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
