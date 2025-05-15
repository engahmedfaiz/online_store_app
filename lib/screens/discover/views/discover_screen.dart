
import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/category_model.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/services/cart_service.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/services/shared_preferences.dart';

import '../../../services/sub_and_categery_api.dart';

class DiscoverScreen extends StatefulWidget {
  final String storeId;

  const DiscoverScreen({super.key, required this.storeId});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late Future<List<CategoryModel>> _categoriesFuture;
  late Future<List<ProductModel>> _productsFuture;
  String? _selectedCategoryId;
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = ApiService.getCategories(widget.storeId);
    _productsFuture = _loadProducts();
  }

  Future<List<ProductModel>> _loadProducts() async {
    try {
      final products = await ApiService.getProducts(
        widget.storeId,
        categoryId: _selectedCategoryId,
      );

      // تطبيق فلترة إضافية للتأكد من تطابق المنتجات مع القسم المحدد
      if (_selectedCategoryId != null) {
        return products.where((product) =>
        product.categoryId == _selectedCategoryId).toList();
      }
      return products;
    } catch (e) {
      debugPrint('Error loading products: $e');
      throw Exception('فشل في جلب المنتجات: $e');
    }
  }

  void _refreshProducts() {
    setState(() {
      _productsFuture = _loadProducts();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('اكتشف المنتجات', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view, color: primaryColor),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(child: _buildProductList()),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return FutureBuilder<List<CategoryModel>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final categories = snapshot.data!;

        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 16),
              ChoiceChip(
                label: const Text('الكل', style: TextStyle(color: Colors.white)),
                selected: _selectedCategoryId == null,
                selectedColor: primaryColor,
                backgroundColor: Colors.grey[400],
                onSelected: (_) => setState(() {
                  _selectedCategoryId = null;
                  _refreshProducts();
                }),
              ),
              ...categories.map((category) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ChoiceChip(
                  label: Text(category.title,
                      style: TextStyle(color: _selectedCategoryId == category.id ? Colors.white : Colors.black)),
                  selected: _selectedCategoryId == category.id,
                  selectedColor: primaryColor,
                  backgroundColor: Colors.grey[200],
                  onSelected: (_) => setState(() {
                    _selectedCategoryId = category.id;
                    _refreshProducts();
                  }),
                ),
              )).toList(),
              const SizedBox(width: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductList() {
    return FutureBuilder<List<ProductModel>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ: ${snapshot.error}'));
        }

        final products = snapshot.data!;
        if (products.isEmpty) {
          return Center(
            child: Text(
              _selectedCategoryId == null ? 'لا توجد منتجات متاحة' : 'لا توجد منتجات في هذا القسم',
              style: TextStyle(color: Colors.grey[600]),
            ),
          );
        }

        return _isGridView ? _buildGridView(products) : _buildListView(products);
      },
    );
  }

  Widget _buildGridView(List<ProductModel> products) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) => ProductGridItem(product: products[index]),
      ),
    );
  }

  Widget _buildListView(List<ProductModel> products) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) => ProductListItem(product: products[index]),
    );
  }
}

class ProductGridItem extends StatelessWidget {
  final ProductModel product;

  const ProductGridItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: product.imageUrl != null
                      ? Image.network(product.imageUrl!, fit: BoxFit.cover, width: double.infinity)
                      : Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.shopping_bag, size: 40, color: Colors.grey),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: FavoriteButton(productId: product.id),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${product.salePrice} ر.س',
                  style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                AddToCartButton(product: product),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductListItem extends StatelessWidget {
  final ProductModel product;

  const ProductListItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushNamed(context, productDetailsScreenRoute, arguments: product),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[100],
                  child: product.imageUrl != null
                      ? Image.network(product.imageUrl!, fit: BoxFit.cover)
                      : const Icon(Icons.shopping_bag, size: 30, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${product.salePrice} ر.س',
                      style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  FavoriteButton(productId: product.id),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 100,
                    child: AddToCartButton(product: product),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  final String productId;

  const FavoriteButton({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: FavoriteService.isFavorite(productId),
      builder: (context, snapshot) {
        final isFavorite = snapshot.data ?? false;
        return IconButton(
          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey),
          onPressed: () async {
            if (isFavorite) {
              await FavoriteService.removeFromFavorites(productId);
            } else {
              await FavoriteService.addToFavorites(productId);
            }
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(isFavorite
                    ? 'تمت الإزالة من المفضلة'
                    : 'تمت الإضافة إلى المفضلة')),
              );
            }
          },
        );
      },
    );
  }
}

class AddToCartButton extends StatelessWidget {
  final ProductModel product;

  const AddToCartButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryMaterialColor,
        padding: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () => _handleAddToCart(context),
      child: const Text('أضف إلى السلة', style: TextStyle(fontSize: 12)),
    );
  }

  Future<void> _handleAddToCart(BuildContext context) async {
    try {
      final isProductInCart = await CartService.isInCart(product.id);

      if (!isProductInCart) {
        await CartService.addToCart(product.toJson());
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ تمت إضافة المنتج إلى السلة")),
          );
        }
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ المنتج موجود مسبقًا في السلة")),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ فشل إضافة المنتج: ${e.toString()}")),
        );
      }
    }
  }
}