// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petmatch/core/config/supabase_config.dart';
import 'package:petmatch/core/repository/pet_repository.dart';
import 'package:petmatch/features/home/provider/match_provider/match_state.dart';

class MatchNotifier extends Notifier<MatchState> {
  final PetRepository _repository;

  MatchNotifier(this._repository);

  @override
  MatchState build() {
    return MatchState();
  }

  Future<void> fetchMatchedPets() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      print('🎯 Fetching matched pets for current user...');

      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final matches = await _repository.getMatchedPetsForUser(userId);

      state = state.copyWith(
        matches: matches,
        isLoading: false,
      );

      print('✅ Fetched ${matches.length} matched pets successfully!');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to fetch matched pets: $e',
      );
      print('❌ Error fetching matched pets: $e');
    }
  }

  void clearMatches() {
    state = state.copyWith(matches: [], errorMessage: null);
  }
}

// Provider instance
final matchProvider = NotifierProvider<MatchNotifier, MatchState>(() {
  return MatchNotifier(PetRepository());
});
