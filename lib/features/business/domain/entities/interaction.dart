import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String id;
  final String businessId;
  final String userId;
  final String userName;
  final double rating;
  final String comment;
  final String? reply;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.businessId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    this.reply,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, businessId, userId, userName, rating, comment, reply, createdAt];
}

class Enquiry extends Equatable {
  final String id;
  final String businessId;
  final String userId;
  final String userName;
  final String subject;
  final String message;
  final String? reply;
  final DateTime createdAt;

  const Enquiry({
    required this.id,
    required this.businessId,
    required this.userId,
    required this.userName,
    required this.subject,
    required this.message,
    this.reply,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, businessId, userId, userName, subject, message, reply, createdAt];
}
