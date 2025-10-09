# 🐾 Add Pet Screen Documentation

## Overview

The `AddPetScreen` is a comprehensive, multi-step form that consolidates all pet information collection into a single, user-friendly interface. It replaces the separate pet information screens with a seamless 5-step process.

## Features

### ✨ Key Features

- **Multi-step Form**: 5 progressive steps with visual progress indicator
- **Image Upload**: Select multiple images with thumbnail designation
- **Data Validation**: Form validation for required fields
- **Supabase Integration**: Automatic database and storage integration
- **Responsive Design**: Adapts to different screen sizes
- **Smooth Animations**: Page transitions and visual feedback

## Database Schema Integration

### Tables Used

#### 1. `pets` Table

```sql
- pet_id (UUID, PK)
- owner_id (UUID, FK to auth.users)
- name (TEXT)
- species (TEXT)
- breed (TEXT)
- age (INTEGER)
- gender (TEXT)
- size (TEXT)
- status (TEXT)
- thumbnail_path (TEXT)
- description (TEXT)
- is_adopted (BOOLEAN)
- created_at (TIMESTAMPTZ)
```

#### 2. `pet_characteristics` Table

```sql
- characteristic_id (UUID, PK)
- pet_id (UUID, FK to pets)
- behavior_tags (JSONB)
  {
    "good_with_children": "yes/no/unknown",
    "good_with_dogs": "yes/no/unknown",
    "good_with_cats": "yes/no/unknown",
    "house_trained": "yes/no/in_progress",
    "behavioral_notes": "text"
  }
- health_notes (JSONB)
  {
    "vaccinations_up_to_date": true/false,
    "spayed_neutered": true/false,
    "health_notes": "text",
    "has_special_needs": true/false,
    "special_needs_description": "text"
  }
- activity_level (JSONB)
  {
    "energy_level": 1-10,
    "playfulness": 1-10,
    "daily_exercise_needs": "low/moderate/high"
  }
- temperament (JSONB)
  {
    "traits": ["Gentle", "Social", ...],
    "affection_level": 1-6,
    "independence": 1-6,
    "adaptability": 1-6,
    "training_level": "beginner/intermediate/advanced",
    "grooming_needs": 1-5
  }
- updated_at (TIMESTAMPTZ)
```

#### 3. `pets_images` Table

```sql
- image_id (UUID, PK)
- pet_id (UUID, FK to pets)
- image_path (TEXT)
- created_at (TIMESTAMPTZ)
```

## Supabase Storage

### Bucket: `pet-images`

#### Storage Structure

```
pet-images/
└── {user_id}/
    └── {pet_id}/
        ├── {pet_id}_thumbnail_{timestamp}.jpg
        ├── {pet_id}_image_0_{timestamp}.jpg
        ├── {pet_id}_image_1_{timestamp}.jpg
        └── ...
```

#### Storage Policies Required

```sql
-- Allow authenticated users to upload images
CREATE POLICY "Users can upload their pet images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'pet-images' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Allow public to view pet images
CREATE POLICY "Public can view pet images"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'pet-images');
```

## Form Steps

### Step 1: Basic Information 📝

Collects essential pet details:

- **Pet Photos** (Required): Upload multiple images, set thumbnail
- **Pet Name** (Required)
- **Species** (Required): Dog, Cat, Rabbit, Other
- **Breed**
- **Age** (Required)
- **Gender** (Required): Male, Female, Unknown
- **Size** (Required): Small, Medium, Large
- **Description**: Multi-line text area
- **Status**: Available, Pending

### Step 2: Health Information 🏥

Medical and health records:

- **Vaccinations up to date?**: Yes/No
- **Spayed/Neutered?**: Yes/No
- **Health Notes**: Text area for allergies, conditions, medications
- **Special Needs?**: Yes/No
  - If Yes: Description field appears
- **Grooming Needs**: Slider (1-5 scale)

### Step 3: Behavior & Compatibility 🐾

Social compatibility information:

- **Good with children?**: Yes/No/Unknown
- **Good with other dogs?**: Yes/No/Unknown
- **Good with cats?**: Yes/No/Unknown
- **House-trained?**: Yes/No/In Progress
- **Behavioral Notes**: Text area

### Step 4: Activity & Energy ⚡

Activity level metrics:

- **Energy Level**: Slider (1-10 scale)
- **Daily Exercise Needs**: Low/Moderate/High cards
- **Playfulness**: Slider (1-10 scale)

### Step 5: Temperament 🧠

Personality characteristics:

- **Personality Traits**: Multi-select chips (max 3)
  - Options: Gentle, Protective, Social, Independent, Affectionate, Shy, Confident, Loyal
