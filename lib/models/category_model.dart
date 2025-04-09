import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String name;
  final int gigCount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.gigCount,
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      gigCount: data['gigCount'] ?? 0,
    );
  }
}
