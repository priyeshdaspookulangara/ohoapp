import 'package:dartz/dartz.dart';
import 'package:local_business_directory/core/error/failures.dart';
import 'package:local_business_directory/features/business/domain/entities/business.dart';
import 'package:local_business_directory/features/business/domain/entities/offering.dart';

abstract class BusinessRepository {
  Future<Either<Failure, List<Business>>> searchBusinesses({
    String? query,
    String? category,
    double? latitude,
    double? longitude,
    double? radius,
  });

  Future<Either<Failure, Business>> getBusinessById(String id);

  Future<Either<Failure, Business>> createBusiness(Business business);

  Future<Either<Failure, Business>> updateBusiness(Business business);

  Future<Either<Failure, List<Business>>> getOwnedBusinesses();

  Future<Either<Failure, List<Offering>>> getBusinessOfferings(String businessId);
}
