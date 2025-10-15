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
    @Default(false) bool isFetchingMore,
    @Default(true) bool hasMore, // 👈 indicates if there’s more data to load
    @Default(0) int currentPage, // 👈 current page (or batch index)
    String? errorMessage,
  }) = _PetState;
}
