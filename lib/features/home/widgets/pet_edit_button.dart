import 'package:flutter/material.dart';
import 'package:petmatch/core/model/pet_model.dart';
import 'package:petmatch/features/pet_profile/screens/add_pet_screen.dart';

/// A reusable widget that navigates to the edit pet screen
class PetEditButton extends StatelessWidget {
  final Pet pet;
  final IconData icon;
  final Color? color;
  final double? size;

  const PetEditButton({
    super.key,
    required this.pet,
    this.icon = Icons.edit,
    this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: size),
      color: color ?? Theme.of(context).colorScheme.primary,
      tooltip: 'Edit Pet',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddPetScreen(petToEdit: pet),
          ),
        );
      },
    );
  }
}
