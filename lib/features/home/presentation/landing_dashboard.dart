import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';
import 'package:petmatch/features/auth/provider/auth_provider.dart';
import 'package:petmatch/features/home/provider/pets_provider/pet_provider.dart';
import 'package:petmatch/features/home/widgets/custom_bottom_navbar.dart';
import 'package:petmatch/features/home/widgets/pet_details_modal.dart';
import 'package:petmatch/features/home/provider/favorites_provider.dart';
import 'package:petmatch/core/model/pet_model.dart';
import 'package:petmatch/widgets/info_banner.dart';

class LandingDashboard extends ConsumerStatefulWidget {
  const LandingDashboard({super.key});

  @override
  ConsumerState<LandingDashboard> createState() => _LandingDashboardState();
}

class _LandingDashboardState extends ConsumerState<LandingDashboard> {
  int _selectedCategoryIndex = 0;
  final ScrollController _scrollController = ScrollController();

  // Colors for pet cards
  final List<Color> _cardColors = [
    const Color(0xFFFFF4E0),
    const Color(0xFFE8E8E8),
    const Color(0xFFFFE4F0),
    const Color(0xFFE3F2FD),
    const Color(0xFFF3E5F5),
  ];

  final List<String> carouselImages = [
    'assets/carousel/first carousel.png',
    // Add more image paths
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(petsProvider.notifier).fetchInitialPets();
      ref.read(favoritesProvider.notifier).fetchFavorites();
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    const threshold = 300;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    final notifier = ref.read(petsProvider.notifier);
    final state = ref.read(petsProvider);

    if (maxScroll - currentScroll <= threshold) {
      if (!state.isFetchingMore && state.hasMore && !state.isLoading) {
        notifier.fetchMorePets();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final userName =
        authState.userName ?? authState.userEmail?.split('@').first ?? 'User';

    final petsState = ref.watch(petsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: petsState.isLoading
            ? Center(
                child: SizedBox(
                  width: 320,
                  height: 320,
                  child: Lottie.asset(
                    'assets/lottie/Catloading.json',
                    fit: BoxFit.contain,
                    repeat: true,
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await ref.read(petsProvider.notifier).refresh();
                },
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildHeader(userName),
                    const SizedBox(height: 20),
                    if (petsState.errorMessage != null)
                      _buildErrorSection(petsState.errorMessage!)
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCarouselHeader(),
                          const SizedBox(height: 10),
                          _buildCategoryCards(),
                          const InfoBanner(
                              message: 'Tap a pet card to view more details'),
                          _buildPetsGrid(petsState.filteredPets ?? []),
                          if (petsState.isFetchingMore)
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        ],
                      ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }

  Widget _buildCarouselHeader() {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        itemCount: carouselImages.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              carouselImages[index],
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(String userName) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[300],
          child: const Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome back 👋',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
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
      ],
    );
  }

  Widget _buildErrorSection(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text('Error loading pets',
                style: TextStyle(color: Colors.red[300])),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                ref.read(petsProvider.notifier).refresh();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCards() {
    final categories = [
      {'title': 'All', 'icon': Icons.all_inclusive, 'index': 0},
      {'title': 'Cat', 'icon': Icons.pets, 'index': 1},
      {'title': 'Dog', 'icon': Icons.pets, 'index': 2},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: categories.map((category) {
          final isSelected = _selectedCategoryIndex == category['index'];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = category['index'] as int;
              });
              final title = category['title'] as String;
              ref.read(petsProvider.notifier).filterByCategory(
                  title.toLowerCase() == 'all' ? 'all' : title);
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
              alignment: Alignment.center,
              child: Text(
                category['title'] == 'Cat'
                    ? '🐱'
                    : category['title'] == 'Dog'
                        ? '🐶'
                        : '🌟',
                style: const TextStyle(fontSize: 32),
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
              Text('No pets found',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600])),
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
    return Consumer(
      builder: (context, ref, _) {
        final favoritesState = ref.watch(favoritesProvider);
        final favoritesNotifier = ref.read(favoritesProvider.notifier);
        final isFavorite = favoritesState.favoriteIds.contains(pet.id);
        return GestureDetector(
          onTap: () => showPetDetailsModal(context, allPets, index),
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                        child: CachedNetworkImage(
                          imageUrl: pet.thumbnailUrl ?? '',
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                                child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.pets,
                                  size: 64, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () async {
                            if (isFavorite) {
                              await favoritesNotifier.removeFavorite(
                                  context, pet.id);
                            } else {
                              await favoritesNotifier.addFavorite(
                                  context, pet.id);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
      },
    );
  }
}
