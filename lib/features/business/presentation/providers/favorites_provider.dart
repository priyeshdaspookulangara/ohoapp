import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_business_directory/features/auth/presentation/providers/auth_provider.dart';
import 'package:local_business_directory/features/business/data/models/business_model.dart';
import 'package:local_business_directory/features/business/domain/entities/business.dart';
import 'package:shared_preferences/shared_preferences.dart';

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<Business>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FavoritesNotifier(prefs);
});

class FavoritesNotifier extends StateNotifier<List<Business>> {
  final SharedPreferences _prefs;
  static const String _key = 'FAVORITE_BUSINESSES';

  FavoritesNotifier(this._prefs) : super([]) {
    _loadFavorites();
  }

  void _loadFavorites() {
    final String? data = _prefs.getString(_key);
    if (data != null) {
      final List decoded = json.decode(data);
      state = decoded.map((e) => BusinessModel.fromJson(e)).toList();
    }
  }

  Future<void> toggleFavorite(Business business) async {
    final isFavorite = state.any((e) => e.id == business.id);
    if (isFavorite) {
      state = state.where((e) => e.id != business.id).toList();
    } else {
      state = [...state, business];
    }

    final encoded = state.map((e) {
      // Convert to model to use toJson if not already
      if (e is BusinessModel) return e.toJson();
      // Dummy conversion if it's just Business entity
      return {
        'id': e.id,
        'name': e.name,
        'category': e.category,
        'description': e.description,
        'address': e.address,
        'latitude': e.latitude,
        'longitude': e.longitude,
        'hero_image_url': e.heroImageUrl,
      };
    }).toList();

    await _prefs.setString(_key, json.encode(encoded));
  }

  bool isFavorite(String id) {
    return state.any((e) => e.id == id);
  }
}
