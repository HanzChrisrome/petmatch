import 'package:flutter/material.dart';
import 'package:petmatch/core/constants/asset_paths.dart';

/// Utility class for preloading user profile assets
class UserProfileAssetPreloader {
  /// Preload all user profile assets at once
  static Future<void> preloadAll(BuildContext context) async {
    debugPrint('🎨 Starting user profile asset preload...');

    try {
      final assets = UserProfileAssets.getAllAssets();
      await Future.wait(
        assets.map((path) {
          return precacheImage(AssetImage(path), context).then((_) {
            debugPrint('✅ Loaded: $path');
          }).catchError((error) {
            debugPrint('❌ Failed to load: $path - $error');
          });
        }),
      );
      debugPrint('🎉 All user profile assets preloaded successfully!');
    } catch (e) {
      debugPrint('❌ Error preloading user profile assets: $e');
    }
  }

  /// Preload only activity level assets
  static Future<void> preloadActivityAssets(BuildContext context) async {
    await _preloadAssetList(
        context, UserProfileAssets.getActivityAssets(), 'Activity');
  }

  /// Preload only patience level assets
  static Future<void> preloadPatienceAssets(BuildContext context) async {
    await _preloadAssetList(
        context, UserProfileAssets.getPatienceAssets(), 'Patience');
  }

  /// Preload only affection level assets
  static Future<void> preloadAffectionAssets(BuildContext context) async {
    await _preloadAssetList(
        context, UserProfileAssets.getAffectionAssets(), 'Affection');
  }

  /// Preload only grooming level assets
  static Future<void> preloadGroomingAssets(BuildContext context) async {
    await _preloadAssetList(
        context, UserProfileAssets.getGroomingAssets(), 'Grooming');
  }

  /// Preload only pet preference assets
  static Future<void> preloadPetPreferenceAssets(BuildContext context) async {
    await _preloadAssetList(
        context, UserProfileAssets.getPetPreferenceAssets(), 'Pet Preference');
  }

  /// Preload only size preference assets
  static Future<void> preloadSizePreferenceAssets(BuildContext context) async {
    await _preloadAssetList(context,
        UserProfileAssets.getSizePreferenceAssets(), 'Size Preference');
  }

  /// Helper method to preload a list of assets
  static Future<void> _preloadAssetList(
    BuildContext context,
    List<String> assets,
    String category,
  ) async {
    debugPrint('🎨 Preloading $category assets...');
    try {
      await Future.wait(
        assets.map((path) => precacheImage(AssetImage(path), context)),
      );
      debugPrint('✅ $category assets preloaded!');
    } catch (e) {
      debugPrint('❌ Error preloading $category assets: $e');
    }
  }

  /// Preload next screen assets based on current screen
  static Future<void> preloadNextScreenAssets(
    BuildContext context,
    String currentScreen,
  ) async {
    switch (currentScreen) {
      case 'pet_preference':
        await preloadSizePreferenceAssets(context);
        break;
      case 'size_preference':
        await preloadActivityAssets(context);
        break;
      case 'activity_level':
        await preloadPatienceAssets(context);
        break;
      case 'patience_level':
        await preloadAffectionAssets(context);
        break;
      case 'affection_level':
        await preloadGroomingAssets(context);
        break;
      default:
        debugPrint('No next screen assets to preload for: $currentScreen');
    }
  }
}
