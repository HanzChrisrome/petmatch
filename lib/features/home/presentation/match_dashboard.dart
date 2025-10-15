// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petmatch/core/model/pet_match_model.dart';
import 'package:petmatch/features/home/provider/match_provider/match_provider.dart';
import 'package:petmatch/features/home/widgets/ai_loader.dart';
import 'package:petmatch/features/home/widgets/pet_details_modal.dart';
import 'package:petmatch/features/home/widgets/custom_bottom_navbar.dart';
import 'package:petmatch/core/config/supabase_config.dart';
import 'package:petmatch/core/services/gemini_service.dart';

class MatchDashboard extends ConsumerStatefulWidget {
  const MatchDashboard({super.key});

  @override
  ConsumerState<MatchDashboard> createState() => _MatchDashboardState();
}

class _MatchDashboardState extends ConsumerState<MatchDashboard>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isListView = false; // Toggle between card and list view

  @override
  void initState() {
    super.initState();
    // Fetch matched pets
    Future.microtask(() => ref.read(matchProvider.notifier).fetchMatchedPets());
  }

  void _showPetDetailsFromList(int index) {
    final petMatches = ref.read(matchProvider).matches;
    // Only pass the matched pets, not all pets
    final matchedPets = petMatches.map((m) => m.pet).toList();
    showPetDetailsModal(
      context,
      matchedPets,
      index,
    );
  }

  Future<void> showAppleIntelligenceLoader(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => const AppleIntelligenceLoader(),
    );
  }

  Future<void> _showMatchExplanation(PetMatch petMatch) async {
    showAppleIntelligenceLoader(context);

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final userProfileData = await supabase
          .from('user_profile')
          .select('user_lifestyle, personality_traits, household_info')
          .eq('user_id', userId)
          .single();

      final userLifestyle =
          userProfileData['user_lifestyle'] as Map<String, dynamic>?;
      final userPersonality =
          userProfileData['personality_traits'] as Map<String, dynamic>?;
      final userHousehold =
          userProfileData['household_info'] as Map<String, dynamic>?;

      final geminiService = GeminiService();
      final explanation = await geminiService.generateMatchExplanation(
        petMatch,
        userLifestyle: userLifestyle,
        userPersonality: userPersonality,
        userHousehold: userHousehold,
      );

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      if (mounted) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => _AppleIntelligenceModal(
            petMatch: petMatch,
            explanation: explanation,
          ),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate explanation: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final matchState = ref.watch(matchProvider);
    final petMatches = matchState.matches;
    final isLoading = matchState.isLoading;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pet Matches',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isListView ? Icons.view_agenda : Icons.view_carousel,
                      color: Colors.deepOrange,
                    ),
                    onPressed: () {
                      setState(() {
                        _isListView = !_isListView;
                      });
                    },
                    tooltip: _isListView
                        ? 'Switch to Card View'
                        : 'Switch to List View',
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? _buildLoadingState()
                  : petMatches.isEmpty
                      ? _buildEmptyState()
                      : _isListView
                          ? _buildListView(petMatches)
                          : _buildCardView(petMatches),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
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

  // Card View with peeking side cards
  Widget _buildCardView(List<PetMatch> petMatches) {
    return PageView.builder(
      itemCount: petMatches.length,
      onPageChanged: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      controller: PageController(viewportFraction: 0.85),
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: PageController(viewportFraction: 0.85),
          builder: (context, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              child: GestureDetector(
                onTap: () => _showPetDetailsFromList(index),
                child: _buildPetCard(petMatches[index], isInteractive: true),
              ),
            );
          },
        );
      },
    );
  }

  // List View with horizontal cards
  Widget _buildListView(List<PetMatch> petMatches) {
    return ListView.builder(
      itemCount: petMatches.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showPetDetailsFromList(index),
          child: _buildHorizontalCard(petMatches[index]),
        );
      },
    );
  }

  Widget _buildHorizontalCard(PetMatch petMatch) {
    final pet = petMatch.pet;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Pet Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            child: SizedBox(
              width: 140,
              height: 140,
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
                        child:
                            Icon(Icons.pets, size: 40, color: Colors.grey[400]),
                      ),
                    )
                  : Container(
                      color: Colors.grey[200],
                      child:
                          Icon(Icons.pets, size: 40, color: Colors.grey[400]),
                    ),
            ),
          ),
          // Pet Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pet.name,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: petMatch.matchColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: petMatch.matchColor,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              petMatch.matchIcon,
                              color: petMatch.matchColor,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${petMatch.totalMatchPercent.toInt()}%',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: petMatch.matchColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.cake_outlined,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${pet.age ?? '?'} ${pet.ageUnit ?? 'years'}',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (pet.breed != null) ...[
                        const SizedBox(width: 12),
                        Icon(Icons.pets, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            pet.breed!,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (pet.description != null)
                    Expanded(
                      child: Text(
                        pet.description!,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[700],
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (pet.goodWithChildren == true)
                        _buildSmallTraitBadge('👶', Colors.blue),
                      if (pet.goodWithDogs == true)
                        _buildSmallTraitBadge('🐕', Colors.orange),
                      if (pet.goodWithCats == true)
                        _buildSmallTraitBadge('🐱', Colors.purple),
                      if (pet.energyLevel != null && pet.energyLevel! >= 7)
                        _buildSmallTraitBadge('⚡', Colors.green),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallTraitBadge(String emoji, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildPetCard(PetMatch petMatch, {required bool isInteractive}) {
    final pet = petMatch.pet;
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

            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: petMatch.matchColor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      petMatch.matchIcon,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${petMatch.totalMatchPercent.toInt()}%',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 20,
              left: 20,
              child: GestureDetector(
                onTap: () => _showMatchExplanation(petMatch),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.deepOrange,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Why?',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
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
                  // Pet Name
                  Text(
                    pet.name,
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _buildInfoChip(
                        '${pet.age ?? '?'} ${pet.ageUnit ?? 'years'}',
                        Icons.cake_outlined,
                      ),
                      if (pet.breed != null)
                        _buildInfoChip(pet.breed!, Icons.pets),
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
                  // Trait badges with Wrap to prevent overflow
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (pet.goodWithChildren == true)
                        _buildTraitBadge('👶 Kids', Colors.blue),
                      if (pet.goodWithDogs == true)
                        _buildTraitBadge('🐕 Dogs', Colors.orange),
                      if (pet.goodWithCats == true)
                        _buildTraitBadge('🐱 Cats', Colors.purple),
                      if (pet.energyLevel != null && pet.energyLevel! >= 7)
                        _buildTraitBadge('⚡ High Energy', Colors.green),
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
}

// Apple Intelligence Style Modal
class _AppleIntelligenceModal extends StatefulWidget {
  final PetMatch petMatch;
  final String explanation;

  const _AppleIntelligenceModal({
    required this.petMatch,
    required this.explanation,
  });

  @override
  State<_AppleIntelligenceModal> createState() =>
      _AppleIntelligenceModalState();
}

class _AppleIntelligenceModalState extends State<_AppleIntelligenceModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.9,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Rainbow gradient header + drag handle
              Column(
                children: [
                  const SizedBox(height: 12),
                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
              // Scrollable content
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF4D96FF),
                                    Color(0xFFB388FF),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'AI Match Insights',
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    'for ${widget.petMatch.pet.name}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close),
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Match Score Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.petMatch.matchColor.withOpacity(0.1),
                                widget.petMatch.matchColor.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  widget.petMatch.matchColor.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                widget.petMatch.matchIcon,
                                color: widget.petMatch.matchColor,
                                size: 32,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.petMatch.matchLabel,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: widget.petMatch.matchColor,
                                      ),
                                    ),
                                    Text(
                                      '${widget.petMatch.totalMatchPercent.toInt()}% compatibility',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Score Breakdown
                        _buildScoreBar(
                          'Lifestyle Match',
                          widget.petMatch.lifestyleScore,
                          const Color(0xFF4D96FF),
                        ),
                        const SizedBox(height: 12),
                        _buildScoreBar(
                          'Personality Fit',
                          widget.petMatch.personalityScore,
                          const Color(0xFFB388FF),
                        ),
                        const SizedBox(height: 12),
                        _buildScoreBar(
                          'Household Compatibility',
                          widget.petMatch.householdScore,
                          const Color(0xFF6BCF7F),
                        ),
                        const SizedBox(height: 12),
                        _buildScoreBar(
                          'Health & Care',
                          widget.petMatch.healthScore,
                          const Color(0xFFFFD93D),
                        ),
                        const SizedBox(height: 24),

                        // AI Explanation
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF4D96FF),
                                          Color(0xFFB388FF),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.psychology_outlined,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'AI Analysis',
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                widget.explanation,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBar(String label, double score, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Text(
              '${score.toInt()}%',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: score / 100,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
