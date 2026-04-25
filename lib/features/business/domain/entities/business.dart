import 'package:equatable/equatable.dart';

class Business extends Equatable {
  final String id;
  final String name;
  final String category;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final String? phoneNumber;
  final String? email;
  final String? website;
  final String? heroImageUrl;
  final List<String> galleryUrls;
  final Map<String, String>? workingHours;
  final List<String> achievements;
  final String? youtubeVideoUrl;
  final bool isFeatured;
  final String? ownerId;
  final double averageRating;
  final int reviewCount;

  const Business({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.phoneNumber,
    this.email,
    this.website,
    this.heroImageUrl,
    this.galleryUrls = const [],
    this.workingHours,
    this.achievements = const [],
    this.youtubeVideoUrl,
    this.isFeatured = false,
    this.ownerId,
    this.averageRating = 0.0,
    this.reviewCount = 0,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        description,
        address,
        latitude,
        longitude,
        phoneNumber,
        email,
        website,
        heroImageUrl,
        galleryUrls,
        workingHours,
        achievements,
        youtubeVideoUrl,
        isFeatured,
        ownerId,
        averageRating,
        reviewCount,
      ];
}
