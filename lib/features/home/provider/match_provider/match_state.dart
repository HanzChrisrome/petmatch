import 'package:petmatch/core/model/pet_match_model.dart';

class MatchState {
  final List<PetMatch> matches;
  final bool isLoading;
  final String? errorMessage;

  MatchState({
    this.matches = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  MatchState copyWith({
    List<PetMatch>? matches,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MatchState(
      matches: matches ?? this.matches,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
