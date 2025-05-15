
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/Banner/S/banner_s_style_1.dart';
import 'package:shop/components/Banner/S/banner_s_style_5.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/banner_model.dart';
import 'package:shop/models/category_model.dart';
import 'package:shop/route/screen_export.dart';
import 'package:shop/screens/home/views/components/ReviewListScreen.dart';
import 'package:shop/services/api_service.dart';
import 'package:shop/theme/theme_provider.dart';

import '../../../theme/theme_data.dart';
import 'components/flash_sale.dart';
import 'components/most_popular.dart';
import 'components/offer_carousel_and_categories.dart';
import 'components/popular_products.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  final String storeId;

  const HomeScreen({super.key, required this.storeId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BannerModel> banners = [];
  List<CategoryModel> categories = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final bannersData = await ApiService.getBanners(widget.storeId);
      final categoryData = await ApiService.getCategories(widget.storeId);

      setState(() {
        banners = bannersData;
        categories = categoryData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      body: SafeArea(
        child: _isLoading
            ? _buildLottieLoadingIndicator()
            : _errorMessage.isNotEmpty
            ? _buildErrorWidget()
            : _buildMainContent(),
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

  Widget _buildMainContent() {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: OffersCarouselAndCategories(storeId:widget.storeId),
        ),
        if (categories.isNotEmpty)
          SliverToBoxAdapter(
            child: Column(
              children: categories
                  .map(
                    (category) => BannerSStyle5(
                  categories: category,
                  press: () => _handleBannerPress(category),
                ),
              )
                  .toList(),
            ),
          ),
        SliverToBoxAdapter(
          child: PopularProducts(storeId: widget.storeId),
        ),
        SliverToBoxAdapter(
          child: FlashSale(storeId: widget.storeId),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 300,
            color: themeProvider.isDarkMode ? Colors.black : Colors.white,
            child: ReviewListScreen(storeId: widget.storeId),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage,
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadInitialData,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBannerPress(CategoryModel category) {
    Navigator.pushNamed(
      context,
      categoryProductsScreenRoute,
      arguments: {
        'categoryId': category.id,
        'title': category.title,
      },
    );
  }
}