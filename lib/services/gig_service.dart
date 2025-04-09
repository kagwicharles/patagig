import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patagig/models/gig_model.dart';
import 'package:patagig/models/category_model.dart';
import 'package:geolocator/geolocator.dart';

class GigService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get count of available gigs
  Future<int?> getAvailableGigsCount() async {
    final snapshot = await _firestore.collection('gigs').count().get();
    return snapshot.count;
  }

  // Get count of gigs user has applied to
  Future<int?> getAppliedGigsCount(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('applications')
        .count()
        .get();
    return snapshot.count;
  }

  // Get all categories
  Future<List<CategoryModel>> getCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    return snapshot.docs
        .map((doc) => CategoryModel.fromFirestore(doc))
        .toList();
  }

  // Get featured gigs
  Future<List<GigModel>> getFeaturedGigs() async {
    final snapshot = await _firestore
        .collection('gigs')
        .where('isFeatured', isEqualTo: true)
        .limit(5)
        .get();
    return snapshot.docs.map((doc) => GigModel.fromFirestore(doc)).toList();
  }

  // Get featured gigs by category
  Future<List<GigModel>> getFeaturedGigsByCategory(String category) async {
    final snapshot = await _firestore
        .collection('gigs')
        .where('isFeatured', isEqualTo: true)
        .where('category', isEqualTo: category)
        .limit(5)
        .get();
    return snapshot.docs.map((doc) => GigModel.fromFirestore(doc)).toList();
  }

  // Get nearby gigs
  Future<List<GigModel>> getNearbyGigs(String userId) async {
    // Get user's location
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final userData = userDoc.data();

    if (userData != null && userData.containsKey('location')) {
      final userLocation = userData['location'] as GeoPoint;

      // Get current position
      Position position;
      try {
        position = await _determinePosition();
      } catch (e) {
        // If permission denied, use last known location
        final snapshot = await _firestore
            .collection('gigs')
            .orderBy('createdAt', descending: true)
            .limit(10)
            .get();
        return snapshot.docs.map((doc) => GigModel.fromFirestore(doc)).toList();
      }

      // Query gigs with location and calculate distance
      final snapshot = await _firestore.collection('gigs').get();
      final gigs =
          snapshot.docs.map((doc) => GigModel.fromFirestore(doc)).toList();

      // Calculate distance for each gig
      for (var gig in gigs) {
        if (gig.coordinates != null) {
          final distanceInMeters = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            gig.coordinates!.latitude,
            gig.coordinates!.longitude,
          );
          // Convert to miles
          final distanceInMiles = distanceInMeters / 1609.34;
          (gig as dynamic).distance = distanceInMiles;
        }
      }

      // Sort by distance
      gigs.sort((a, b) => ((a as dynamic).distance ?? double.infinity)
          .compareTo((b as dynamic).distance ?? double.infinity));

      return gigs.take(10).toList();
    } else {
      // Fallback if user location is not available
      final snapshot = await _firestore
          .collection('gigs')
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();
      return snapshot.docs.map((doc) => GigModel.fromFirestore(doc)).toList();
    }
  }

  // Get nearby gigs by category
  Future<List<GigModel>> getNearbyGigsByCategory(
      String userId, String category) async {
    final allNearby = await getNearbyGigs(userId);
    return allNearby.where((gig) => gig.category == category).toList();
  }

  // Search gigs
  Future<List<GigModel>> searchGigs(String query) async {
    query = query.toLowerCase();
    final snapshot = await _firestore.collection('gigs').get();
    final allGigs =
        snapshot.docs.map((doc) => GigModel.fromFirestore(doc)).toList();

    return allGigs
        .where((gig) =>
            gig.title.toLowerCase().contains(query) ||
            gig.company.toLowerCase().contains(query) ||
            gig.location.toLowerCase().contains(query) ||
            gig.category.toLowerCase().contains(query))
        .toList();
  }

  // Determine current position
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied';
    }

    return await Geolocator.getCurrentPosition();
  }
}
