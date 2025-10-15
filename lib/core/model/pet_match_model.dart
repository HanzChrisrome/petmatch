import 'package:flutter/material.dart';
import 'package:petmatch/core/model/pet_model.dart';

class PetMatch {
  final Pet pet;
  final double lifestyleScore;
  final double personalityScore;
  final double householdScore;
  final double healthScore;
  final double totalMatchPercent;
  final String matchLabel;

  PetMatch({
    required this.pet,
    required this.lifestyleScore,
    required this.personalityScore,
    required this.householdScore,
    required this.healthScore,
    required this.totalMatchPercent,
    required this.matchLabel,
  });

  factory PetMatch.fromJson(Map<String, dynamic> json, Pet pet) {
    return PetMatch(
      pet: pet,
      lifestyleScore: (json['lifestyle_score'] as num?)?.toDouble() ?? 0.0,
      personalityScore: (json['personality_score'] as num?)?.toDouble() ?? 0.0,
      householdScore: (json['household_score'] as num?)?.toDouble() ?? 0.0,
      healthScore: (json['health_score'] as num?)?.toDouble() ?? 0.0,
      totalMatchPercent:
          (json['total_match_percent'] as num?)?.toDouble() ?? 0.0,
      matchLabel: json['match_label'] as String? ?? 'Unknown Match',
    );
  }

  // Get color based on match percentage
  Color get matchColor {
    if (totalMatchPercent >= 80) {
      return const Color(0xFF4CAF50); // Green for high match
    } else if (totalMatchPercent >= 50) {
      return const Color(0xFFFF9800); // Orange for moderate match
    } else {
      return const Color(0xFFE57373); // Red for low match
    }
  }

  // Get icon based on match label
  IconData get matchIcon {
    if (totalMatchPercent >= 80) {
      return Icons.favorite;
    } else if (totalMatchPercent >= 50) {
      return Icons.favorite_border;
    } else {
      return Icons.heart_broken;
    }
  }
}
