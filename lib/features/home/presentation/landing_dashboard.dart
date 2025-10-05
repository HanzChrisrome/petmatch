import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petmatch/features/auth/provider/auth_provider.dart';
import 'package:petmatch/features/home/widgets/custom_bottom_navbar.dart';

class LandingDashboard extends ConsumerStatefulWidget {
  const LandingDashboard({super.key});

  @override
  ConsumerState<LandingDashboard> createState() => _LandingDashboardState();
}

class _LandingDashboardState extends ConsumerState<LandingDashboard> {
  int _selectedCategoryIndex = 0;
  int _selectedNavIndex = 0;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'All', 'icon': Icons.apps},
    {'name': 'Cat', 'icon': Icons.pets},
    {'name': 'Turtle', 'icon': Icons.cruelty_free},
    {'name': 'Dog', 'icon': Icons.pets},
    {'name': 'Bird', 'icon': Icons.flutter_dash},
  ];

  final List<Map<String, dynamic>> _pets = [
    {
      'name': 'Rocky Blaze',
      'gender': 'Female',
      'age': '8 months',
      'image': 'assets/pets/dog1.jpg',
      'color': const Color(0xFFFFF4E0),
    },
    {
      'name': 'Nova Meow',
      'gender': 'Male',
      'age': '2 years',
      'image': 'assets/pets/cat1.jpg',
      'color': const Color(0xFFE8E8E8),
    },
    {
      'name': 'Shadow',
      'gender': 'Male',
      'age': '1 year',
      'image': 'assets/pets/cat2.jpg',
      'color': const Color(0xFFFFE4F0),
    },
    {
      'name': 'Bella',
      'gender': 'Female',
      'age': '6 months',
      'image': 'assets/pets/dog2.jpg',
      'color': const Color(0xFFFFF4E0),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final userName = authState.userName ?? 'User';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Promotional Banner
                    _buildPromoBanner(),

                    const SizedBox(height: 24),

                    // Categories Section
                    _buildCategoriesSection(),

                    const SizedBox(height: 20),

                    // Pets Grid
                    _buildPetsGrid(),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // User Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),

          // Welcome Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back 👋',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const Text(
                  'Jobayer Mahbub',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Action Icons
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.search, size: 22),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.notifications_outlined, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF8B4513).withOpacity(0.9),
            const Color(0xFF654321),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '40% Off on Pet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Products',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Shop',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(right: Radius.circular(20)),
              child: Image.asset(
                'assets/banner_pet.jpg',
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    color: Colors.brown[300],
                    child:
                        const Icon(Icons.pets, size: 50, color: Colors.white),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'See All',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedCategoryIndex == index;
              final category = _categories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : _getCategoryColor(index),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          category['icon'],
                          color: isSelected ? Colors.white : Colors.grey[700],
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        category['name'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected ? Colors.black : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(int index) {
    final colors = [
      const Color(0xFFE8D4F8),
      const Color(0xFFFFF9C4),
      const Color(0xFFB2DFDB),
      const Color(0xFFFFCDD2),
      const Color(0xFFB3E5FC),
    ];
    return colors[index % colors.length];
  }

  Widget _buildPetsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _pets.length,
      itemBuilder: (context, index) {
        final pet = _pets[index];
        return _buildPetCard(pet);
      },
    );
  }

  Widget _buildPetCard(Map<String, dynamic> pet) {
    return Container(
      decoration: BoxDecoration(
        color: pet['color'],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pet Image
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                color: pet['color'],
              ),
              child: Center(
                child: Image.asset(
                  pet['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.pets,
                      size: 60,
                      color: Colors.grey[400],
                    );
                  },
                ),
              ),
            ),
          ),

          // Pet Info
          Expanded(
            flex: 1,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    pet['name'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${pet['gender']}  ${pet['age']}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
