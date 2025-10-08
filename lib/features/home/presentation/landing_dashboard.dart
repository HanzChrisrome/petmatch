import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';
import 'package:petmatch/features/auth/provider/auth_provider.dart';
import 'package:petmatch/features/home/provider/pets_provider/pet_provider.dart';
import 'package:petmatch/features/home/widgets/custom_bottom_navbar.dart';
import 'package:petmatch/features/home/widgets/pet_details_modal.dart';
import 'package:petmatch/core/model/pet_model.dart';

class LandingDashboard extends ConsumerStatefulWidget {
  const LandingDashboard({super.key});

  @override
  ConsumerState<LandingDashboard> createState() => _LandingDashboardState();
}

class _LandingDashboardState extends ConsumerState<LandingDashboard> {
  int _selectedCategoryIndex = 0;

  // Colors for pet cards
  final List<Color> _cardColors = [
    const Color(0xFFFFF4E0),
    const Color(0xFFE8E8E8),
    const Color(0xFFFFE4F0),
    const Color(0xFFE3F2FD),
    const Color(0xFFF3E5F5),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(petsProvider.notifier).fetchAllPets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final userName =
        authState.userName ?? authState.userEmail?.split('@').first ?? 'User';

    // Watch pets state
    final petsState = ref.watch(petsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(userName),
            Expanded(
              child: petsState.isLoading
                  ? Container(
                      color: Colors.white,
                      child: Center(
                        child: SizedBox(
                          width: 320,
                          height: 320,
                          child: Lottie.asset(
                            'assets/lottie/Catloading.json',
                            fit: BoxFit.contain,
                            repeat: true,
                          ),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (petsState.errorMessage != null)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  children: [
                                    Icon(Icons.error_outline,
                                        size: 48, color: Colors.red[300]),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Error loading pets',
                                      style: TextStyle(color: Colors.red[300]),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      petsState.errorMessage!,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600]),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    TextButton(
                                      onPressed: () {
                                        ref
                                            .read(petsProvider.notifier)
                                            .refresh();
                                      },
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildCategoryCards(),
                                _buildPetsGrid(petsState.pets ?? []),
                              ],
                            ),
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

  Widget _buildHeader(String userName) {
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
                Text(
                  userName,
                  style: const TextStyle(
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

  Widget _buildCategoryCards() {
    final categories = [
      {
        'title': 'Cat',
        'icon': Icons.pets,
        'index': 1,
      },
      {
        'title': 'Dog',
        'icon': Icons.pets,
        'index': 3,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: categories.map((category) {
          final isSelected = _selectedCategoryIndex == category['index'];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = category['index'] as int;
              });
              ref
                  .read(petsProvider.notifier)
                  .filterByCategory(category['title'] as String);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange[100] : Colors.grey[200],
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.orange : Colors.transparent,
                  width: 2,
                ),
              ),
              width: 64,
              height: 64,
              child: Icon(
                category['icon'] as IconData,
                size: 36,
                color: category['title'] == 'Cat'
                    ? Colors.pink[400]
                    : Colors.blue[400],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPetsGrid(List<Pet> pets) {
    if (pets.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(Icons.pets, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                'No pets found',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: pets.length,
      itemBuilder: (context, index) {
        final pet = pets[index];
        final cardColor = _cardColors[index % _cardColors.length];
        return _buildPetCard(pet, cardColor, index, pets);
      },
    );
  }

  Widget _buildPetCard(Pet pet, Color cardColor, int index, List<Pet> allPets) {
    return GestureDetector(
      onTap: () {
        showPetDetailsModal(context, allPets, index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet Image from Supabase Storage
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: CachedNetworkImage(
                  imageUrl: pet.thumbnailUrl ?? '',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.pets, size: 64, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),

            // Pet Info
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pet Name
                  Text(
                    pet.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 3),
                  // Gender and Age Category
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Gender
                      if (pet.gender != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              pet.gender?.toLowerCase() == 'male'
                                  ? Icons.male
                                  : Icons.female,
                              size: 12,
                              color: pet.gender?.toLowerCase() == 'male'
                                  ? Colors.blue[700]
                                  : Colors.pink[700],
                            ),
                            const SizedBox(width: 2),
                            Text(
                              pet.gender!,
                              style: TextStyle(
                                fontSize: 10,
                                color: pet.gender?.toLowerCase() == 'male'
                                    ? Colors.blue[700]
                                    : Colors.pink[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      // Age category
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: pet.ageCategory == 'Young'
                              ? Colors.green[50]
                              : Colors.orange[50],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: pet.ageCategory == 'Young'
                                ? Colors.green[300]!
                                : Colors.orange[300]!,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          pet.ageCategory,
                          style: TextStyle(
                            fontSize: 9,
                            color: pet.ageCategory == 'Young'
                                ? Colors.green[700]
                                : Colors.orange[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to clean breed text by removing emojis and extra info
  String _cleanBreedText(String breed) {
    // Remove emojis and flags
    String cleaned =
        breed.replaceAll(RegExp(r'[\u{1F300}-\u{1F9FF}]', unicode: true), '');
    cleaned =
        cleaned.replaceAll(RegExp(r'[\u{2600}-\u{26FF}]', unicode: true), '');
    cleaned =
        cleaned.replaceAll(RegExp(r'[\u{1F1E6}-\u{1F1FF}]', unicode: true), '');

    // Remove "BOTTOM OVERLORD BY" text
    cleaned =
        cleaned.replaceAll(RegExp(r'BOTTOM OVER[A-Z]+ BY \d+ PIXELS'), '');

    // Clean up extra spaces
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();

    return cleaned;
  }
}
