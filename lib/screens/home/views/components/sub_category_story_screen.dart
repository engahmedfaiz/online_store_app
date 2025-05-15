import 'package:flutter/material.dart';
import 'package:shop/models/sub_category_model.dart';
import 'package:shop/services/api_service.dart';

import '../../../../models/category_model.dart';

class SubCategoryStoryScreen extends StatefulWidget {
  final CategoryModel category;
  final String storeId;

  const SubCategoryStoryScreen({
    super.key,
    required this.category,
    required this.storeId,
  });

  @override
  State<SubCategoryStoryScreen> createState() => _SubCategoryStoryScreenState();
}

class _SubCategoryStoryScreenState extends State<SubCategoryStoryScreen> {
  late final PageController _pageController;
  late Future<List<SubCategoryModel>> _subCategoriesFuture;
  List<SubCategoryModel> _subCategories = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadSubCategories();
  }

  void _loadSubCategories() {
    _subCategoriesFuture = ApiService.getSubCategories(
      storeId: widget.storeId,
      categoryId: widget.category.id,
    ).then((data) {
      _subCategories = data;
      return data;
    });
  }

  void _handleSwipe(DragEndDetails details) {
    if (details.primaryVelocity == null) return;

    details.primaryVelocity! > 0 ? _previousStory() : _nextStory();
  }

  void _nextStory() {
    if (_currentIndex < _subCategories.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<List<SubCategoryModel>>(
        future: _subCategoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          }

          if (snapshot.hasError) {
            return _buildError(snapshot.error.toString());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmpty();
          }

          return _buildStoryContent(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildLoading() => Center(
    child: CircularProgressIndicator(
      color: Theme.of(context).colorScheme.primary,
    ),
  );

  Widget _buildError(String error) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'حدث خطأ: $error',
          style: const TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _loadSubCategories,
          child: const Text('إعادة المحاولة'),
        ),
      ],
    ),
  );

  Widget _buildEmpty() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'لا توجد فئات فرعية متاحة',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('العودة'),
        ),
      ],
    ),
  );

  Widget _buildStoryContent(List<SubCategoryModel> subCategories) {
    return GestureDetector(
      onHorizontalDragEnd: _handleSwipe,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: subCategories.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return _StoryCard(subCategory: subCategories[index]);
            },
          ),
          _buildStoryHeader(subCategories.length),
        ],
      ),
    );
  }

  Widget _buildStoryHeader(int total) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / total,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    widget.category.title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  final SubCategoryModel subCategory;

  const _StoryCard({required this.subCategory});

  @override
  Widget build(BuildContext context) { // أضف context هنا
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildImage(context), // أرسل context للدوال الفرعية
        _buildTitle(context),
      ],
    );
  }

  Widget _buildImage(BuildContext context) {
    return Image.network(
      subCategory.imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, progress) {
        return progress == null
            ? child
            : Center(
          child: CircularProgressIndicator(
            value: progress.cumulativeBytesLoaded /
                (progress.expectedTotalBytes ?? 1),
          ),
        );
      },
      errorBuilder: (_, __, ___) => Center(
        child: Icon(
          Icons.error_outline,
          color: Theme.of(context).colorScheme.error,
          size: 50,
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: Text(
        subCategory.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          shadows: const [
            Shadow(
              blurRadius: 10,
              color: Colors.black,
              offset: Offset(2, 2),
            )
          ],
        ),
      ),
    );
  }
}