import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shop/models/review_model.dart';
import 'package:shop/services/review_service.dart';

class ReviewListScreen extends StatefulWidget {
  final String storeId;

  const ReviewListScreen({super.key, required this.storeId});

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Review> _reviews = [];
  int _page = 1;
  bool _hasMore = true;
  bool _isLoading = false;
  bool _initialLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReviews();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _loadReviews({bool reset = false}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      final newReviews = await ReviewService.getReviews(
        storeId: widget.storeId,
        page: reset ? 1 : _page,
      );

      setState(() {
        if (reset) {
          _reviews.clear();
          _page = 1;
        }
        _reviews.addAll(newReviews);
        _hasMore = newReviews.length >= 10;
        if (!reset) _page++;
        _initialLoading = false;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent &&
        _hasMore &&
        !_isLoading) {
      _loadReviews();
    }
  }

  Future<void> _handleRefresh() async => _loadReviews(reset: true);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text('تقييمات المتجر'),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: _initialLoading
          ? _buildLottieLoadingIndicator()
          : RefreshIndicator(
        onRefresh: _handleRefresh,
        color: isDarkMode ? Colors.white : Colors.black,
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: ListView.separated(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                itemCount: _reviews.length + (_hasMore ? 1 : 0),
                separatorBuilder: (context, index) =>
                const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  if (index >= _reviews.length) {
                    return _buildLoadingMoreIndicator(isDarkMode);
                  }
                  return _buildReviewCard(_reviews[index], isDarkMode);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLottieLoadingIndicator() {
    return Center(
      child: Lottie.asset(
        'assets/icons/loading.json', // المسار إلى ملف Lottie في مجلد assets
        width: 250,
        height: 250,
        fit: BoxFit.contain,
        repeat: true,
        frameRate: FrameRate.max,
      ),
    );
  }

  Widget _buildLoadingMoreIndicator(bool isDarkMode) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircularProgressIndicator(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildReviewCard(Review review, bool isDarkMode) {
    return SizedBox(
      width: 300,
      child: Card(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    child: Text(
                      review.customerName?.substring(0, 1) ?? '?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      review.customerName ?? 'مستخدم مجهول',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildRatingStars(review.rating),
              if (review.comment != null && review.comment!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    review.comment!,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 24,
        );
      }),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}