import 'package:flutter/material.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/screens/bookmark/views/ProductListItem.dart';
import 'package:shop/services/shared_preferences.dart';

import '../../../constants.dart';
import '../../../services/sub_and_categery_api.dart';

class BookmarkScreen extends StatefulWidget {
  final String storeId;
  const BookmarkScreen({super.key, required this.storeId});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  Future<void> _refreshFavorites() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المفضلة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _showClearAllDialog,
            tooltip: 'حذف الكل',
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: FavoriteService.getFavorites(),
        builder: (context, favoritesSnapshot) {
          if (!favoritesSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final favoriteIds = favoritesSnapshot.data!;
          if (favoriteIds.isEmpty) {
            return const Center(child: Text('لا توجد منتجات في المفضلة'));
          }

          return FutureBuilder<List<ProductModel>>(
            future: ApiService.getProductsByIds(favoriteIds,),
            builder: (context, productsSnapshot) {
              if (!productsSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final products = productsSnapshot.data!;
              return RefreshIndicator(
                onRefresh: _refreshFavorites,
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(products[index].id),
                      background: Container(
                        color: primaryColor,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        return await _showDeleteDialog(products[index].id);
                      },
                      onDismissed: (direction) {
                        FavoriteService.removeFromFavorites(products[index].id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('تم حذف ${products[index].title} من المفضلة'),
                          ),
                        );
                      },
                      child: ProductListItem(
                        product: products[index],
                        onDelete: () => _deleteProduct(products[index].id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _deleteProduct(String productId) async {
    final confirmed = await _showDeleteDialog(productId);
    if (confirmed == true) {
      await FavoriteService.removeFromFavorites(productId);
      _refreshFavorites();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم الحذف من المفضلة')),
      );
    }
  }

  Future<bool?> _showDeleteDialog(String productId) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف من المفضلة'),
        content: const Text('هل أنت متأكد أنك تريد حذف هذا المنتج من المفضلة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('حذف', style: TextStyle(color: primaryColor)),
          ),
        ],
      ),
    );
  }

  Future<void> _showClearAllDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الكل'),
        content: const Text('هل أنت متأكد أنك تريد حذف جميع المنتجات من المفضلة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('حذف الكل', style: TextStyle(color: primaryColor)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await FavoriteService.clearAllFavorites();
      _refreshFavorites();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حذف جميع المنتجات من المفضلة')),
      );
    }
  }
}
