import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user data
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data();
  }

  // Update user data
  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(userId).update(data);
  }

  // Get user applications
  Future<List<DocumentSnapshot>> getUserApplications(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('applications')
        .get();
    return snapshot.docs;
  }
}
