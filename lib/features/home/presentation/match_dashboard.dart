// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petmatch/core/model/pet_model.dart';
import 'package:petmatch/features/home/widgets/pet_details_modal.dart';
import 'package:petmatch/features/home/widgets/custom_bottom_navbar.dart';

class MatchDashboard extends ConsumerStatefulWidget {
  const MatchDashboard({super.key});

  @override
  ConsumerState<MatchDashboard> createState() => _MatchDashboardState();
}

class _MatchDashboardState extends ConsumerState<MatchDashboard>
    with TickerProviderStateMixin {
  List<Pet> _pets = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  // Animation controllers
  late AnimationController _scaleController;
  late AnimationController _swipeController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _swipeAnimation;

  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _loadPets();

    // Initialize animations
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _swipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _swipeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _swipeController, curve: Curves.easeOut));
  }

  Future<void> _loadPets() async {
    // TODO: Replace with actual data from your provider or API
    // For now, using mock data
    setState(() {
      _isLoading = false;
      // _pets will be loaded from your actual data source
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _swipeController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
    _scaleController.forward();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _scaleController.reverse();

    final screenWidth = MediaQuery.of(context).size.width;

    // If dragged more than 30% of screen width, swipe the card
    if (_dragOffset.dx.abs() > screenWidth * 0.3) {
      final isLike = _dragOffset.dx > 0;
      _swipeCard(isLike);
    } else {
      // Return to center
      setState(() {
        _dragOffset = Offset.zero;
        _isDragging = false;
      });
    }
  }

  void _swipeCard(bool isLike) {
    final screenWidth = MediaQuery.of(context).size.width;

    _swipeAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset(
          isLike ? screenWidth * 1.5 : -screenWidth * 1.5, _dragOffset.dy),
    ).animate(CurvedAnimation(parent: _swipeController, curve: Curves.easeOut));

    _swipeController.forward(from: 0).then((_) {
      setState(() {
        if (_currentIndex < _pets.length - 1) {
          _currentIndex++;
        }
        _dragOffset = Offset.zero;
        _isDragging = false;
      });
      _swipeController.reset();
    });

    // TODO: Send like/dislike to backend
    print(isLike ? '❤️ Liked' : '❌ Passed');
  }

  void _handleLike() {
    if (_currentIndex >= _pets.length) return;
    setState(() {
      _dragOffset = Offset(100, 0);
    });
    _swipeCard(true);
  }

  void _handlePass() {
    if (_currentIndex >= _pets.length) return;
    setState(() {
      _dragOffset = Offset(-100, 0);
    });
    _swipeCard(false);
  }

  void _handleSuperLike() {
    if (_currentIndex >= _pets.length) return;
    // TODO: Implement super like functionality
    print('⭐ Super Liked!');
  }

  void _showPetDetails() {
    if (_currentIndex < _pets.length) {
      showPetDetailsModal(
        context,
        _pets,
        _currentIndex,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _pets.isEmpty
                      ? _buildEmptyState()
                      : _buildCardStack(),
            ),
            _buildActionButtons(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '🐾 PetMatch',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.tune, size: 28),
                onPressed: () {
                  // TODO: Open filters
                },
              ),
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline, size: 28),
                onPressed: () {
                  // TODO: Open messages
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.deepOrange,
          ),
          const SizedBox(height: 20),
          Text(
            'Finding your perfect match...',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pets,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          Text(
            'No more pets to show',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Check back later for more matches!',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardStack() {
    return Stack(
      children: [
        // Show next 2 cards in background for depth effect
        if (_currentIndex + 2 < _pets.length)
          _buildBackgroundCard(_pets[_currentIndex + 2], 2),
        if (_currentIndex + 1 < _pets.length)
          _buildBackgroundCard(_pets[_currentIndex + 1], 1),
        // Current card
        if (_currentIndex < _pets.length)
          _buildSwipeableCard(_pets[_currentIndex]),
      ],
    );
  }

  Widget _buildBackgroundCard(Pet pet, int position) {
    final scale = 1.0 - (position * 0.03);
    final yOffset = position * 10.0;

    return Center(
      child: Transform.scale(
        scale: scale,
        child: Transform.translate(
          offset: Offset(0, yOffset),
          child: Opacity(
            opacity: 0.5,
            child: _buildPetCard(pet, isInteractive: false),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeableCard(Pet pet) {
    final offset =
        _swipeController.isAnimating ? _swipeAnimation.value : _dragOffset;

    final rotation = offset.dx / 1000;
    final opacity = 1.0 - (offset.dx.abs() / 500).clamp(0.0, 1.0);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Center(
          child: Transform.translate(
            offset: offset,
            child: Transform.rotate(
              angle: rotation,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: opacity,
                  child: GestureDetector(
                    onPanStart: _onPanStart,
                    onPanUpdate: _onPanUpdate,
                    onPanEnd: _onPanEnd,
                    onTap: _showPetDetails,
                    child: Stack(
                      children: [
                        _buildPetCard(pet, isInteractive: true),
                        // Like/Nope overlay
                        if (_isDragging && offset.dx.abs() > 20)
                          _buildSwipeOverlay(offset.dx > 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSwipeOverlay(bool isLike) {
    return Positioned.fill(
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isLike ? Colors.green : Colors.red,
            width: 5,
          ),
        ),
        child: Align(
          alignment: isLike ? Alignment.topLeft : Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Transform.rotate(
              angle: isLike ? -0.3 : 0.3,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isLike ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isLike ? 'LIKE' : 'NOPE',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPetCard(Pet pet, {required bool isInteractive}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(
          children: [
            // Pet Image
            Positioned.fill(
              child: pet.thumbnailUrl != null
                  ? CachedNetworkImage(
                      imageUrl: pet.thumbnailUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.pets, size: 80, color: Colors.grey[400]),
                            const SizedBox(height: 10),
                            Text(
                              'No image available',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.pets, size: 80, color: Colors.grey[400]),
                          const SizedBox(height: 10),
                          Text(
                            'No image available',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
            ),

            // Gradient overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Pet Info
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pet.name,
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isInteractive)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.info_outline,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoChip(
                        '${pet.age ?? '?'} ${pet.ageUnit ?? 'years'}',
                        Icons.cake_outlined,
                      ),
                      const SizedBox(width: 8),
                      if (pet.breed != null)
                        _buildInfoChip(pet.breed!, Icons.pets),
                      const SizedBox(width: 8),
                      if (pet.size != null)
                        _buildInfoChip(pet.size!, Icons.straighten),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (pet.description != null)
                    Text(
                      pet.description!,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (pet.goodWithChildren == 'Yes')
                        _buildTraitBadge('👶 Kids', Colors.blue),
                      if (pet.goodWithDogs == 'Yes')
                        _buildTraitBadge('🐕 Dogs', Colors.orange),
                      if (pet.goodWithCats == 'Yes')
                        _buildTraitBadge('🐱 Cats', Colors.purple),
                      if (pet.energyLevel != null && pet.energyLevel! >= 7)
                        _buildTraitBadge('⚡ High Energy', Colors.green),
                    ],
                  ),
                ],
              ),
            ),

            // Distance badge (top-left)
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.red),
                    const SizedBox(width: 4),
                    Text(
                      '5 km',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTraitBadge(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final isDisabled = _currentIndex >= _pets.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Pass button
          _buildActionButton(
            icon: Icons.close,
            color: Colors.red,
            size: 60,
            iconSize: 32,
            onPressed: isDisabled ? null : _handlePass,
          ),
          // Super Like button
          _buildActionButton(
            icon: Icons.star,
            color: Colors.blue,
            size: 50,
            iconSize: 28,
            onPressed: isDisabled ? null : _handleSuperLike,
          ),
          // Like button
          _buildActionButton(
            icon: Icons.favorite,
            color: Colors.green,
            size: 60,
            iconSize: 32,
            onPressed: isDisabled ? null : _handleLike,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required double size,
    required double iconSize,
    VoidCallback? onPressed,
  }) {
    final isDisabled = onPressed == null;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey[300] : Colors.white,
          shape: BoxShape.circle,
          boxShadow: isDisabled
              ? []
              : [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
          border: Border.all(
            color: isDisabled ? Colors.grey[400]! : color,
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          color: isDisabled ? Colors.grey[500] : color,
          size: iconSize,
        ),
      ),
    );
  }
}
