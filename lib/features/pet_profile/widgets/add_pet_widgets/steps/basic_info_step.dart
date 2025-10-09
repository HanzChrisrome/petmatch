// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petmatch/widgets/style/themed_textfield.dart';

class BasicInfoStep extends ConsumerStatefulWidget {
  final TextEditingController petNameController;
  final TextEditingController breedController;
  final TextEditingController ageController;
  final TextEditingController descriptionController;
  final String? selectedSpecies;
  final String? selectedGender;
  final String? selectedSize;
  final Function(String?) onSpeciesChanged;
  final Function(String?) onGenderChanged;
  final Function(String?) onSizeChanged;
  final List<File> selectedImages;
  final File? thumbnailImage;
  final Function(List<File>) onImagesChanged;
  final Function(File?) onThumbnailChanged;

  const BasicInfoStep({
    super.key,
    required this.petNameController,
    required this.breedController,
    required this.ageController,
    required this.descriptionController,
    required this.selectedSpecies,
    required this.selectedGender,
    required this.selectedSize,
    required this.onSpeciesChanged,
    required this.onGenderChanged,
    required this.onSizeChanged,
    required this.selectedImages,
    required this.thumbnailImage,
    required this.onImagesChanged,
    required this.onThumbnailChanged,
  });

  @override
  ConsumerState<BasicInfoStep> createState() => _BasicInfoStepState();
}

class _BasicInfoStepState extends ConsumerState<BasicInfoStep> {
  final ImagePicker _picker = ImagePicker();

  // --------------------------------
  // Functions to handle image picking, setting thumbnail, and removing images
  // --------------------------------
  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        final updatedImages = List<File>.from(widget.selectedImages);
        updatedImages.addAll(images.map((xFile) => File(xFile.path)));
        widget.onImagesChanged(updatedImages);

        if (widget.thumbnailImage == null && updatedImages.isNotEmpty) {
          widget.onThumbnailChanged(updatedImages.first);
        }
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  void _setThumbnail(int index) {
    widget.onThumbnailChanged(widget.selectedImages[index]);
  }

  void _removeImage(int index) {
    final updatedImages = List<File>.from(widget.selectedImages);
    final removedImage = updatedImages[index];
    updatedImages.removeAt(index);
    widget.onImagesChanged(updatedImages);

    if (widget.thumbnailImage == removedImage && updatedImages.isNotEmpty) {
      widget.onThumbnailChanged(updatedImages.first);
    } else if (updatedImages.isEmpty) {
      widget.onThumbnailChanged(null);
    }
  }

  Future<void> _pickThumbnail() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final newThumbnail = File(image.path);
        widget.onThumbnailChanged(newThumbnail);

