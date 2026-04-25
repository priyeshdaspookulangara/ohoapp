import 'package:dartz/dartz.dart';
import 'package:local_business_directory/core/error/failures.dart';
import 'package:local_business_directory/features/business/data/datasources/business_remote_data_source.dart';
import 'package:local_business_directory/features/business/data/models/business_model.dart';
import 'package:local_business_directory/features/business/data/models/offering_model.dart';
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
    try {
      final results = await remoteDataSource.getOfferings(businessId);
      return Right(results);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Offering>> addOffering(Offering offering) async {
    try {
      final model = OfferingModel(
        id: offering.id,
        businessId: offering.businessId,
        name: offering.name,
        description: offering.description,
        price: offering.price,
        isFlagship: offering.isFlagship,
        imageUrl: offering.imageUrl,
      );
      final result = await remoteDataSource.addOffering(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Offering>> updateOffering(Offering offering) async {
    try {
      final model = OfferingModel(
        id: offering.id,
        businessId: offering.businessId,
        name: offering.name,
        description: offering.description,
        price: offering.price,
        isFlagship: offering.isFlagship,
        imageUrl: offering.imageUrl,
      );
      final result = await remoteDataSource.updateOffering(model);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Review>>> getBusinessReviews(String businessId) async {
    try {
      final results = await remoteDataSource.getReviews(businessId);
      return Right(results);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> postReview(String businessId, double rating, String comment) async {
    try {
      await remoteDataSource.postReview(businessId, rating, comment);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> replyToReview(String reviewId, String reply) async {
    try {
      await remoteDataSource.replyToReview(reviewId, reply);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Enquiry>>> getBusinessEnquiries(String businessId) async {
    try {
      final results = await remoteDataSource.getEnquiries(businessId);
      return Right(results);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendEnquiry(String businessId, String subject, String message) async {
    try {
      await remoteDataSource.sendEnquiry(businessId, subject, message);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> replyToEnquiry(String enquiryId, String reply) async {
    try {
      await remoteDataSource.replyToEnquiry(enquiryId, reply);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
