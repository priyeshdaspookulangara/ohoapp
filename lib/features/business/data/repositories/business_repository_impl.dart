import 'package:dartz/dartz.dart';
import 'package:local_business_directory/core/error/failures.dart';
import 'package:local_business_directory/features/business/data/datasources/business_remote_data_source.dart';
import 'package:local_business_directory/features/business/data/models/business_model.dart';
import 'package:local_business_directory/features/business/domain/entities/business.dart';
import 'package:local_business_directory/features/business/domain/entities/offering.dart';
import 'package:local_business_directory/features/business/domain/repositories/business_repository.dart';

class BusinessRepositoryImpl implements BusinessRepository {
  final BusinessRemoteDataSource remoteDataSource;

  BusinessRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Business>>> searchBusinesses({
    String? query,
    String? category,
    double? latitude,
    double? longitude,
    double? radius,
  }) async {
    try {
      final results = await remoteDataSource.searchBusinesses(
        query: query,
        category: category,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
      );
      return Right(results);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Business>> getBusinessById(String id) async {
    try {
      final business = await remoteDataSource.getBusinessById(id);
      return Right(business);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Business>> createBusiness(Business business) async {
    try {
      final model = BusinessModel(
        id: business.id,
        name: business.name,
        category: business.category,
        description: business.description,
        address: business.address,
        latitude: business.latitude,
        longitude: business.longitude,
        phoneNumber: business.phoneNumber,
        email: business.email,
        website: business.website,
        heroImageUrl: business.heroImageUrl,
        galleryUrls: business.galleryUrls,
        workingHours: business.workingHours,
        youtubeVideoUrl: business.youtubeVideoUrl,
        isFeatured: business.isFeatured,
        ownerId: business.ownerId,
      );
      final result = await remoteDataSource.createBusiness(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Business>> updateBusiness(Business business) async {
    try {
      final model = BusinessModel(
        id: business.id,
        name: business.name,
        category: business.category,
        description: business.description,
        address: business.address,
        latitude: business.latitude,
        longitude: business.longitude,
        phoneNumber: business.phoneNumber,
        email: business.email,
        website: business.website,
        heroImageUrl: business.heroImageUrl,
        galleryUrls: business.galleryUrls,
        workingHours: business.workingHours,
        youtubeVideoUrl: business.youtubeVideoUrl,
        isFeatured: business.isFeatured,
        ownerId: business.ownerId,
      );
      final result = await remoteDataSource.updateBusiness(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Business>>> getOwnedBusinesses() async {
    try {
      final results = await remoteDataSource.getOwnedBusinesses();
      return Right(results);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Offering>>> getBusinessOfferings(String businessId) async {
    // To be implemented
    return const Right([]);
  }
}
