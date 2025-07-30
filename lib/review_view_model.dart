import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'review.dart';
import 'review_repository.dart';

class ReviewViewModel extends ChangeNotifier {
  final ReviewRepository _repository = ReviewRepository();

  final List<Review> _reviews = [];
  List<Review> get reviews => List.unmodifiable(_reviews);

  Future<void> fetchReviewsByLocation(double mapX, double mapY) async {
    try {
      final fetchedReviews = await _repository.getReviewsByLocation(mapX, mapY);
      _reviews
        ..clear()
        ..addAll(fetchedReviews);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch reviews: $e');
      }
      rethrow;
    }
  }

  Future<void> addReview(Review review) async {
    try {
      await _repository.saveReview(review);
      _reviews.add(review);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to add review: $e');
      }
      rethrow;
    }
  }
}

final reviewViewModelProvider = ChangeNotifierProvider<ReviewViewModel>((ref) {
  return ReviewViewModel();
});
