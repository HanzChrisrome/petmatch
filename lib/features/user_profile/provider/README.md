# User Profile Provider - Quick Reference Guide

## 📁 Files Created

1. **`user_profile_state.dart`** - State class with all profile fields
2. **`user_profile_provider.dart`** - Riverpod provider with methods
3. **`USAGE_EXAMPLES.dart`** - Complete usage examples

---

## 🚀 Quick Start

### Import the Provider

```dart
import 'package:petmatch/features/user_profile/provider/user_profile_provider.dart';
```

---

## ✅ Available Methods

### 1. **setPetPreference(String preference)**

Save selected pet: 'Cat', 'Dog', or 'No Preference'

```dart
ref.read(userProfileProvider.notifier).setPetPreference('Dog');
```

### 2. **setActivityLevel(int level, String label)**

Save activity level (1-5) with label

```dart
ref.read(userProfileProvider.notifier).setActivityLevel(3, 'Moderately Active');
```

### 3. **setAffectionLevel(int level, String label)**

Save affection level (1-5) with label

```dart
ref.read(userProfileProvider.notifier).setAffectionLevel(4, 'Pretty Affectionate');
```

### 4. **setPatienceLevel(int level, String label)**

Save patience level (1-5) with label

```dart
ref.read(userProfileProvider.notifier).setPatienceLevel(5, 'Very High Patience');
```

### 5. **submitProfile()**

Submit all data to backend (returns Future<bool>)

```dart
final success = await ref.read(userProfileProvider.notifier).submitProfile();
if (success) {
  // Navigate to home
}
```

### 6. **clearProfile()**

Reset all profile data

```dart
ref.read(userProfileProvider.notifier).clearProfile();
```

---

## 📊 Reading State

### Watch State (rebuilds on change)

```dart
final profile = ref.watch(userProfileProvider);
print(profile.petPreference); // 'Dog'
print(profile.activityLevel); // 3
print(profile.completionPercentage); // 75%
```

### Read State Once (no rebuild)

```dart
final profile = ref.read(userProfileProvider);
```

---

## 🎯 Common Use Cases

### In Continue Button

```dart
GestureDetector(
  onTap: () {
    // Save data
    ref.read(userProfileProvider.notifier).setPetPreference('Dog');

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved: Dog')),
    );

    // Navigate to next screen
    context.push('/activity-level');
  },
  child: Container(
    child: Text('Continue'),
  ),
)
```

### Display Progress

```dart
final profile = ref.watch(userProfileProvider);

LinearProgressIndicator(
  value: profile.completionPercentage / 100,
)
```

### Validation

```dart
final profile = ref.watch(userProfileProvider);

if (profile.isValid) {
  // All required fields filled
  // Show submit button
} else {
  // Show incomplete message
}
```

---

## 🐛 Debugging

All methods log to console:

```
📝 Pet preference saved: Dog
Current completion: 25%
Profile state: {pet_preference: Dog, ...}
──────────────────────────────────────────────────────
```

Get full summary:

```dart
final summary = ref.read(userProfileProvider.notifier).getProfileSummary();
print(summary);
```

---

## 🔄 Integration with Supabase

Update `submitProfile()` method in `user_profile_provider.dart`:

```dart
Future<bool> submitProfile() async {
  try {
    state = state.copyWith(isSubmitting: true);

    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    await supabase.from('user_profiles').upsert({
      'user_id': userId,
      ...state.toJson(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    state = state.copyWith(isSubmitting: false, isComplete: true);
    return true;
  } catch (e) {
    state = state.copyWith(isSubmitting: false, errorMessage: e.toString());
    return false;
  }
}
```

---

## 📱 State Fields

### Required Fields

- `petPreference` - String? ('Cat', 'Dog', 'No Preference')
- `activityLevel` - int? (1-5)
- `activityLabel` - String?
- `affectionLevel` - int? (1-5)
- `affectionLabel` - String?
- `patienceLevel` - int? (1-5)
- `patienceLabel` - String?

### Optional Fields

- `livingSpace` - String?
- `experience` - String?
- `preferredBreeds` - List<String>?
- `agePreference` - String?
- `sizePreference` - String?

### Metadata

- `isComplete` - bool
- `isSubmitting` - bool
- `errorMessage` - String?

---

## 💡 Tips

1. **Always use `ref.read()` when calling methods** (in callbacks)
2. **Use `ref.watch()` when displaying data** (rebuilds UI)
3. **Check `isValid` before submitting**
4. **Use `completionPercentage` for progress bars**
5. **Console logs help with debugging**

---

## 🎉 Done!

Your User Profile Provider is ready to use across all onboarding screens!
