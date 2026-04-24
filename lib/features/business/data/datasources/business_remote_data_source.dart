import 'package:dio/dio.dart';
import 'package:local_business_directory/core/util/config.dart';
import 'package:local_business_directory/features/business/data/models/business_model.dart';

abstract class BusinessRemoteDataSource {
  Future<List<BusinessModel>> searchBusinesses({
    String? query,
    String? category,
    double? latitude,
    double? longitude,
    double? radius,
  });
  Future<BusinessModel> getBusinessById(String id);
  Future<BusinessModel> createBusiness(BusinessModel business);
  Future<BusinessModel> updateBusiness(BusinessModel business);
  Future<List<BusinessModel>> getOwnedBusinesses();
}

class BusinessRemoteDataSourceImpl implements BusinessRemoteDataSource {
  final Dio dio;

  BusinessRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<BusinessModel>> searchBusinesses({
    String? query,
    String? category,
    double? latitude,
    double? longitude,
    double? radius,
  }) async {
    final response = await dio.get('${AppConfig.baseUrl}/search', queryParameters: {
      if (query != null) 'q': query,
      if (category != null) 'category': category,
      if (latitude != null) 'lat': latitude,
      if (longitude != null) 'lng': longitude,
      if (radius != null) 'radius': radius,
    });

    if (response.statusCode == 200) {
      final List list = response.data;
      return list.map((json) => BusinessModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search businesses');
    }
  }

  @override
  Future<BusinessModel> getBusinessById(String id) async {
    final response = await dio.get('${AppConfig.baseUrl}/businesses/$id');
    if (response.statusCode == 200) {
      return BusinessModel.fromJson(response.data);
    } else {
      throw Exception('Failed to get business');
    }
  }

  @override
  Future<BusinessModel> createBusiness(BusinessModel business) async {
    final response = await dio.post('${AppConfig.baseUrl}/businesses', data: business.toJson());
    if (response.statusCode == 201) {
      return BusinessModel.fromJson(response.data);
    } else {
      throw Exception('Failed to create business');
    }
  }

  @override
  Future<BusinessModel> updateBusiness(BusinessModel business) async {
    final response = await dio.put('${AppConfig.baseUrl}/businesses/${business.id}', data: business.toJson());
    if (response.statusCode == 200) {
      return BusinessModel.fromJson(response.data);
    } else {
      throw Exception('Failed to update business');
    }
  }

  @override
  Future<List<BusinessModel>> getOwnedBusinesses() async {
    final response = await dio.get('${AppConfig.baseUrl}/my-businesses');
    if (response.statusCode == 200) {
      final List list = response.data;
      return list.map((json) => BusinessModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get owned businesses');
    }
  }
}
