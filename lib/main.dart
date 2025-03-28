import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class GigHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gigs'),
        actions: [
          IconButton(
            icon: Icon(LucideIcons.bell),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(LucideIcons.search),
                hintText: 'Search gigs...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CategoryChip(label: 'Design', icon: Icons.design_services),
                  CategoryChip(label: 'Writing', icon: Icons.edit),
                  CategoryChip(label: 'Tech', icon: Icons.computer),
                  CategoryChip(label: 'More', icon: Icons.more_horiz),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Featured Gigs',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            FeaturedGig(),
            SizedBox(height: 20),
            Text('Nearby Gigs',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView(
                children: [
                  GigTile(
                      title: 'Delivery Driver',
                      subtitle: '1 hr delivery',
                      icon: Icons.local_shipping),
                  GigTile(
                      title: 'Content Writing',
                      subtitle: 'Freelance • Market Media',
                      icon: Icons.article),
                  GigTile(
                      title: 'IT Support',
                      subtitle: 'Full-time • Tech Solutions',
                      icon: Icons.support),
                  GigTile(
                      title: 'Data Entry',
                      subtitle: 'Remote • Admin Work',
                      icon: Icons.keyboard),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const CategoryChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        avatar: Icon(icon, size: 16),
        label: Text(label),
      ),
    );
  }
}

class FeaturedGig extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                'assets/featured_gig.png',
                fit: BoxFit.cover,
                height: 99,
                width: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Illustration Design',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Part-time • Marc Studios',
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GigTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const GigTile(
      {required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(LucideIcons.chevronRight),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: GigHomeScreen(),
  ));
}
