import 'package:local_business_directory/features/business/domain/entities/interaction.dart';

class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.businessId,
    required super.userId,
    required super.userName,
    required super.rating,
    required super.comment,
    super.reply,
    required super.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'].toString(),
      businessId: json['business_id'].toString(),
      userId: json['user_id'].toString(),
      userName: json['user_name'] ?? 'Unknown',
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'],
      reply: json['reply'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class EnquiryModel extends Enquiry {
  const EnquiryModel({
    required super.id,
    required super.businessId,
    required super.userId,
    required super.userName,
    required super.subject,
    required super.message,
    super.reply,
    required super.createdAt,
  });

  factory EnquiryModel.fromJson(Map<String, dynamic> json) {
    return EnquiryModel(
      id: json['id'].toString(),
      businessId: json['business_id'].toString(),
      userId: json['user_id'].toString(),
      userName: json['user_name'] ?? 'Unknown',
      subject: json['subject'],
      message: json['message'],
      reply: json['reply'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
