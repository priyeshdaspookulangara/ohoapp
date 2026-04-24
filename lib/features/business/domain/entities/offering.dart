import 'package:equatable/equatable.dart';

class Offering extends Equatable {
  final String id;
  final String businessId;
  final String name;
  final String description;
  final double price;
  final bool isFlagship;
  final String? imageUrl;

  const Offering({
    required this.id,
    required this.businessId,
    required this.name,
    required this.description,
    required this.price,
    this.isFlagship = false,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, businessId, name, description, price, isFlagship, imageUrl];
}
