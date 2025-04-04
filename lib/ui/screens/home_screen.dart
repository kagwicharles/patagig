import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:patagig/ui/components/category_chip.dart';
import 'package:patagig/ui/components/featured_gig.dart';
import 'package:patagig/ui/components/gig_tile.dart';
import 'package:patagig/ui/components/section_header.dart';
import 'package:patagig/ui/components/stat_card.dart';

class GigHomeScreen extends StatefulWidget {
  const GigHomeScreen({Key? key}) : super(key: key);

  @override
  State<GigHomeScreen> createState() => _GigHomeScreenState();
}

class _GigHomeScreenState extends State<GigHomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

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
      body: SafeArea(
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
                      children: const [
                        TextSpan(text: "Good morning, "),
                        TextSpan(
                          text: "Alex",
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                    borderSide:
                        BorderSide(color: theme.primaryColor, width: 1.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Stats cards
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: "Available Gigs",
                    value: "148",
                    icon: LucideIcons.briefcase,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: "Applied",
                    value: "12",
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
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CategoryChip(
                    label: 'Design',
                    icon: LucideIcons.penTool,
                    isSelected: true,
                  ),
                  CategoryChip(
                    label: 'Writing',
                    icon: LucideIcons.edit,
                  ),
                  CategoryChip(
                    label: 'Development',
                    icon: LucideIcons.code,
                  ),
                  CategoryChip(
                    label: 'Marketing',
                    icon: LucideIcons.barChart,
                  ),
                  CategoryChip(
                    label: 'More',
                    icon: LucideIcons.moreHorizontal,
                  ),
                ],
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
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  FeaturedGig(
                    title: 'UI/UX Designer',
                    company: 'Design Studio',
                    imagePath: 'assets/featured_gig.png',
                    location: 'Remote',
                    salary: '\$45/hr',
                  ),
                  FeaturedGig(
                    title: 'Frontend Developer',
                    company: 'Tech Solutions',
                    imagePath: 'assets/featured_gig.png',
                    location: 'Hybrid',
                    salary: '\$55/hr',
                  ),
                ],
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
            GigTile(
              title: 'Delivery Driver',
              subtitle: '1 hr delivery • 0.8 miles away',
              icon: LucideIcons.truck,
              tags: const ['Urgent', 'Part-time'],
            ),
            GigTile(
              title: 'Content Writer',
              subtitle: 'Freelance • Market Media • 1.2 miles',
              icon: LucideIcons.fileText,
              tags: const ['Remote', 'Fixed-price'],
            ),
            GigTile(
              title: 'IT Support',
              subtitle: 'Full-time • Tech Solutions • 2.5 miles',
              icon: LucideIcons.helpCircle,
              tags: const ['On-site', 'Full-time'],
            ),
            GigTile(
              title: 'Data Entry',
              subtitle: 'Remote • Admin Work • Flexible hours',
              icon: LucideIcons.keyboard,
              tags: const ['Remote', 'Part-time'],
            ),
          ],
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
              icon: Icon(LucideIcons.search),
              label: 'Explore',
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
        onPressed: () {},
        child: const Icon(LucideIcons.plus),
      ),
    );
  }
}
