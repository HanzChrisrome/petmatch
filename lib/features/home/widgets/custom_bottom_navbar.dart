import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(context, Icons.home, 0, '/home'),
              _buildNavItem(
                  context, Icons.favorite_border, 1, '/home/match-dashboard'),
              _buildNavItem(context, Icons.calendar_today_outlined, 2,
                  '/home/edit-profile'),
              _buildNavItem(
                  context, Icons.person_outline, 3, '/home/profile-screen'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, IconData icon, int index, String route) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          context.go(route); // navigation handled here
        }
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Icon(
          icon,
          color: isSelected ? Colors.orange : Colors.grey[600],
          size: 26,
        ),
      ),
    );
  }
}
