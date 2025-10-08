import 'package:petmatch/core/config/supabase_config.dart';

class UserProfileRepository {
  Future<void> saveUserProfile({
    required String userId,
    required Map<String, dynamic> userLifestyle,
    required Map<String, dynamic> personalityTraits,
    required Map<String, dynamic> householdInfo,
  }) async {
    final data = {
      'user_id': userId,
      'user_lifestyle': userLifestyle,
      'personality_traits': personalityTraits,
      'household_info': householdInfo,
      'updated_at': DateTime.now().toIso8601String(),
    };

    // Check if profile exists
    final existing = await supabase
        .from('user_profile')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (existing != null) {
      await supabase.from('user_profile').update(data).eq('user_id', userId);
    } else {
      await supabase.from('user_profile').insert(data);
    }
  }
}
