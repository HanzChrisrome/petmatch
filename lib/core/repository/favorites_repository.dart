import 'package:petmatch/core/config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritesRepository {
  Future<List<String>> getFavoritePetIds(String userId) async {
    final response =
        await supabase.from('favorites').select('pet_id').eq('user_id', userId);
    return (response as List).map((row) => row['pet_id'] as String).toList();
  }

  Future<void> addFavorite(String userId, String petId) async {
    await supabase.from('favorites').insert({
      'user_id': userId,
      'pet_id': petId,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> removeFavorite(String userId, String petId) async {
    await supabase
        .from('favorites')
        .delete()
        .eq('user_id', userId)
        .eq('pet_id', petId);
  }
}
