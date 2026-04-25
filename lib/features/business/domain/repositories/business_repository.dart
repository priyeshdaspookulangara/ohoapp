import 'package:dartz/dartz.dart';
import 'package:local_business_directory/core/error/failures.dart';
import 'package:local_business_directory/features/business/domain/entities/business.dart';
import 'package:local_business_directory/features/business/domain/entities/interaction.dart';
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

  Future<Either<Failure, List<Review>>> getBusinessReviews(String businessId);
  Future<Either<Failure, void>> postReview(String businessId, double rating, String comment);
  Future<Either<Failure, void>> replyToReview(String reviewId, String reply);

  Future<Either<Failure, List<Enquiry>>> getBusinessEnquiries(String businessId);
  Future<Either<Failure, void>> sendEnquiry(String businessId, String subject, String message);
  Future<Either<Failure, void>> replyToEnquiry(String enquiryId, String reply);
}
