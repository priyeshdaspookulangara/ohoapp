import 'package:local_business_directory/features/business/domain/entities/offering.dart';

class OfferingModel extends Offering {
  const OfferingModel({
    required super.id,
    required super.businessId,
    required super.name,
    required super.description,
    required super.price,
    super.isFlagship,
    super.imageUrl,
  });

  factory OfferingModel.fromJson(Map<String, dynamic> json) {
    return OfferingModel(
      id: json['id'].toString(),
      businessId: json['business_id'].toString(),
      name: json['name'],
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      isFlagship: json['is_flagship'] == 1 || json['is_flagship'] == true,
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_id': businessId,
      'name': name,
      'description': description,
      'price': price,
      'is_flagship': isFlagship ? 1 : 0,
      'image_url': imageUrl,
    };
  }
}
