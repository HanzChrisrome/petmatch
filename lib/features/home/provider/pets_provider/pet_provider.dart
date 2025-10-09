// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petmatch/core/model/pet_model.dart';
import 'package:petmatch/features/home/provider/pets_provider/pet_state.dart';
import 'package:petmatch/core/repository/pet_repository.dart';
import 'package:uuid/uuid.dart';

class PetNotifier extends Notifier<PetState> {
  final PetRepository _repository;

  PetNotifier(this._repository);

  @override
  PetState build() {
    return PetState();
  }

  Future<void> fetchAllPets() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      print('📤 Fetching all pets from database...');

      final pets = await _repository.getAllPets();

      state = state.copyWith(
        pets: pets,
        filteredPets: pets,
        isLoading: false,
      );

      print('✅ Fetched ${pets.length} pets successfully!');
      print('💾 All pets stored in state for local filtering');
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to fetch pets: $e',
      );
      print('❌ Error fetching pets: $e');
    }
  }

  Future<void> savePet({
    required String petName,
    required String species,
    required String breed,
    required int age,
    required String gender,
    required String size,
    required String status,
    required String description,
    required File? thumbnailImage,
    required List<File> selectedImages,
    // Health Information
    required String? isVaccinationUpToDate,
    required String? isSpayedNeutered,
    required String healthNotes,
    required String? hasSpecialNeeds,
    required String specialNeedsDescription,
    required int? groomingNeeds,
    // Behavior Information
    required String? goodWithChildren,
    required String? goodWithDogs,
    required String? goodWithCats,
    required String? houseTrained,
    required String behavioralNotes,
    // Activity Information
    required double energyLevel,
    required double playfulness,
    required String? dailyExerciseNeeds,
    // Temperament Information
    required List<String> selectedTraits,
    required double affectionLevel,
    required double independence,
    required double adaptability,
    required String? trainingLevel,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      print('💾 Saving new pet: $petName');

      const Uuid uuid = Uuid();
      final petId = uuid.v4();

      await _repository.savePet(
        petId: petId,
        petName: petName,
        species: species,
        breed: breed,
        age: age,
        gender: gender,
        size: size,
        status: status,
        description: description,
        thumbnailImage: thumbnailImage,
        selectedImages: selectedImages,
        isVaccinationUpToDate: isVaccinationUpToDate,
        isSpayedNeutered: isSpayedNeutered,
        healthNotes: healthNotes,
        hasSpecialNeeds: hasSpecialNeeds,
        specialNeedsDescription: specialNeedsDescription,
        groomingNeeds: groomingNeeds,
        goodWithChildren: goodWithChildren,
        goodWithDogs: goodWithDogs,
        goodWithCats: goodWithCats,
        houseTrained: houseTrained,
        behavioralNotes: behavioralNotes,
        energyLevel: energyLevel,
        playfulness: playfulness,
        dailyExerciseNeeds: dailyExerciseNeeds,
        selectedTraits: selectedTraits,
        affectionLevel: affectionLevel,
        independence: independence,
        adaptability: adaptability,
        trainingLevel: trainingLevel,
      );

      print('✅ Pet saved successfully!');
      print('🔄 Refreshing pet list...');

      await fetchAllPets();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to save pet: $e',
      );
      print('❌ Error saving pet: $e');
      rethrow;
    }
  }

  void filterByCategory(String category) {
    print('🔍 Filtering pets locally by category: $category');

    final allPets = state.pets ?? [];
    List<Pet> filtered;

    if (category.toLowerCase() == 'all') {
      filtered = allPets;
      print('✅ Showing all ${filtered.length} pets');
    } else {
      filtered = allPets
          .where((pet) => pet.species.toLowerCase() == category.toLowerCase())
          .toList();
      print('✅ Filtered to ${filtered.length} ${category.toLowerCase()}(s)');
    }

    state = state.copyWith(
      filteredPets: filtered,
      selectedCategory: category,
      searchQuery: '',
    );
  }

  void searchPets(String query) {
    print('🔍 Searching pets locally with query: "$query"');

    if (query.isEmpty) {
      filterByCategory(state.selectedCategory ?? 'All');
      return;
    }

    final allPets = state.pets ?? [];
    final selectedCategory = state.selectedCategory ?? 'All';

    List<Pet> baseList = selectedCategory.toLowerCase() == 'all'
        ? allPets
        : allPets
            .where((pet) =>
                pet.species.toLowerCase() == selectedCategory.toLowerCase())
            .toList();

    final filtered = baseList
        .where((pet) => pet.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    state = state.copyWith(
      filteredPets: filtered,
      searchQuery: query,
    );

    print('✅ Found ${filtered.length} pet(s) matching "$query"');
  }

  void setSelectedCategory(String category) {
    filterByCategory(category);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void clearSearch() {
    print('🧹 Clearing search');
    filterByCategory(state.selectedCategory ?? 'All');
  }

  Future<void> refresh() async {
    print('🔄 Refreshing pets from database...');
    await fetchAllPets();

    final searchQuery = state.searchQuery ?? '';
    final selectedCategory = state.selectedCategory ?? 'All';

    if (searchQuery.isNotEmpty) {
      searchPets(searchQuery);
    } else if (selectedCategory != 'All') {
      filterByCategory(selectedCategory);
    }
  }
}

final petsProvider = NotifierProvider<PetNotifier, PetState>(
  () => PetNotifier(PetRepository()),
);
