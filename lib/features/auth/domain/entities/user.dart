import 'package:equatable/equatable.dart';

enum UserRole {
  customer,
  businessOwner,
  admin,
}

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? phoneNumber;
  final String? profileImageUrl;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.phoneNumber,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [id, email, name, role, phoneNumber, profileImageUrl];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.customer,
      ),
      phoneNumber: json['phone_number'],
      profileImageUrl: json['profile_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.name,
      'phone_number': phoneNumber,
      'profile_image_url': profileImageUrl,
    };
  }
}
