import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'review.dart';

class ReviewRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save or add review data to Firestore under 'reviews' collection
  Future<void> saveReview(Review review) async {
    try {
      final docRef = (review.id.isNotEmpty)
          ? _firestore.collection('reviews').doc(review.id)
          : _firestore.collection('reviews').doc();

      await docRef.set(review.toJson());
    } catch (e) {
      debugPrint('Error saving review: $e');
      rethrow;
    }
  }

  // Alias for saveReview (optional)
  Future<void> addReview(Review review) async {
    return saveReview(review);
  }

  // Retrieve list of reviews matching the given mapX and mapY coordinates
  Future<List<Review>> getReviewsByLocation(double mapX, double mapY) async {
    try {
      final querySnapshot = await _firestore
          .collection('reviews')
          .where('mapX', isEqualTo: mapX)
          .where('mapY', isEqualTo: mapY)
          .get();

      return querySnapshot.docs
          .map((doc) => Review.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error fetching reviews: $e');
      rethrow;
    }
  }
}
