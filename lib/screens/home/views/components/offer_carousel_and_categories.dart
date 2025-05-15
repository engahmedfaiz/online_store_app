// import 'package:flutter/material.dart';
// import 'package:shop/constants.dart';
// import 'categories.dart';
// import 'offers_carousel.dart';
//
// class OffersCarouselAndCategories extends StatelessWidget {
//   final String storeId; // إضافة معامل storeId
//
//   const OffersCarouselAndCategories({
//     super.key,
//     required this.storeId, // جعله مطلوبًا
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // إزالة const لأن OffersCarousel يحتاج معاملات غير ثابتة
//         OffersCarousel(storeId: storeId),
//         const SizedBox(height: defaultPadding / 2),
//         Padding(
//           padding: const EdgeInsets.all(defaultPadding),
//           child: Text(
//             "Categories",
//             style: Theme.of(context).textTheme.titleSmall,
//           ),
//         ),
//         // إزالة const لأن Categories يحتاج معاملات غير ثابتة
//         Categories(storeId: storeId),
//       ],
//     );
//   }
// }
// ملف: offers_carousel_and_categories.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'categories.dart';
import 'offers_carousel.dart';
import 'package:shop/models/banner_model.dart';
import 'package:shop/models/category_model.dart';
import 'package:shop/services/api_service.dart';

class OffersCarouselAndCategories extends StatefulWidget {
  final String storeId;

  const OffersCarouselAndCategories({
    super.key,
    required this.storeId,
  });

  @override
  State<OffersCarouselAndCategories> createState() => _OffersCarouselAndCategoriesState();
}

class _OffersCarouselAndCategoriesState extends State<OffersCarouselAndCategories> {
  late final PageController _offersController;
  late final PageController _categoriesController;
  int _offersIndex = 0;
  int _categoriesIndex = 0;
  Timer? _timer;
  List<BannerModel> _banners = [];
  List<CategoryModel> _categories = [];
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _offersController = PageController();
    _categoriesController = PageController();
    _setupListeners();
    _loadData();
  }

  void _setupListeners() {
    _categoriesController.addListener(_handleCategoriesScroll);
  }

  void _handleCategoriesScroll() {
    if (!_categoriesController.hasClients) return;

    final page = _categoriesController.page ?? 0;
    final newIndex = page.round();

    if (newIndex != _categoriesIndex) {
      _syncOffersCarousel(newIndex);
    }
  }

  void _syncOffersCarousel(int categoriesIndex) {
    if (_banners.isEmpty || _categories.isEmpty) return;

    final ratio = categoriesIndex / (_categories.length - 1);
    final offersIndex = (ratio * (_banners.length - 1)).round();

    if (_offersController.hasClients) {
      _offersController.animateToPage(
        offersIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }

    setState(() {
      _categoriesIndex = categoriesIndex;
      _offersIndex = offersIndex;
    });
  }

  Future<void> _loadData() async {
    try {
      final banners = await ApiService.getBanners(widget.storeId);
      final categories = await ApiService.getCategories(widget.storeId);

      if (!_isDisposed) {
        setState(() {
          _banners = banners;
          _categories = categories;
        });

        if (_banners.isNotEmpty && _categories.isNotEmpty) {
          _startAutoScroll();
        }
      }
    } catch (e) {
      debugPrint("Error loading data: $e");
    }
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_isDisposed) return;

      final newIndex = (_categoriesIndex + 1) % _categories.length;
      _categoriesController.animateToPage(
        newIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _offersController.dispose();
    _categoriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OffersCarousel(
          // pageController: _offersController,
          // currentIndex: _offersIndex,
          storeId: widget.storeId,
        ),
        const SizedBox(height: defaultPadding),
        ProfessionalCategoriesCarousel(
          categories: _categories,
          pageController: _categoriesController,
          currentIndex: _categoriesIndex,
          storeId: widget.storeId,
        ),
      ],
    );
  }
}