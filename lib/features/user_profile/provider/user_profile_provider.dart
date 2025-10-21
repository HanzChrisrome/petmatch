// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:petmatch/features/auth/provider/auth_provider.dart';
import 'package:petmatch/core/repository/user_profile_repository.dart';
import 'package:petmatch/features/user_profile/provider/user_profile_state.dart';

/// Notifier to manage user profile state
class UserProfileNotifier extends Notifier<UserProfileState> {
  final UserProfileRepository _repository;

  UserProfileNotifier(this._repository);

  @override
  UserProfileState build() {
    return const UserProfileState();
  }

  String get userId {
    return ref.watch(authProvider).userId!;
  }

  void setPetPreference(BuildContext context, String preference) {
    state = state.copyWith(petPreference: preference);
    _logState('Pet preference saved: $preference');
    context.push('/onboarding/activity-level');
  }

  /// Update pet preference without navigation (for editing)
  void updatePetPreference(String preference) {
    state = state.copyWith(petPreference: preference);
    _logState('Pet preference updated: $preference');
  }

  void setActivityLevel(BuildContext context, int level, String label) {
    state = state.copyWith(
      activityLevel: level,
      activityLabel: label,
    );
    _logState('Activity level saved: $level - $label');
    context.push('/onboarding/patience-level');
  }

  void updateUserProfile({
    required int level,
    required String label,
    required String column, // EXAMPLE: user_lifestyle
    required String key, // EXAMPLE: activity_level (IN THE JSON)
  }) {
    // The onboarding screens use JSON keys such as 'snuggly_preference'
    // and 'grooming_tolerance' inside the `personality_traits` object.
    // Switch on the JSON 'key' and update the corresponding local state.
    switch (key) {
      case 'activity_level':
        state = state.copyWith(
          activityLevel: level,
          activityLabel: label,
        );
        break;
      case 'patience_level':
        state = state.copyWith(
          patienceLevel: level,
          patienceLabel: label,
        );
        break;
      case 'snuggly_preference':
        state = state.copyWith(
          affectionLevel: level,
          affectionLabel: label,
        );
        break;
      case 'grooming_tolerance':
        state = state.copyWith(
          groomingLevel: level,
          groomingLabel: label,
        );
        break;
      default:
        throw ArgumentError('Unsupported update key: $key for column: $column');
    }

    print('💾 Updating $column -> $key: $level - $label in state');
    _repository.updatePersonalityTrait(
      userId,
      column,
      key,
      level,
    );

    _logState('$column updated: $level - $label');
  }

  void setPatienceLevel(BuildContext context, int level, String label) {
    state = state.copyWith(
      patienceLevel: level,
      patienceLabel: label,
    );
    _logState('Patience level saved: $level - $label');
    context.push('/onboarding/affection-level');
  }

  /// Update patience level without navigation (for editing)
  void updatePatienceLevel(int level, String label) {
    state = state.copyWith(
      patienceLevel: level,
      patienceLabel: label,
    );

    _logState('Patience level updated: $level - $label');
  }

  void setAffectionLevel(BuildContext context, int level, String label) {
    state = state.copyWith(
      affectionLevel: level,
      affectionLabel: label,
    );
    _logState('Affection level saved: $level - $label');
    context.push('/onboarding/grooming-level');
  }

  /// Update affection level without navigation (for editing)
  void updateAffectionLevel(int level, String label) {
    state = state.copyWith(
      affectionLevel: level,
      affectionLabel: label,
    );
    _logState('Affection level updated: $level - $label');
  }

  void setGroomingLevel(BuildContext context, int level, String label) {
    state = state.copyWith(
      groomingLevel: level,
      groomingLabel: label,
    );
    _logState('Grooming level saved: $level - $label');
    context.push('/onboarding/size-preference');
  }

  /// Update grooming level without navigation (for editing)
  void updateGroomingLevel(int level, String label) {
    state = state.copyWith(
      groomingLevel: level,
      groomingLabel: label,
    );
    _logState('Grooming level updated: $level - $label');
  }

  void setSizePreference(BuildContext context, String size) {
    state = state.copyWith(sizePreference: size);
    _logState('Size preference saved: $size');
    context.push('/onboarding/household');
  }

  /// Update size preference without navigation (for editing)
  void updateSizePreference(String size) {
    state = state.copyWith(sizePreference: size);
    _logState('Size preference updated: $size');
  }

  /// Save whether user has children
  void setHouseholdInfo(
    bool hasChildren,
    bool hasOtherPets,
    String? existingPetsDescription,
    bool comfortableWithShyPet,
    bool financialReady,
    bool hadPetBefore,
    bool okayWithSpecialNeeds,
  ) {
    state = state.copyWith(
      hasChildren: hasChildren,
      hasOtherPets: hasOtherPets,
      existingPetsDescription: existingPetsDescription,
      comfortableWithShyPet: comfortableWithShyPet,
      financialReady: financialReady,
      hadPetBefore: hadPetBefore,
      okayWithSpecialNeeds: okayWithSpecialNeeds,
    );
  }

