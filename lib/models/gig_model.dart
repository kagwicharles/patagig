import 'package:cloud_firestore/cloud_firestore.dart';

class GigModel {
  final String id;
  final String title;
  final String subtitle;
  final String company;
  final String location;
  final String salary;
  final String category;
  final String? imageUrl;
  final List<String> tags;
  final bool isFeatured;
  final GeoPoint? coordinates;
  final double? distance;

  GigModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.company,
    required this.location,
    required this.salary,
    required this.category,
    this.imageUrl,
    required this.tags,
    required this.isFeatured,
    this.coordinates,
    this.distance,
  });

  factory GigModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GigModel(
      id: doc.id,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      company: data['company'] ?? '',
      location: data['location'] ?? '',
      salary: data['salary'] ?? '',
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'],
      tags: List<String>.from(data['tags'] ?? []),
      isFeatured: data['isFeatured'] ?? false,
      coordinates: data['coordinates'] as GeoPoint?,
      distance: data['distance']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'company': company,
      'location': location,
      'salary': salary,
      'category': category,
      'imageUrl': imageUrl,
      'tags': tags,
      'isFeatured': isFeatured,
      'coordinates': coordinates,
    };
  }
}