- **Affection Level**: Slider (1-6 scale)
- **Independence**: Slider (1-6 scale)
- **Adaptability**: Slider (1-6 scale)
- **Training Level**: Beginner/Intermediate/Advanced cards

## Usage

### Navigation

To use the AddPetScreen, add it to your router:

```dart
GoRoute(
  path: '/add-pet',
  builder: (context, state) => const AddPetScreen(),
),
```

### Opening the Screen

```dart
// Using GoRouter
context.push('/add-pet');

// Or using Navigator
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const AddPetScreen()),
);
```

### Handling Success

The screen returns `true` when a pet is successfully added:

```dart
final result = await Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const AddPetScreen()),
);

if (result == true) {
  // Pet was successfully added
  // Refresh your pet list or navigate to pet details
}
```

## Image Upload Process

### Flow

1. User taps "Add Photos" area
2. Image picker opens (can select multiple)
3. Selected images appear as thumbnails
4. First image is automatically set as thumbnail
5. User can:
   - Tap any image to set it as thumbnail
   - Tap X button to remove image
   - Tap + button to add more images

### Storage Process

1. Images are uploaded to Supabase Storage bucket `pet-images`
2. Path format: `{user_id}/{pet_id}/{filename}`
3. Thumbnail is uploaded first
4. Additional images are uploaded in sequence
5. Image paths are stored in `pets_images` table

## Data Flow

```
User Input
    ↓
Form Validation
    ↓
Generate UUIDs (pet_id, characteristic_id, image_ids)
    ↓
Upload Thumbnail → Supabase Storage
    ↓
Insert Pet Basic Info → pets table
    ↓
Upload Additional Images → Supabase Storage
    ↓
Insert Image Records → pets_images table
    ↓
Insert Characteristics → pet_characteristics table
    ↓
Show Success Message
    ↓
Return to Previous Screen
```

## Error Handling

The screen handles the following errors:

- **Image selection errors**: Shows error snackbar
- **Upload failures**: Shows detailed error message
- **Database insertion errors**: Shows error with details
- **Validation errors**: Inline field validation

## Customization

### Changing Colors

The screen uses theme colors. To customize:

```dart
// In your theme
ThemeData(
  primaryColor: Color(0xFFFF9800), // Used throughout the form
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFFFF9800),
  ),
)
```

### Modifying Steps

To add or remove steps:

1. Update `_totalSteps` constant
2. Add/remove page in `PageView`
3. Update `_getStepTitle()` method
4. Add corresponding `_build...Step()` method

## Required Packages

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  image_picker: ^1.0.7
  uuid: ^4.3.3
  google_fonts: ^6.2.1
  supabase_flutter: ^2.0.0
  flutter_riverpod: ^2.6.1
  cached_network_image: ^3.3.1
```

## Permissions

### Android (android/app/src/main/AndroidManifest.xml)

```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

### iOS (ios/Runner/Info.plist)

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photo library to upload pet images</string>
<key>NSCameraUsageDescription</key>
<string>We need access to your camera to take pet photos</string>
```

## Best Practices

1. **Always validate data** before submission
2. **Handle loading states** - Show progress indicators
3. **Provide feedback** - Show success/error messages
4. **Optimize images** - Consider compressing before upload
5. **Handle network errors** - Retry mechanism for uploads
6. **Clean up** - Remove uploaded images if process fails

## Testing

### Test Scenarios

1. ✅ Complete all steps with valid data
2. ✅ Skip optional fields
3. ✅ Upload single vs multiple images
4. ✅ Change thumbnail selection
5. ✅ Remove images
6. ✅ Navigate back and forth between steps
7. ✅ Submit with incomplete required fields
8. ✅ Handle network failure during upload
9. ✅ Cancel during upload process

## Troubleshooting

### Images not uploading?

- Check Supabase storage bucket exists
- Verify storage policies are set correctly
- Check internet connection
- Ensure user is authenticated

### Data not saving?

- Verify table schema matches the code
- Check RLS policies on tables
- Ensure user has INSERT permissions
- Check console for SQL errors

### Form validation failing?

- Check required fields are filled
- Verify data types match
- Ensure validators are properly configured

## Future Enhancements

- [ ] Image compression before upload
- [ ] Progress indicator for image uploads
- [ ] Draft saving (save progress)
- [ ] Image editing (crop, rotate)
- [ ] Batch upload optimization
- [ ] Offline support with sync
- [ ] AI-powered breed detection
- [ ] Medical record PDF upload

## Support

For issues or questions:

1. Check this documentation
2. Review Supabase logs
3. Check Flutter console for errors
4. Verify database schema matches

## License

This component is part of the PetMatch application.

---

**Last Updated**: October 8, 2025
**Version**: 1.0.0
