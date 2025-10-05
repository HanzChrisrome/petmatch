import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:petmatch/features/auth/provider/auth_provider.dart';
import 'package:petmatch/features/home/widgets/custom_bottom_navbar.dart';

class ProfileDashboard extends ConsumerStatefulWidget {
  const ProfileDashboard({super.key});

  @override
  ConsumerState<ProfileDashboard> createState() => _ProfileDashboardState();
}

class _ProfileDashboardState extends ConsumerState<ProfileDashboard> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {
              // Handle settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Profile Avatar and Info
            CircleAvatar(
              radius: isSmallScreen ? 45 : 50,
              backgroundColor: Colors.grey[300],
              child: const Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
              // You can replace with Image.network or Image.asset for actual profile picture
            ),

            const SizedBox(height: 16),

            Text(
              authState.userName ?? 'Charlotte King',
              style: TextStyle(
                fontSize: isSmallScreen ? 20 : 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              authState.userEmail ?? '@johnkingraphics',
              style: TextStyle(
                fontSize: isSmallScreen ? 13 : 14,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 20),

            // Edit Profile Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: ElevatedButton(
                onPressed: () {
                  context.push('/home/profile-setup');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5757),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 32 : 40,
                    vertical: isSmallScreen ? 10 : 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Menu Items
            _buildMenuItem(
              icon: Icons.favorite_border,
              title: 'Lifestyle',
              onTap: () {
                context.push('/home/lifestyle-setup');
              },
            ),

            _buildMenuItem(
              icon: Icons.download_outlined,
              title: 'Preferences',
              onTap: () {
                context.push('/home/pet-preferences-setup');
              },
            ),

            _buildMenuItem(
              icon: Icons.language,
              title: 'Personality',
              onTap: () {
                context.push('/home/personality-setup');
              },
            ),

            _buildMenuItem(
              icon: Icons.location_on_outlined,
              title: 'Household',
              onTap: () {
                context.push('/home/household-setup');
              },
            ),

            _buildMenuItem(
              icon: Icons.card_membership_outlined,
              title: 'Responsibility',
              onTap: () {
                context.push('/home/responsibility-setup');
              },
            ),

            _buildMenuItem(
              icon: Icons.delete_outline,
              title: 'Pet Information',
              onTap: () {
                context.push('/home/pet-information');
              },
            ),

            _buildMenuItem(
              icon: Icons.history,
              title: 'Health Information',
              onTap: () {
                context.push('/home/pet-health-information');
              },
            ),

            _buildMenuItem(
              icon: Icons.history,
              title: 'Pet Activity Information',
              onTap: () {
                context.push('/home/pet-activity-information');
              },
            ),

            _buildMenuItem(
              icon: Icons.history,
              title: 'Pet Temperament Information',
              onTap: () {
                context.push('/home/pet-temperament-information');
              },
            ),

            _buildMenuItem(
              icon: Icons.history,
              title: 'Pet Behavior Information',
              onTap: () {
                context.push('/home/pet-behavior-information');
              },
            ),

            _buildMenuItem(
              icon: Icons.logout,
              title: 'Log out',
              textColor: const Color(0xFFFF5757),
              onTap: () {
                ref.read(authProvider.notifier).signOut(context);
              },
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 4),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: textColor ?? Colors.black87,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: textColor ?? Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
