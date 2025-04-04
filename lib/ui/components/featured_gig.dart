import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FeaturedGig extends StatelessWidget {
  final String title;
  final String company;
  final String imagePath;
  final String location;
  final String salary;

  const FeaturedGig({
    Key? key,
    required this.title,
    required this.company,
    required this.imagePath,
    required this.location,
    required this.salary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      clipBehavior: Clip.antiAlias,
      // Add this to ensure content doesn't overflow
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Limit size to contents
        children: [
          // Image container with fixed dimensions
          Container(
            height: 99,
            width: double.infinity,
            color: Colors.blue.withOpacity(0.1),
            child: Center(
              child: Icon(
                LucideIcons.image,
                size: 40,
                color: Colors.blue.withOpacity(0.3),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Handle text overflow
                ),
                const SizedBox(height: 4),
                Text(
                  company,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Handle text overflow
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _FeaturedGigTag(
                        icon: LucideIcons.mapPin,
                        text: location,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _FeaturedGigTag(
                        icon: LucideIcons.dollarSign,
                        text: salary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedGigTag extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeaturedGigTag({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[700] : Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Take minimum required space
        children: [
          Icon(
            icon,
            size: 12,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis, // Handle text overflow
            ),
          ),
        ],
      ),
    );
  }
}
