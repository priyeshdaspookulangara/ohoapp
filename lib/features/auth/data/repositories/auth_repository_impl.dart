import 'package:dartz/dartz.dart';
import 'package:local_business_directory/core/error/failures.dart';
import 'package:local_business_directory/features/auth/data/datasources/auth_data_source.dart';
import 'package:local_business_directory/features/auth/data/models/user_model.dart';
import 'package:local_business_directory/features/auth/domain/entities/user.dart';
import 'package:local_business_directory/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final authResponse = await remoteDataSource.login(email, password);
      await localDataSource.cacheUser(authResponse.user);
      await localDataSource.cacheToken(authResponse.token);
      return Right(authResponse.user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    try {
      final authResponse = await remoteDataSource.register(
        email: email,
        password: password,
        name: name,
        role: role.name,
      );
      await localDataSource.cacheUser(authResponse.user);
      await localDataSource.cacheToken(authResponse.token);
      return Right(authResponse.user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearToken();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
