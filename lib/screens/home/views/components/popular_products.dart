import 'package:flutter/material.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/models/category_model.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/services/cart_service.dart';
import '../../../../constants.dart';
import '../../../../services/sub_and_categery_api.dart';

class PopularProducts extends StatefulWidget {
  final String storeId;

  const PopularProducts({super.key, required this.storeId});

  @override
  State<PopularProducts> createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
  late ScrollController _scrollController;
  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];
  List<CategoryModel> categories = [];
  String? selectedCategoryId;
  int _selectedCategoryIndex = 0;
  String currentFilter = 'all';
  bool showPrevButton = false;
  bool showNextButton = true;
  bool isLoading = true;
  String? errorMessage;

  final Map<String, Map<String, dynamic>> filterOptions = {
    'all': {'label': 'الكل', 'icon': Icons.grid_view, 'color': Colors.grey},
    'newest': {'label': 'الأحدث', 'icon': Icons.access_time, 'color': Colors.blue},
    'bestSelling': {'label': 'الأكثر مبيعاً', 'icon': Icons.star, 'color': Colors.amber},
    'biggestDiscount': {'label': 'أكبر خصم', 'icon': Icons.bolt, 'color': Colors.red},
  };

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadInitialData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollController.addListener(_updateScrollButtons);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollButtons);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateScrollButtons() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    setState(() {
      showPrevButton = currentScroll > 10;
      showNextButton = currentScroll < maxScroll - 10;
    });
  }

  Future<void> _loadInitialData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final categories = await ApiService.getCategories(widget.storeId);
      final products = await ApiService.getProducts(
        widget.storeId,
        categoryId: selectedCategoryId,
      );

      setState(() {
        this.categories = categories;
        allProducts = products.where((p) => p.isActive).toList();
        filteredProducts = List.from(allProducts);

        debugPrint('Loaded ${categories.length} categories');
        debugPrint('Loaded ${allProducts.length} products');
        if (categories.isNotEmpty) {
          debugPrint('Category IDs: ${categories.take(3).map((c) => c.id).join(', ')}');
        }
        if (allProducts.isNotEmpty) {
          debugPrint('Product Category IDs: ${allProducts.take(3).map((p) => p.categoryId).join(', ')}');
        }
      });
      _applyFilters();
    } catch (e) {
      setState(() {
        errorMessage = 'خطأ في تحميل البيانات: ${e.toString()}';
      });
      debugPrint("Error loading data: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _applyFilters() {
    setState(() {
      // Apply category filter
      if (selectedCategoryId == null) {
        filteredProducts = List.from(allProducts);
      } else {
        filteredProducts = allProducts.where((product) {
          debugPrint('Matching: ${product.categoryId} == $selectedCategoryId');
          return product.categoryId == selectedCategoryId;
        }).toList();
      }

      // Apply sorting
      filteredProducts.sort((a, b) {
        switch (currentFilter) {
          case 'newest':
            return b.createdAt.compareTo(a.createdAt);
          case 'bestSelling':
            return (b.saleItems?.length ?? 0).compareTo(a.saleItems?.length ?? 0);
          case 'biggestDiscount':
            return b.discountPercentage.compareTo(a.discountPercentage);
          default:
            return 0;
        }
      });

      // Update error message
      if (filteredProducts.isEmpty) {
        errorMessage = selectedCategoryId == null
            ? 'لا توجد منتجات متاحة'
            : 'لا توجد منتجات في هذا القسم';
      } else {
        errorMessage = null;
      }
    });
  }

  void _scrollTo(double direction) {
    if (!_scrollController.hasClients) return;

    final scrollAmount = MediaQuery.of(context).size.width * 0.8;
    _scrollController.animateTo(
      _scrollController.offset + (direction * scrollAmount),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _handleCategorySelect(int index) {
    setState(() {
      _selectedCategoryIndex = index;
      selectedCategoryId = index == 0 ? null : categories[index - 1].id;
      debugPrint('Selected category: $selectedCategoryId');
    });
    _loadInitialData();
  }

  void _handleFilterSelect(String filterKey) {
    setState(() {
      currentFilter = filterKey;
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategoryTabs(),
        _buildFilterBar(),
        const SizedBox(height: 16),
        if (isLoading) _buildLoadingIndicator(),
        if (errorMessage != null) _buildErrorWidget(),
        if (!isLoading && errorMessage == null) _buildProductListWithScroll(),
      ],
    );
  }

  Widget _buildCategoryTabs() {
    if (categories.isEmpty) return const SizedBox();

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length + 1,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final isAllTab = index == 0;
            final isSelected = _selectedCategoryIndex == index;
            final categoryName = isAllTab ? 'الكل' : categories[index - 1].title;

            return Padding(
              padding: EdgeInsets.only(left: isAllTab ? 0 : 8, right: 8),
              child: ChoiceChip(
                label: Text(categoryName),
                selected: isSelected,
                onSelected: (_) => _handleCategorySelect(index),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.w500,
                ),
                selectedColor: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  Widget _buildFilterBar() {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filterOptions.length,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemBuilder: (context, index) {
            final key = filterOptions.keys.elementAt(index);
            final option = filterOptions[key]!;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(option['icon'], size: 16),
                    const SizedBox(width: 4),
                    Text(option['label']),
                  ],
                ),
                selected: currentFilter == key,
                onSelected: (_) => _handleFilterSelect(key),
                labelStyle: TextStyle(
                  color: currentFilter == key
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                selectedColor: option['color'],
                backgroundColor: Theme.of(context).cardColor,
                shape: StadiumBorder(
                  side: BorderSide(
                    color: currentFilter == key
                        ? option['color'] as Color
                        : Colors.grey[300]!,
                  ),
                ),
                showCheckmark: false,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadInitialData,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductListWithScroll() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // صفين
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.6,
          ),
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            return
              ProductCard(
              image: product.imageUrl ?? "",
              descripti: product.descripti ?? "",
              title: product.title,
              price: product.productPrice,
              priceAfetDiscount: product.salePrice,
              dicountpercent: product.discountPercentage,

              press: () {
                Navigator.pushNamed(
                  context,
                  productDetailsScreenRoute,
                  arguments: product,

                );
              },

                addToCart: ()async {
                try {
                  final isProductInCart = await CartService.isInCart(product.id);

                  if (!isProductInCart) {
                    await CartService.addToCart(product.toJson());
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("✅ تمت إضافة المنتج إلى السلة"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("⚠️ المنتج موجود مسبقًا في السلة"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("❌ فشل إضافة المنتج: ${e.toString()}"),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },

            );
          },
        ),
      ),
    );
  }


  Widget _buildProductList() {
      if (filteredProducts.isEmpty) {
        return Center(
          child: Text(
            'لا توجد منتجات في هذا القسم',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 18,
            ),
          ),
        );
      }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _updateScrollButtons();
          return false;
        },
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: filteredProducts.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            return Padding(
              padding: EdgeInsets.only(
                  left: index == filteredProducts.length - 1 ? 0 : 12),
              child: ProductCard(
                image: product.imageUrl ?? "",
                descripti: product.descripti ?? "",
                title: product.title,
                price: product.productPrice,
                priceAfetDiscount: product.salePrice,
                dicountpercent: product.discountPercentage,

                press: () {
                  Navigator.pushNamed(
                    context,
                    productDetailsScreenRoute,
                    arguments: product,
                  );
                },
                addToCart: ()async {
                  try {
                    final isProductInCart = await CartService.isInCart(product.id);

                    if (!isProductInCart) {
                      await CartService.addToCart(product.toJson());
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("✅ تمت إضافة المنتج إلى السلة"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("⚠️ المنتج موجود مسبقًا في السلة"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("❌ فشل إضافة المنتج: ${e.toString()}"),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },

              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildScrollButton(bool isPrev) {
    return Positioned(
      top: 80,
      left: isPrev ? 8 : null,
      right: isPrev ? null : 8,
      child: FloatingActionButton.small(
        heroTag: 'scroll_${isPrev ? 'left' : 'right'}',
        onPressed: () => _scrollTo(isPrev ? -1 : 1),
        backgroundColor: Colors.white,
        elevation: 2,
        child: Icon(
          isPrev ? Icons.chevron_left : Icons.chevron_right,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}



