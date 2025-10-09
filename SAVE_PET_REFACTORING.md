# Save Pet Functionality Refactoring

## Overview

Moved the pet saving logic from the UI layer (`AddPetScreen`) to the provider/repository layer for better separation of concerns and maintainability.

## Architecture Changes

### Before (Coupled Architecture)

```
AddPetScreen (UI Layer)
    └─> Direct Supabase calls
        ├─> Upload images to storage
        ├─> Insert into pets table
        ├─> Insert into pets_images table
        └─> Insert into pet_characteristics table
```

### After (Clean Architecture)

```
AddPetScreen (UI Layer)
    └─> PetNotifier (State Management)
        └─> PetRepository (Data Layer)
            └─> Supabase API calls
```

## Changes Made

### 1. PetRepository (`lib/core/repository/pet_repository.dart`)

**Added:** `savePet()` method

**Responsibilities:**

- Handles all database operations
- Manages image uploads to Supabase Storage
- Inserts pet data into 3 tables: `pets`, `pets_images`, `pet_characteristics`
- Returns the generated pet ID
- Comprehensive error handling with detailed logging

**Parameters:** 30+ parameters covering all pet information (basic info, health, behavior, activity, temperament)

### 2. PetNotifier (`lib/features/home/provider/pets_provider/pet_provider.dart`)

**Added:** `savePet()` method

**Responsibilities:**

- State management (loading states, error handling)
- Generates unique pet ID using UUID
- Calls repository's `savePet()` method
- Automatically refreshes pet list after successful save
- Updates UI state accordingly

**Key Features:**

- Sets `isLoading` state before/after save
- Catches and exposes errors via `errorMessage` in state
- Automatically calls `fetchAllPets()` to refresh the list
- Re-throws exceptions for UI layer to handle

### 3. AddPetScreen (`lib/features/pet_profile/screens/add_pet_screen.dart`)

**Modified:** `_savePet()` method

**Changes:**

- Removed ~130 lines of direct Supabase code
- Now simply calls `ref.read(petsProvider.notifier).savePet()`
- Passes all form data as named parameters
- Maintains UI feedback (loading spinner, success/error messages)

**Removed Dependencies:**

- `package:petmatch/core/config/supabase_config.dart` (no longer needed)
- `package:uuid/uuid.dart` (UUID generation moved to provider)

**Added Dependency:**

- `package:petmatch/features/home/provider/pets_provider/pet_provider.dart`

## Benefits

### 1. Separation of Concerns

- **UI Layer**: Only handles user interaction and display
- **State Management**: Handles business logic and state
- **Data Layer**: Handles database operations

### 2. Testability

- Repository can be mocked for testing
- Provider logic can be tested independently
- UI can be tested without actual database calls

### 3. Reusability

- `savePet()` can be called from anywhere in the app
- No need to duplicate database logic
- Centralized error handling

### 4. Maintainability

- Changes to database structure only require updating repository
- Provider layer remains stable
- UI code is cleaner and more focused

### 5. Automatic Features

- Pet list automatically refreshes after adding a new pet
- Consistent error handling across the app
- Centralized logging for debugging

## Usage Example

```dart
// In any widget that uses ConsumerWidget or ConsumerStatefulWidget
await ref.read(petsProvider.notifier).savePet(
  petName: 'Buddy',
  species: 'dog',
  breed: 'Golden Retriever',
  age: 3,
  gender: 'male',
  size: 'large',
  // ... other parameters
);

// The pet list will automatically refresh!
// Check for errors using:
final error = ref.watch(petsProvider).errorMessage;
```

## State Management

### Loading State

```dart
final isLoading = ref.watch(petsProvider).isLoading;
if (isLoading) {
  // Show loading indicator
}
```

### Error Handling

```dart
final errorMessage = ref.watch(petsProvider).errorMessage;
if (errorMessage != null) {
  // Show error to user
  ref.read(petsProvider.notifier).clearError();
}
```

## Database Operations Flow

1. **User clicks Save** → `_savePet()` in AddPetScreen
2. **Generate UUID** → Provider creates unique pet ID
3. **Upload Thumbnail** → Repository uploads to `pet-images` bucket
4. **Insert Pet** → Repository inserts into `pets` table
5. **Upload Images** → Repository uploads additional images
6. **Insert Image Records** → Repository inserts into `pets_images` table
7. **Insert Characteristics** → Repository inserts into `pet_characteristics` table with JSONB data
8. **Refresh List** → Provider calls `fetchAllPets()`
9. **Update UI** → Screen shows success message and navigates back

## Error Handling

### Repository Level

- Catches Supabase exceptions
- Logs detailed error messages
- Re-throws for provider to handle

### Provider Level

- Updates `errorMessage` in state
- Sets `isLoading = false`
- Re-throws for UI to handle

### UI Level

- Shows user-friendly error messages
- Resets loading state
- User can retry operation

## Future Enhancements

### Potential Additions

1. **Update Pet**: `updatePet()` method for editing existing pets
2. **Delete Pet**: `deletePet()` method with cascade deletes
3. **Batch Operations**: `savePets()` for multiple pets at once
4. **Offline Support**: Queue operations when offline
5. **Image Optimization**: Compress images before upload
6. **Progress Tracking**: Emit upload progress for large images

### Validation

Consider adding validation layer:

```dart
class PetValidator {
  static bool validatePetData(Map<String, dynamic> data) {
    // Validate required fields
    // Check data types
    // Verify constraints
  }
}
```

## Testing

### Repository Tests

```dart
test('savePet inserts correct data', () async {
  final mockSupabase = MockSupabaseClient();
  final repository = PetRepository();
  // Test database operations
});
```

### Provider Tests

```dart
test('savePet updates state correctly', () async {
  final container = ProviderContainer();
  // Test state management
});
```

## Conclusion

This refactoring significantly improves the codebase architecture by:

- ✅ Removing 130+ lines of database code from UI
- ✅ Centralizing data operations in repository
- ✅ Adding proper state management
- ✅ Improving testability and maintainability
- ✅ Automatically refreshing pet list after save
- ✅ Providing consistent error handling

The app now follows clean architecture principles with clear separation between UI, business logic, and data layers.
