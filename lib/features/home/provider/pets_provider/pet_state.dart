import 'package:petmatch/core/model/pet_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pet_state.freezed.dart';

@freezed
class PetState with _$PetState {
  factory PetState({
    List<Pet>? pets,
    List<Pet>? filteredPets,
    String? selectedCategory,
    String? searchQuery,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _PetState;
}
