import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'store.dart';
import 'review_view_model.dart';
import 'review.dart';

class ReviewPage extends ConsumerStatefulWidget {
  final Store store;

  const ReviewPage({super.key, required this.store});

  @override
  ConsumerState<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends ConsumerState<ReviewPage> {
  final TextEditingController _commentController = TextEditingController();

  void _sendComment() {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;

    final review = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      mapX: widget.store.mapX ?? 0.0,
      mapY: widget.store.mapY ?? 0.0,
      createdAt: DateTime.now(),
    );

    ref.read(reviewViewModelProvider).addReview(review);
    _commentController.clear();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reviewViewModel = ref.watch(reviewViewModelProvider);
    final allReviews = reviewViewModel.reviews;
    final reviews = allReviews
        .where(
          (review) =>
              review.mapX == widget.store.mapX &&
              review.mapY == widget.store.mapY,
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[50],
        title: Text(widget.store.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.content,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        DateFormat(
                          'yyyy-MM-dd HH:mm:ss.SSS',
                        ).format(review.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF3E5F5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.only(
            top: 12,
            bottom: MediaQuery.of(context).padding.bottom + 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    cursorColor: Colors.purple,
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.start,
                    onSubmitted: (_) => _sendComment(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Divider(height: 1, thickness: 2.5, color: Colors.purple),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