        if (!widget.selectedImages.contains(newThumbnail)) {
          final updatedImages = List<File>.from(widget.selectedImages);
          updatedImages.insert(0, newThumbnail);
          widget.onImagesChanged(updatedImages);
        }
      }
    } catch (e) {
      print('Error picking thumbnail: $e');
    }
  }

  // --------------------------------
  // Build Method
  // --------------------------------
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Upload Section
          _buildImageUploadSection(),
          const SizedBox(height: 24),

          // Pet Name
          _buildFieldLabel('Pet Name', '🏷️', isRequired: true),
          const SizedBox(height: 8),
          ThemedTextField(
            controller: widget.petNameController,
            label: 'e.g., Max, Bella, Charlie',
            prefixIcon: Icons.pets,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter pet name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Species
          _buildFieldLabel('Species', '🦴', isRequired: true),
          const SizedBox(height: 8),
          _buildSpeciesCards(),
          const SizedBox(height: 20),

          // Breed
          _buildFieldLabel('Breed', '📋'),
          const SizedBox(height: 8),
          ThemedTextField(
            controller: widget.breedController,
            label: 'e.g., Golden Retriever, Persian Cat',
            prefixIcon: Icons.assignment,
          ),
          const SizedBox(height: 20),

          // Age and Gender Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Age (years)', '🎂', isRequired: true),
                    const SizedBox(height: 8),
                    ThemedTextField(
                      controller: widget.ageController,
                      label: 'e.g., 2',
                      prefixIcon: Icons.cake,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Invalid age';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Gender', '⚧️', isRequired: true),
                    const SizedBox(height: 8),
                    _buildGenderDropdown(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Size
          _buildFieldLabel('Size', '📏', isRequired: true),
          const SizedBox(height: 8),
          _buildSizeChips(),
          const SizedBox(height: 20),

          // Description
          _buildFieldLabel('Description', '📝'),
          const SizedBox(height: 8),
          ThemedTextField(
            controller: widget.descriptionController,
            label: 'Tell us more about this pet...',
            prefixIcon: Icons.description,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  //---------------------------------
  // Widget Builders for various sections
  //---------------------------------
  Widget _buildSpeciesCards() {
    final species = [
      {'label': 'Dog', 'emoji': '🐕', 'value': 'Dog'},
      {'label': 'Cat', 'emoji': '🐈', 'value': 'Cat'},
    ];

    return Row(
      children: species.map((spec) {
        final isSelected = widget.selectedSpecies == spec['value'];
        return Expanded(
          child: GestureDetector(
            onTap: () => widget.onSpeciesChanged(spec['value'] as String),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFF9800).withOpacity(0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isSelected ? const Color(0xFFFF9800) : Colors.grey[300]!,
                  width: isSelected ? 2 : 1.5,
                ),
              ),
              child: Column(
                children: [
                  Text(spec['emoji'] as String,
                      style: const TextStyle(fontSize: 28)),
                  const SizedBox(height: 4),
                  Text(
                    spec['label'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color:
                          isSelected ? const Color(0xFFFF9800) : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
      ),
      child: DropdownButtonFormField<String>(
        value: widget.selectedGender,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.wc, color: Color(0xFFFF9800)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          hintText: 'Select',
        ),
        validator: (value) => value == null ? 'Required' : null,
        isExpanded: true,
        dropdownColor: Colors.white,
        items: ['Male', 'Female', 'Unknown']
            .map((gender) => DropdownMenuItem(
                  value: gender.toLowerCase(),
                  child: Text(gender, style: GoogleFonts.poppins(fontSize: 14)),
                ))
            .toList(),
        onChanged: (value) => widget.onGenderChanged(value),
      ),
    );
  }

  Widget _buildSizeChips() {
    final sizes = ['Small', 'Medium', 'Large'];
    return Row(
      children: sizes.map((size) {
        final isSelected = widget.selectedSize == size;
        return Expanded(
          child: GestureDetector(
            onTap: () => widget.onSizeChanged(size),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFFFF9800), Color(0xFFFFB74D)])
                    : null,
                color: isSelected ? null : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      isSelected ? const Color(0xFFFF9800) : Colors.grey[300]!,
                  width: isSelected ? 2 : 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  size,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Pet Photos', '📸', isRequired: true),
        const SizedBox(height: 12),
        if (widget.selectedImages.isEmpty)
          GestureDetector(
            onTap: _pickImages,
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: Colors.grey[300]!,
                    width: 2,
                    style: BorderStyle.solid),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate,
                      size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  Text(
                    'Tap to add photos',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: widget.thumbnailImage != null
                      ? DecorationImage(
                          image: FileImage(widget.thumbnailImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: widget.thumbnailImage != null
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.5),
                            ],
                          ),
                        ),
                        child: const Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Chip(
                              label: Text('Thumbnail',
                                  style: TextStyle(color: Colors.white)),
                              backgroundColor: Color(0xFFFF9800),
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.selectedImages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == widget.selectedImages.length) {
                      return GestureDetector(
                        onTap: _pickImages,
                        child: Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[400]!),
                          ),
                          child: Icon(Icons.add,
                              size: 32, color: Colors.grey[600]),
                        ),
                      );
                    }

                    final image = widget.selectedImages[index];
                    final isThumbnail = image == widget.thumbnailImage;

                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () => _setThumbnail(index),
                          child: Container(
                            width: 80,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isThumbnail
                                    ? const Color(0xFFFF9800)
                                    : Colors.grey[300]!,
                                width: isThumbnail ? 3 : 1,
                              ),
                              image: DecorationImage(
                                image: FileImage(image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 12,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildFieldLabel(String text, String emoji,
      {String? subtitle, bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              const Text('*',
                  style: TextStyle(color: Colors.red, fontSize: 16)),
            ],
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
