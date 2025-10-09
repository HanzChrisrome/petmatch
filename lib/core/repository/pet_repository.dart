// ignore_for_file: avoid_print

import 'dart:io';
import 'package:petmatch/core/config/supabase_config.dart';
import 'package:petmatch/core/model/pet_model.dart';

class PetRepository {
  final _supabase = supabase;

  Future<List<Pet>> getAllPets() async {
    try {
      final response = await _supabase
          .from('pets')
          .select('*, pets_images(*), pet_characteristics(*)')
          .neq('status', 'adopted')
          .order('created_at', ascending: false);

      print('📤 Fetched ${(response as List).length} pets from database.');

      print('Raw response: $response');

      return (response as List)
          .map((json) => Pet.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ Error fetching pets: $e');
      rethrow;
    }
  }

  Future<List<Pet>> getPetsBySpecies(String species) async {
    try {
      if (species.toLowerCase() == 'all') {
        return getAllPets();
      }

      final response = await _supabase
          .from('pets')
          .select('*, pets_images(*), pet_characteristics(*)')
          .eq('species', species.toLowerCase())
          .neq('status', 'adopted')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Pet.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ Error fetching pets by species: $e');
      rethrow;
    }
  }

  Future<Pet?> getPetById(String petId) async {
    try {
      final response = await _supabase
          .from('pets')
          .select('*, pets_images(*), pet_characteristics(*)')
          .eq('pet_id', petId)
          .single();

      return Pet.fromJson(response);
    } catch (e) {
      print('❌ Error fetching pet: $e');
      return null;
    }
  }

  /// Search pets by name
  Future<List<Pet>> searchPets(String query) async {
    try {
      if (query.isEmpty) {
        return getAllPets();
      }

      final response = await _supabase
          .from('pets')
          .select('*, pets_images(*), pet_characteristics(*)')
          .ilike('name', '%$query%')
          .neq('status', 'adopted')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Pet.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('❌ Error searching pets: $e');
      rethrow;
    }
  }

  Future<String> savePet({
    required String petId,
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
      print('💾 Starting to save pet: $petName');

      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      print('Pet ID: $petId');
      print('Pet Name: $petName');
      print('Species: $species');
      print('Breed: $breed');
      print('Age: $age');
      print('Gender: $gender');
      print('Size: $size');
      print('Status: $status');
      print('Description: $description');
      print('Thumbnail Image: ${thumbnailImage?.path}');
      print('Selected Images: ${selectedImages.map((f) => f.path).toList()}');
      print('Is Vaccination Up To Date: $isVaccinationUpToDate');
      print('Is Spayed/Neutered: $isSpayedNeutered');
      print('Health Notes: $healthNotes');
      print('Has Special Needs: $hasSpecialNeeds');
      print('Special Needs Description: $specialNeedsDescription');
      print('Grooming Needs: $groomingNeeds');
      print('Good With Children: $goodWithChildren');
      print('Good With Dogs: $goodWithDogs');
      print('Good With Cats: $goodWithCats');
      print('House Trained: $houseTrained');
      print('Behavioral Notes: $behavioralNotes');
      print('Energy Level: $energyLevel');
      print('Playfulness: $playfulness');
      print('Daily Exercise Needs: $dailyExerciseNeeds');
      print('Selected Traits: $selectedTraits');
      print('Affection Level: $affectionLevel');
      print('Independence: $independence');
      print('Adaptability: $adaptability');
      print('Training Level: $trainingLevel');

      // Upload thumbnail to Supabase Storage
      String? thumbnailPath;
      if (thumbnailImage != null) {
        print('📸 Uploading thumbnail image...');
        final thumbnailFileName = '$petName-thumbnail.png';
        final thumbnailStoragePath = '$petId/$thumbnailFileName';

        await _supabase.storage
            .from('pets')
            .upload(thumbnailStoragePath, thumbnailImage);

        thumbnailPath = thumbnailFileName;
        print('✅ Thumbnail uploaded: $thumbnailPath');
      }

      print('📝 Inserting pet basic information...');
      await _supabase.from('pets').insert({
        'pet_id': petId,
        'name': petName,
        'species': species,
        'breed': breed,
        'age': age,
        'gender': gender,
        'size': size,
        'status': status,
        'thumbnail_path': thumbnailPath,
        'description': description,
        'is_adopted': false,
        'created_at': DateTime.now().toIso8601String(),
      });
      print('✅ Pet basic information saved');

      // // Upload additional images to Supabase Storage
      final List<Map<String, dynamic>> imageInserts = [];
      print('📸 Uploading ${selectedImages.length} additional images...');

      for (var i = 0; i < selectedImages.length; i++) {
        final imageFile = selectedImages[i];

        String imageFileName;
        if (imageFile == thumbnailImage) {
          imageFileName = '$petName-thumbnail.png';
        } else {
          imageFileName = '$petName-$i.png';
        }

        if (imageFile != thumbnailImage) {
          await _supabase.storage
              .from('pets')
              .upload('$petId/$imageFileName', imageFile);
        }

        imageInserts.add({
          'pet_id': petId,
          'image_path': imageFileName,
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      if (imageInserts.isNotEmpty) {
        await _supabase.from('pets_images').insert(imageInserts);
        print('✅ ${imageInserts.length} images uploaded and saved');
      }

      // Insert pet characteristics
      print('📋 Saving pet characteristics...');
      await _supabase.from('pet_characteristics').insert({
        'pet_id': petId,
        'behavior_tags': {
          'good_with_children': goodWithChildren,
          'good_with_dogs': goodWithDogs,
          'good_with_cats': goodWithCats,
          'house_trained': houseTrained,
          'behavioral_notes': behavioralNotes,
        },
        'health_notes': {
          'vaccinations': isVaccinationUpToDate,
          'spayed_neutered': isSpayedNeutered,
          'health_notes': healthNotes,
          'special_needs': hasSpecialNeeds,
          'special_needs_description': specialNeedsDescription,
        },
        'activity_level': {
          'energy_level': energyLevel,
          'playfulness': playfulness,
          'daily_exercise_needs': dailyExerciseNeeds,
        },
        'temperament': {
          'traits': selectedTraits,
          'affection_level': affectionLevel,
          'independence': independence,
          'adaptability': adaptability,
          'training_difficulty': trainingLevel,
          'grooming_needs': groomingNeeds,
        },
        'updated_at': DateTime.now().toIso8601String(),
      });
      print('✅ Pet characteristics saved');

      print('🎉 Pet saved successfully with ID: $petId');
      return petId;
    } catch (e) {
      print('❌ Error saving pet: $e');
      rethrow;
    }
  }
}
