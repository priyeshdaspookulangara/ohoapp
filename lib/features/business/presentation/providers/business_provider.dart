import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_business_directory/features/auth/presentation/providers/auth_provider.dart';
import 'package:local_business_directory/features/business/data/datasources/business_remote_data_source.dart';
import 'package:local_business_directory/features/business/data/repositories/business_repository_impl.dart';
import 'package:local_business_directory/features/business/domain/entities/business.dart';
import 'package:local_business_directory/features/business/domain/repositories/business_repository.dart';

final businessRemoteDataSourceProvider = Provider<BusinessRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return BusinessRemoteDataSourceImpl(dio: dio);
});

final businessRepositoryProvider = Provider<BusinessRepository>((ref) {
  final remoteDataSource = ref.watch(businessRemoteDataSourceProvider);
  final localDataSource = ref.watch(authLocalDataSourceProvider);
  return BusinessRepositoryImpl(remoteDataSource: remoteDataSource, localDataSource: localDataSource);
});

final searchQueryProvider = StateProvider<String>((ref) => '');
final searchCategoryProvider = StateProvider<String?>((ref) => null);

final searchBusinessesProvider = FutureProvider<List<Business>>((ref) async {
  final repository = ref.watch(businessRepositoryProvider);
  final query = ref.watch(searchQueryProvider);
  final category = ref.watch(searchCategoryProvider);

  final result = await repository.searchBusinesses(
    query: query.isEmpty ? null : query,
    category: category,
  );

  return result.fold(
    (failure) => throw failure.message,
    (businesses) => businesses,
  );
});

final businessOfferingsProvider = FutureProvider.family<List<Offering>, String>((ref, id) async {
  final repository = ref.watch(businessRepositoryProvider);
  final result = await repository.getBusinessOfferings(id);
  return result.fold(
    (failure) => throw failure.message,
    (offerings) => offerings,
  );
});

final ownedBusinessesProvider = FutureProvider<List<Business>>((ref) async {
  final repository = ref.watch(businessRepositoryProvider);
  final result = await repository.getOwnedBusinesses();
  return result.fold(
    (failure) => throw failure.message,
    (businesses) => businesses,
  );
});
