// ignore_for_file: avoid_print

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
}
