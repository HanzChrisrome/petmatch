# Quirk Integration Guide

## Overview

This guide explains how quirks are integrated into the PetMatch AI matching system and provides best practices for using them effectively.

## What are Quirks?

Quirks are **unique, personality-based text descriptions** that capture the special character traits of individual pets. Each pet has **one quirk (or none)** stored in the database.

### Examples from Your Database:

1. **Labrador**: "Sweet, easygoing, well-adjusted, and still moderately playful despite her age!"
2. **Kennel Greeter**: "Often called the 'mayordoma' as she likes napping by the kennel doors, greeting everyone who enters."

## How Quirks are Used in Match Explanations

### 1. **Data Flow**

```
Database (pet_characteristics.quirk)
  ↓
Pet Model (quirks: String?)
  ↓
GeminiService (_buildMatchExplanationPrompt)
  ↓
AI-Generated Match Explanation
```

### 2. **AI Integration** (Already Implemented)

The quirk is now automatically included in the AI prompt with special emphasis when present:

```dart
// In gemini_service.dart
final petQuirks = pet.quirks ?? 'None';
final hasQuirk = pet.quirks != null && pet.quirks!.trim().isNotEmpty;

// In the prompt:
// • Quirks: $petQuirks ⭐ (This is a unique characteristic!)
```

The AI is instructed to:

- **Weave the quirk naturally** into the explanation when present
- Use it to **add character and warmth** to the match explanation
- Make the pet feel **more personal and relatable** to the user

### 3. **Example AI Output with Quirks**

#### Without Quirk:

> "Bella is a great match for you! Your moderate activity level (3/5) aligns perfectly with her calm energy. She's affectionate and loves companionship, which matches your preference for snuggly pets. Your household setup is ideal for her needs."

#### With Quirk (Labrador example):

> "Bella is a wonderful match for you! This sweet, easygoing Labrador is well-adjusted and still moderately playful despite her age, which perfectly complements your moderate activity lifestyle (3/5). Her affectionate nature aligns beautifully with your love for cuddles, and she'll bring calm, gentle companionship to your home."

#### With Quirk (Mayordoma example):

> "Meet Luna, your friendly 'mayordoma'! Known for napping by the kennel doors and greeting everyone who enters, Luna's social and welcoming personality will bring warmth to your home. Your comfort with moderately active pets and household experience make you perfect for this charming greeter who loves meeting new people."

## Best Practices for Writing Quirks

### ✅ DO:

1. **Be specific and descriptive**

   - ✅ "Loves to 'sing' along when you play piano"
   - ❌ "Musical"

2. **Show personality through behavior**

   - ✅ "Always carries a toy in his mouth to greet visitors"
   - ❌ "Friendly"

3. **Use endearing, natural language**

   - ✅ "Has a habit of 'helping' with laundry by napping on warm clothes"
   - ❌ "Likes laundry"

4. **Include age-related personality** (if relevant)

   - ✅ "Still playful and curious despite being a senior"
   - ✅ "Young and bouncy, loves learning new tricks"

5. **Mention social behaviors**

   - ✅ "Acts as the 'welcome committee' for all shelter visitors"
   - ✅ "Prefers quiet one-on-one time over group activities"

6. **Highlight unique habits**
   - ✅ "Always sits by the window watching birds"
   - ✅ "Tilts head adorably when you talk to him"

### ❌ DON'T:

1. **Don't repeat standard traits** (already captured in other fields)

   - ❌ "Good with kids" (use goodWithChildren field)
   - ❌ "High energy" (use energyLevel field)

2. **Don't be vague**

   - ❌ "Nice personality"
   - ❌ "Good dog"

3. **Don't include medical info**

   - ❌ "Needs daily medication" (use specialNeeds field)

4. **Don't be too long**
   - Keep it to 1-2 sentences (under 150 characters is ideal)

## Database Schema

```sql
-- pet_characteristics table
CREATE TABLE pet_characteristics (
  pet_id UUID PRIMARY KEY REFERENCES pets(pet_id),
  quirk TEXT,  -- Can be NULL
  -- ... other fields
);
```

## Code Implementation

### Checking if a Pet Has a Quirk:

```dart
// In your Dart code
bool hasQuirk = pet.quirks != null && pet.quirks!.trim().isNotEmpty;

if (hasQuirk) {
  print("Pet has a quirk: ${pet.quirks}");
}
```

### Displaying Quirks in UI:

```dart
// Already implemented in pet_details_modal.dart
if (pet.quirks != null && pet.quirks!.trim().isNotEmpty)
  Container(
    // Display quirk with special styling
    child: Text(pet.quirks!),
  )
```

## How the AI Uses Quirks

The AI is given these specific instructions:

1. **If quirk exists**: Weave it naturally into the explanation
2. **Use examples**: The prompt includes concrete examples of how to integrate quirks
3. **Add personality**: Quirks make the explanation more personal and warm
4. **Stay conversational**: The quirk should feel like a friend describing the pet

### AI Prompt Section:

```
4. **If a quirk exists (not "None"), weave it naturally into the explanation**
   - This is ${pet.name}'s unique personality trait that makes them special!
   - Use it to add character and warmth to your explanation
   - Examples:
     * "${pet.name} is sweet and easygoing, making her a perfect companion..."
     * "Known as the 'mayordoma' who greets everyone at the kennel doors..."
```

## Testing Quirks

### Test Cases:

1. **Pet with no quirk** (null or empty string)

   - AI should generate a standard match explanation
   - Should focus on numerical traits and compatibility scores

2. **Pet with a short quirk** ("Sweet and playful")

   - AI should mention it briefly in the explanation

3. **Pet with a descriptive quirk** (your examples)
   - AI should weave it into 1-2 sentences of the explanation
   - Should make the pet feel more unique and personal

## Future Enhancements

### Potential Features:

1. **Quirk categories**: Tag quirks (e.g., "Social", "Playful", "Calm")
2. **User preferences**: Match users with specific quirk types
3. **Quirk gallery**: Showcase pets with unique quirks
4. **Admin quirk suggestions**: AI-powered quirk generation from behavior notes

## Summary

✅ **Quirks are now fully integrated** into your AI match explanations!

The system will:

- ✅ Automatically include quirks in the AI prompt
- ✅ Emphasize quirks when they exist (⭐ marker)
- ✅ Instruct the AI to weave them naturally into explanations
- ✅ Make match explanations more personal and engaging

**No additional code changes needed** - the AI will handle quirk integration automatically!
