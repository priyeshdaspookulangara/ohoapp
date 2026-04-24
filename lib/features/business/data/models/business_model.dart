import 'package:local_business_directory/features/business/domain/entities/business.dart';

class BusinessModel extends Business {
  const BusinessModel({
    required super.id,
    required super.name,
    required super.category,
    required super.description,
    required super.address,
    required super.latitude,
    required super.longitude,
    super.phoneNumber,
    super.email,
    super.website,
    super.heroImageUrl,
    super.galleryUrls,
    super.workingHours,
    super.youtubeVideoUrl,
    super.isFeatured,
    super.ownerId,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['id'].toString(),
      name: json['name'],
      category: json['category'],
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      phoneNumber: json['phone_number'],
      email: json['email'],
      website: json['website'],
      heroImageUrl: json['hero_image_url'],
      galleryUrls: List<String>.from(json['gallery_urls'] ?? []),
      workingHours: json['working_hours'] != null
          ? Map<String, String>.from(json['working_hours'])
          : null,
      youtubeVideoUrl: json['youtube_video_url'],
      isFeatured: json['is_featured'] == 1 || json['is_featured'] == true,
      ownerId: json['owner_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phone_number': phoneNumber,
      'email': email,
      'website': website,
      'hero_image_url': heroImageUrl,
      'gallery_urls': galleryUrls,
      'working_hours': workingHours,
      'youtube_video_url': youtubeVideoUrl,
      'is_featured': isFeatured ? 1 : 0,
      'owner_id': ownerId,
    };
  }
}