  Future<bool> submitProfile() async {
    final authState = ref.watch(authProvider);
    final userId = authState.userId;

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

      // Simulate API call
      await Future.delayed(const Duration(seconds: 5));

      _repository.saveUserProfile(
        userId: userId!,
        userLifestyle: {
          'pet_preference': state.petPreference,
          'size_preference': state.sizePreference,
        },
        personalityTraits: {
          'activity_level': state.activityLevel,
          'grooming_tolerance': state.groomingLevel,
          'snuggly_preference': state.affectionLevel,
          'training_patience': state.patienceLevel,
        },
        householdInfo: {
          'has_children': state.hasChildren,
          'has_other_pets': state.hasOtherPets,
          'existing_pets_description': state.existingPetsDescription,
          'shy_pet_ok': state.comfortableWithShyPet,
          'financial_ready': state.financialReady,
          'had_pet_before': state.hadPetBefore,
          'okay_with_special_needs': state.okayWithSpecialNeeds,
        },
      );

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

  void clearProfile() {
    state = const UserProfileState();
    print('🗑️  Profile cleared');
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Load user profile from Supabase
  Future<void> loadUserProfile() async {
    final authState = ref.watch(authProvider);
    final userId = authState.userId;

    if (userId == null) {
      print('❌ No user ID found. Cannot load profile.');
      return;
    }

    try {
      print('📥 Loading user profile from database...');
      final profileData = await _repository.getUserProfile(userId);

      if (profileData == null) {
        print('⚠️  No profile found for user');
        return;
      }

      // Extract data from JSON fields
      final userLifestyle =
          profileData['user_lifestyle'] as Map<String, dynamic>?;
      final personalityTraits =
          profileData['personality_traits'] as Map<String, dynamic>?;
      final householdInfo =
          profileData['household_info'] as Map<String, dynamic>?;

      // Update state with loaded data
      state = state.copyWith(
        petPreference: userLifestyle?['pet_preference'] as String?,
        activityLevel: personalityTraits?['activity_level'] as int?,
        activityLabel:
            _getActivityLabel(personalityTraits?['activity_level'] as int?),
        groomingLevel: personalityTraits?['grooming_tolerance'] as int?,
        groomingLabel:
            _getGroomingLabel(personalityTraits?['grooming_tolerance'] as int?),
        sizePreference: userLifestyle?['size_preference'] as String?,
        affectionLevel: personalityTraits?['snuggly_preference'] as int?,
        affectionLabel: _getAffectionLabel(
            personalityTraits?['snuggly_preference'] as int?),
        patienceLevel: personalityTraits?['training_patience'] as int?,
        patienceLabel:
            _getPatienceLabel(personalityTraits?['training_patience'] as int?),
        hasChildren: householdInfo?['has_children'] as bool?,
        hasOtherPets: householdInfo?['has_other_pets'] as bool?,
        existingPetsDescription:
            householdInfo?['existing_pets_description'] as String?,
        comfortableWithShyPet: householdInfo?['shy_pet_ok'] as bool?,
        financialReady: householdInfo?['financial_ready'] as bool?,
        hadPetBefore: householdInfo?['had_pet_before'] as bool?,
        okayWithSpecialNeeds:
            householdInfo?['okay_with_special_needs'] as bool?,
        isComplete: true,
      );

      print('✅ Profile loaded successfully!');
      print('Profile data: ${state.toJson()}');
    } catch (e) {
      print('❌ Error loading profile: $e');
      state = state.copyWith(
        errorMessage: 'Failed to load profile: $e',
      );
    }
  }

  // Helper methods to convert levels to labels
  String? _getActivityLabel(int? level) {
    if (level == null) return null;
    switch (level) {
      case 1:
        return 'Inactive';
      case 2:
        return 'Lightly Active';
      case 3:
        return 'Moderately Active';
      case 4:
        return 'Very Active';
      case 5:
        return 'Extremely Active';
      default:
        return null;
    }
  }

  String? _getGroomingLabel(int? level) {
    if (level == null) return null;
    switch (level) {
      case 1:
        return 'Low Maintenance';
      case 2:
        return 'Basic Care';
      case 3:
        return 'Regular Grooming';
      case 4:
        return 'Frequent Care';
      case 5:
        return 'High Maintenance';
      default:
        return null;
    }
  }

  String? _getAffectionLabel(int? level) {
    if (level == null) return null;
    switch (level) {
      case 1:
        return 'Very Independent';
      case 2:
        return 'Somewhat Independent';
      case 3:
        return 'Balanced';
      case 4:
        return 'Pretty Affectionate';
      case 5:
        return 'Very Affectionate';
      default:
        return null;
    }
  }

  String? _getPatienceLabel(int? level) {
    if (level == null) return null;
    switch (level) {
      case 1:
        return 'Very Low';
      case 2:
        return 'Somewhat Low';
      case 3:
        return 'Moderate';
      case 4:
        return 'Pretty High';
      case 5:
        return 'Very High';
      default:
        return null;
    }
  }

  void _logState(String message) {
    print('📝 $message');
    print('Current completion: ${state.completionPercentage}%');
    print('Profile state: ${state.toJson()}');
    print('─' * 50);
  }

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

final userProfileRepositoryProvider =
    Provider((ref) => UserProfileRepository());

final userProfileProvider =
    NotifierProvider<UserProfileNotifier, UserProfileState>(
        () => UserProfileNotifier(UserProfileRepository()));
