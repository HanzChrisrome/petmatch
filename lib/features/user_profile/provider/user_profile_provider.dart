// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petmatch/features/user_profile/provider/user_profile_state.dart';

/// Notifier to manage user profile state
class UserProfileNotifier extends StateNotifier<UserProfileState> {
  UserProfileNotifier() : super(const UserProfileState());

  void setPetPreference(String preference) {
    state = state.copyWith(petPreference: preference);
    _logState('Pet preference saved: $preference');
  }

  void setActivityLevel(int level, String label) {
    state = state.copyWith(
      activityLevel: level,
      activityLabel: label,
    );
    _logState('Activity level saved: $level - $label');
  }

  void setAffectionLevel(int level, String label) {
    state = state.copyWith(
      affectionLevel: level,
      affectionLabel: label,
    );
    _logState('Affection level saved: $level - $label');
  }

  /// ✅ Save patience level
  void setPatienceLevel(int level, String label) {
    state = state.copyWith(
      patienceLevel: level,
      patienceLabel: label,
    );
    _logState('Patience level saved: $level - $label');
  }

  /// Save living space preference
  void setLivingSpace(String space) {
    state = state.copyWith(livingSpace: space);
    _logState('Living space saved: $space');
  }

  /// Save pet ownership experience
  void setExperience(String exp) {
    state = state.copyWith(experience: exp);
    _logState('Experience saved: $exp');
  }

  /// Save preferred breeds
  void setPreferredBreeds(List<String> breeds) {
    state = state.copyWith(preferredBreeds: breeds);
    _logState('Preferred breeds saved: ${breeds.join(", ")}');
  }

  /// Save age preference
  void setAgePreference(String age) {
    state = state.copyWith(agePreference: age);
    _logState('Age preference saved: $age');
  }

  /// Save size preference
  void setSizePreference(String size) {
    state = state.copyWith(sizePreference: size);
    _logState('Size preference saved: $size');
  }

  /// Save whether user has children
  void setHasChildren(bool hasChildren) {
    state = state.copyWith(hasChildren: hasChildren);
    _logState('Has children saved: $hasChildren');
  }

  /// Save household pets information
  void setHasOtherPets(bool hasOtherPets, String? existingPetsDescription) {
    state = state.copyWith(
      hasOtherPets: hasOtherPets,
      existingPetsDescription: existingPetsDescription,
    );
    _logState(
        'Has other pets saved: $hasOtherPets${existingPetsDescription != null ? " - $existingPetsDescription" : ""}');
  }

  /// Save comfort level with shy pets
  void setComfortableWithShyPet(bool comfortable) {
    state = state.copyWith(comfortableWithShyPet: comfortable);
    _logState('Comfortable with shy pet saved: $comfortable');
  }

  Future<bool> submitProfile() async {
    if (!state.isValid) {
      state = state.copyWith(
        errorMessage: 'Please complete all required fields',
      );
      print('❌ Profile incomplete. Cannot submit.');
      print('Missing fields:');
      if (state.petPreference == null) print('  - Pet preference');
      if (state.activityLevel == null) print('  - Activity level');
      if (state.affectionLevel == null) print('  - Affection level');
      if (state.patienceLevel == null) print('  - Patience level');
      return false;
    }

    try {
      state = state.copyWith(isSubmitting: true, errorMessage: null);
      print('📤 Submitting profile to backend...');
      print('Profile data: ${state.toJson()}');

      // TODO: Implement actual Supabase save
      // Example:
      // final supabase = Supabase.instance.client;
      // final userId = supabase.auth.currentUser?.id;
      //
      // await supabase.from('user_profiles').upsert({
      //   'user_id': userId,
      //   ...state.toJson(),
      //   'updated_at': DateTime.now().toIso8601String(),
      // });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(
        isSubmitting: false,
        isComplete: true,
      );

      print('✅ Profile submitted successfully!');
      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Failed to submit profile: $e',
      );
      print('❌ Error submitting profile: $e');
      return false;
    }
  }

  /// ✅ Clear all profile data
  void clearProfile() {
    state = const UserProfileState();
    print('🗑️  Profile cleared');
  }

  /// Reset error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// ✅ Console logging for debugging
  void _logState(String message) {
    print('📝 $message');
    print('Current completion: ${state.completionPercentage}%');
    print('Profile state: ${state.toJson()}');
    print('─' * 50);
  }

  /// Get current profile summary
  String getProfileSummary() {
    final buffer = StringBuffer();
    buffer.writeln('🐾 User Profile Summary:');
    buffer.writeln('Pet Preference: ${state.petPreference ?? "Not set"}');
    buffer.writeln(
        'Activity Level: ${state.activityLevel ?? "Not set"} - ${state.activityLabel ?? ""}');
    buffer.writeln(
        'Affection Level: ${state.affectionLevel ?? "Not set"} - ${state.affectionLabel ?? ""}');
    buffer.writeln(
        'Patience Level: ${state.patienceLevel ?? "Not set"} - ${state.patienceLabel ?? ""}');
    buffer.writeln('Living Space: ${state.livingSpace ?? "Not set"}');
    buffer.writeln('Experience: ${state.experience ?? "Not set"}');
    buffer.writeln('Age Preference: ${state.agePreference ?? "Not set"}');
    buffer.writeln('Size Preference: ${state.sizePreference ?? "Not set"}');
    buffer.writeln('Completion: ${state.completionPercentage}%');
    buffer.writeln('Valid: ${state.isValid ? "✅" : "❌"}');
    return buffer.toString();
  }
}

/// ✅ Provider for user profile state
final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfileState>(
  (ref) => UserProfileNotifier(),
);
