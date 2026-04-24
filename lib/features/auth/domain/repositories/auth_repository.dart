import 'package:dartz/dartz.dart';
import 'package:local_business_directory/core/error/failures.dart';
import 'package:local_business_directory/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  });
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User?>> getCurrentUser();
}
