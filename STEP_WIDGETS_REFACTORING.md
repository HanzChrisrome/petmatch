# Step Widgets Refactoring - State Management

## Overview

This document explains the refactoring of the `AddPetScreen` step widgets to use **parent-managed state** instead of local state. This allows the parent screen to access all form data for saving to the database.

## Problem

Previously, each step widget (`BasicInfoStep`, `HealthInfoStep`, etc.) managed its own state internally, making it impossible for the parent `AddPetScreen` to access the form data when saving.

## Solution

We implemented **Approach 1: Pass Controllers & Callbacks to Step Widgets**, which keeps the state management in the parent screen.

## Changes Made

### 1. BasicInfoStep

**Props Added:**

- Controllers: `petNameController`, `breedController`, `ageController`, `descriptionController`
- State values: `selectedSpecies`, `selectedGender`, `selectedSize`, `selectedImages`, `thumbnailImage`
- Callbacks: `onSpeciesChanged`, `onGenderChanged`, `onSizeChanged`, `onImagesChanged`, `onThumbnailChanged`

**Key Changes:**

- Removed local state variables and controllers
- Updated all widgets to use `widget.propertyName` instead of local state
- Image handling functions now update parent state through callbacks
- No longer calls `setState()` - uses callbacks instead

### 2. HealthInfoStep

**Props Added:**

- Controllers: `healthNotesController`, `specialNeedsDescController`
- State values: `groomingNeeds`, `hasSpecialNeeds`, `isVaccinationUpToDate`, `isSpayedNeutered`
- Callbacks: `onGroomingNeedsChanged`, `onHasSpecialNeedsChanged`, `onVaccinationChanged`, `onSpayedNeuteredChanged`

### 3. BehaviorInfoStep

**Props Added:**

- Controller: `behavioralNotesController`
- State values: `goodWithChildren`, `goodWithDogs`, `goodWithCats`, `houseTrained`
- Callbacks: `onGoodWithChildrenChanged`, `onGoodWithDogsChanged`, `onGoodWithCatsChanged`, `onHouseTrainedChanged`

### 4. ActivityInfoStep

**Props Added:**

- State values: `energyLevel`, `dailyExerciseNeeds`, `playfulness`
- Callbacks: `onEnergyLevelChanged`, `onDailyExerciseNeedsChanged`, `onPlayfulnessChanged`

### 5. TemperamentInfoStep

**Props Added:**

- State values: `selectedTraits`, `affectionLevel`, `independence`, `adaptability`, `trainingLevel`
- Callbacks: `onSelectedTraitsChanged`, `onAffectionLevelChanged`, `onIndependenceChanged`, `onAdaptabilityChanged`, `onTrainingLevelChanged`

### 6. AddPetScreen

**Updated PageView:**

```dart
PageView(
  controller: _pageController,
  physics: const NeverScrollableScrollPhysics(),
  children: [
    BasicInfoStep(
      petNameController: _petNameController,
      breedController: _breedController,
      // ... all other props
      onSpeciesChanged: (value) => setState(() => _selectedSpecies = value),
      // ... all other callbacks
    ),
    // Similar for other steps...
  ],
)
```

**Callbacks Pattern:**

- Simple values: `onChanged: (value) => setState(() => _property = value)`
- Lists: `onChanged: (items) => setState(() => _property..clear()..addAll(items))`

## Benefits

### ✅ Single Source of Truth

- All form data is managed in one place (`AddPetScreen`)
- No synchronization issues between parent and child widgets

### ✅ Easy Data Access

- `_savePet()` method can directly access all form fields
- No need to pass data up from child widgets

### ✅ Better Form Validation

- Parent can validate all fields before saving
- Centralized error handling

### ✅ Improved Testability

- Step widgets can be tested with mock data
- Parent screen controls all interactions

### ✅ Maintainability

- Clear data flow: Parent → Child (props) → Parent (callbacks)
- Easier to debug and trace data changes

## How Saving Works Now

```dart
Future<void> _savePet() async {
  // 1. Validate form
  if (!_formKey.currentState!.validate()) {
    _showErrorSnackBar('Please fill in all required fields');
    return;
  }

  // 2. All data is accessible from local state
  try {
    await ref.read(petsProvider.notifier).savePet(
      petName: _petNameController.text.trim(),
      species: _selectedSpecies!,
      breed: _breedController.text.trim(),
      age: int.tryParse(_ageController.text.trim()) ?? 0,
      gender: _selectedGender!,
      size: _selectedSize!,
      // ... all other fields from parent state
      selectedImages: _selectedImages,
      thumbnailImage: _thumbnailImage,
      isVaccinationUpToDate: _isVaccinationUpToDate,
      // ... etc
    );

    // 3. Handle success/error
    final errorMessage = ref.read(petsProvider).errorMessage;
    if (errorMessage != null) {
      _showErrorSnackBar(errorMessage);
      return;
    }

    // 4. Show success and navigate back
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(/* Success message */);
      Navigator.of(context).pop(true);
    }
  } catch (e) {
    _showErrorSnackBar('Error saving pet: $e');
  }
}
```

## Pattern Reference

### For Step Widgets

**1. Declare Props:**

```dart
class MyStep extends ConsumerStatefulWidget {
  final TextEditingController myController;
  final String? myValue;
  final Function(String?) onMyValueChanged;

  const MyStep({
    super.key,
    required this.myController,
    required this.myValue,
    required this.onMyValueChanged,
  });
}
```

**2. Use Props in Build:**

```dart
TextField(
  controller: widget.myController,
  // ...
)

DropdownButton(
  value: widget.myValue,
  onChanged: (value) => widget.onMyValueChanged(value),
)
```

### For Parent Screen

**1. Declare State:**

```dart
final TextEditingController _myController = TextEditingController();
String? _myValue;
```

**2. Pass to Step:**

```dart
MyStep(
  myController: _myController,
  myValue: _myValue,
  onMyValueChanged: (value) => setState(() => _myValue = value),
)
```

**3. Use in Save:**

```dart
Future<void> _save() async {
  final data = {
    'field': _myController.text.trim(),
    'value': _myValue,
  };
  // Save data...
}
```

## Alternative Approach Not Used

We **did not** use a shared state provider (like Riverpod StateNotifier) because:

- More boilerplate code required
- Overkill for this use case
- The parent-managed state approach is simpler and sufficient

## Testing Recommendations

1. **Unit Tests for Step Widgets:** Test with various prop combinations
2. **Integration Tests:** Test data flow from steps to parent
3. **Widget Tests:** Verify callbacks are triggered correctly
4. **End-to-End Tests:** Test complete save flow

## Future Enhancements

If the form becomes more complex, consider:

1. **Form State Manager:** Use packages like `flutter_form_builder`
2. **State Provider:** Move to Riverpod StateNotifier if needed
3. **Form Validation:** Add more sophisticated validation rules
4. **Auto-save:** Implement periodic auto-save functionality

---

**Date:** October 9, 2025  
**Status:** ✅ Complete  
**All Tests:** Passing
