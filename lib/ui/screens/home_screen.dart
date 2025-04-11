import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:patagig/ui/components/category_chip.dart';
import 'package:patagig/ui/components/featured_gig.dart';
import 'package:patagig/ui/components/gig_tile.dart';
import 'package:patagig/ui/components/section_header.dart';
import 'package:patagig/ui/components/stat_card.dart';
import 'package:patagig/models/gig_model.dart';
import 'package:patagig/models/category_model.dart';
import 'package:patagig/services/gig_service.dart';
import 'package:patagig/services/user_service.dart';

class GigHomeScreen extends StatefulWidget {
  const GigHomeScreen({Key? key}) : super(key: key);

  @override
  State<GigHomeScreen> createState() => _GigHomeScreenState();
}

class _GigHomeScreenState extends State<GigHomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  // Firebase instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Services
  late final GigService _gigService;
  late final UserService _userService;

  // Data
  String _userName = "";
  int? _availableGigsCount = 0;
  int? _appliedGigsCount = 0;
  List<CategoryModel> _categories = [];
  List<GigModel> _featuredGigs = [];
  List<GigModel> _nearbyGigs = [];
  bool _isLoading = true;
  String _selectedCategory = "Design"; // Default selected category

  @override
  void initState() {
    super.initState();
    _gigService = GigService();
    _userService = UserService();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get current user
      final user = _auth.currentUser;
      if (user != null) {
        // Load user data
        final userData = await _userService.getUserData(user.uid);
        if (userData != null) {
          setState(() {
            _userName = userData['name'] ?? "User";
          });
        }

        // Load gig stats
        final appliedGigsCount =
            await _gigService.getAppliedGigsCount(user.uid);
        final availableGigsCount = await _gigService.getAvailableGigsCount();

        // Load categories
        final categories = await _gigService.getCategories();

        // Load featured gigs
        final featuredGigs = await _gigService.getFeaturedGigs();

        // Load nearby gigs
        final nearbyGigs = await _gigService.getNearbyGigs(user.uid);

        // Update state with all loaded data
        setState(() {
          _userName = userData?['name'] ?? "User";
          _appliedGigsCount = appliedGigsCount;
          _availableGigsCount = availableGigsCount;
          _categories = categories;
          _featuredGigs = featuredGigs;
          _nearbyGigs = nearbyGigs;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _refreshGigs();
  }

  Future<void> _refreshGigs() async {
    final user = _auth.currentUser;
    if (user != null) {
      // Reload gigs based on the selected category
      final featuredGigs =
          await _gigService.getFeaturedGigsByCategory(_selectedCategory);
      final nearbyGigs = await _gigService.getNearbyGigsByCategory(
          user.uid, _selectedCategory);

      setState(() {
        _featuredGigs = featuredGigs;
        _nearbyGigs = nearbyGigs;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Gigs for You',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.bell),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child:
                  const Icon(LucideIcons.user, size: 18, color: Colors.black54),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAllData,
              child: SafeArea(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    // Welcome message
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                              children: [
                                const TextSpan(text: "Good morning, "),
                                TextSpan(
                                  text: _userName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Search bar with animation
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(LucideIcons.search),
                          suffixIcon: IconButton(
                            icon: const Icon(LucideIcons.sliders),
                            onPressed: () {},
                          ),
                          hintText: 'Search gigs...',
                          filled: true,
                          fillColor: isDark ? Colors.grey[800] : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                                color: theme.primaryColor, width: 1.0),
                          ),
                        ),
                        onChanged: (value) {
                          // Implement search functionality
                          if (value.length > 2) {
                            _gigService.searchGigs(value).then((results) {
                              setState(() {
                                _nearbyGigs = results;
                              });
                            });
                          } else if (value.isEmpty) {
                            _refreshGigs();
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Stats cards
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: "Available Gigs",
                            value: _availableGigsCount.toString(),
                            icon: LucideIcons.briefcase,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            title: "Applied",
                            value: _appliedGigsCount.toString(),
                            icon: LucideIcons.checkCircle,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Categories section
                    SectionHeader(title: 'Categories'),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 56,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          return CategoryChip(
                            label: category.name,
                            icon: _getCategoryIcon(category.name),
                            isSelected: _selectedCategory == category.name,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Featured Gigs
                    SectionHeader(
                      title: 'Featured Gigs',
                      actionText: 'View all',
                      onActionTap: () {},
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 220,
                      child: _featuredGigs.isEmpty
                          ? const Center(
                              child: Text('No featured gigs available'))
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _featuredGigs.length,
                              itemBuilder: (context, index) {
                                final gig = _featuredGigs[index];
                                return FeaturedGig(
                                  title: gig.title,
                                  company: gig.company,
                                  imagePath:
                                      gig.imageUrl ?? 'assets/featured_gig.png',
                                  location: gig.location,
                                  salary: gig.salary,
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 24),

                    // Nearby Gigs
                    SectionHeader(
                      title: 'Nearby Gigs',
                      actionText: 'Map view',
                      onActionTap: () {},
                    ),
                    const SizedBox(height: 12),

                    // Gig tiles
                    if (_nearbyGigs.isEmpty)
                      const Center(child: Text('No nearby gigs available'))
                    else
                      for (var gig in _nearbyGigs)
                        GigTile(
                          title: gig.title,
                          subtitle: gig.subtitle,
                          icon: _getGigIcon(gig.category),
                          tags: gig.tags,
                        ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(LucideIcons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.briefcase),
              label: 'My Gigs',
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.messageSquare),
              label: 'Messages',
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.user),
              label: 'Profile',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create gig page
          Navigator.pushNamed(context, '/create-gig');
        },
        child: const Icon(LucideIcons.plus),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Design':
        return LucideIcons.penTool;
      case 'Writing':
        return LucideIcons.edit;
      case 'Development':
        return LucideIcons.code;
      case 'Marketing':
        return LucideIcons.barChart;
      default:
        return LucideIcons.briefcase;
    }
  }

  IconData _getGigIcon(String category) {
    switch (category) {
      case 'Design':
        return LucideIcons.penTool;
      case 'Writing':
        return LucideIcons.fileText;
      case 'Development':
        return LucideIcons.code;
      case 'Marketing':
        return LucideIcons.barChart;
      case 'Delivery':
        return LucideIcons.truck;
      case 'Support':
        return LucideIcons.helpCircle;
      case 'Data':
        return LucideIcons.keyboard;
      default:
        return LucideIcons.briefcase;
    }
  }
}
