import 'package:flutter/material.dart';
import 'package:shop/components/product/product_card_ver.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/services/cart_service.dart';
import 'package:shop/services/sub_and_categery_api.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categoryId;
  final String categoryTitle;

  const CategoryProductsScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  List<ProductModel> products = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCategoryProducts();
  }

  Future<void> _loadCategoryProducts() async {
    try {
      final String storeId = "67fa545f6971a95b3e78f49b";

      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final productsData = await ApiService.getCategoryProducts(
        storeId: storeId,
        categoryId: widget.categoryId,
      );

      setState(() {
        products = productsData
            .where((p) => p.isActive && p.categoryId == widget.categoryId)
            .toList();
      });
    } catch (e) {
      setState(() {
        errorMessage = 'خطأ في تحميل منتجات القسم: ${e.toString()}';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryTitle),
        centerTitle: true,
      ),
      body: _buildProductList(),
    );
  }

  Widget _buildProductList() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Text(
          errorMessage!,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      );
    }

    if (products.isEmpty) {
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
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ProductCardHor(
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
              addToCart: () async {
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
    );
  }
}








































// mport 'package:flutter/material.dart';
// import 'package:shop/components/product/product_card_ver.dart';
// import 'package:shop/models/product_model.dart';
// import 'package:shop/route/route_constants.dart';
// import 'package:shop/services/cart_service.dart';
// import 'package:shop/services/sub_and_categery_api.dart';
//
// class CategoryProductsScreen extends StatefulWidget {
//   final String categoryId;
//   final String categoryTitle;
//
//   const CategoryProductsScreen({
//     super.key,
//     required this.categoryId,
//     required this.categoryTitle,
//   });
//
//   @override
//   State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
// }
//
// class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
//
//   List<ProductModel> products = [];
//   bool isLoading = true;
//   String? errorMessage;
//
//   @override
//   void didChangeDependencies() {
//
//     _loadCategoryProducts();
//   }
//
//   Future<void> _loadCategoryProducts() async {
//     try {
//       final String storeId = "67fa545f6971a95b3e78f49b";
//
//       setState(() {
//         isLoading = true;
//         errorMessage = null;
//       });
//
//       final productsData = await ApiService.getCategoryProducts(
//         storeId: storeId,
//         categoryId: widget.categoryId,
//       );
//
//       setState(() {
//         // تأكد من فلترة المنتجات بالقسم يدويًا
//         products = productsData
//             .where((p) => p.isActive && p.categoryId == widget.categoryId)
//             .toList();
//       });
//     } catch (e) {
//       setState(() {
//         errorMessage = 'خطأ في تحميل منتجات القسم: ${e.toString()}';
//       });
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.categoryTitle),
//         centerTitle: true,
//       ),
//       body: _buildProductList(),
//     );
//   }
//
//   Widget _buildProductList() {
//     if (isLoading) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }
//
//     if (errorMessage != null) {
//       return Center(
//         child: Text(
//           errorMessage!,
//           style: TextStyle(
//             color: Theme.of(context).textTheme.bodyLarge?.color,
//           ),
//         ),
//       );
//     }
//
//     if (products.isEmpty) {
//       return Center(
//         child: Text(
//           'لا توجد منتجات في هذا القسم',
//           style: TextStyle(
//             color: Colors.grey[600],
//             fontSize: 18,
//           ),
//         ),
//       );
//     }
//
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: GridView.builder(
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 12,
//             mainAxisSpacing: 12,
//             childAspectRatio: 0.6,
//           ),
//           itemCount: products.length,
//           itemBuilder: (context, index) {
//             final product = products[index];
//             return ProductCard(
//               image: product.imageUrl ?? "",
//               descripti: product.descripti ?? "",
//               title: product.title,
//               price: product.productPrice,
//               priceAfetDiscount: product.salePrice,
//               dicountpercent: product.discountPercentage,
//               press: () {
//                 Navigator.pushNamed(
//                   context,
//                   productDetailsScreenRoute,
//                   arguments: product,
//                 );
//               },
//               addToCart: () async {
//                 try {
//                   final isProductInCart = await CartService.isInCart(product.id);
//
//                   if (!isProductInCart) {
//                     await CartService.addToCart(product.toJson());
//                     if (context.mounted) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("✅ تمت إضافة المنتج إلى السلة"),
//                           duration: Duration(seconds: 2),
//                         ),
//                       );
//                     }
//                   } else {
//                     if (context.mounted) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("⚠️ المنتج موجود مسبقًا في السلة"),
//                           duration: Duration(seconds: 2),
//                         ),
//                       );
//                     }
//                   }
//                 } catch (e) {
//                   if (context.mounted) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text("❌ فشل إضافة المنتج: ${e.toString()}"),
//                         duration: const Duration(seconds: 2),
//                       ),
//                     );
//                   }
//                 }
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
//
// import 'package:flutter/material.dart';
// import 'package:shop/components/product/product_card_ver.dart';
// import 'package:shop/models/product_model.dart';
// import 'package:shop/route/route_constants.dart';
// import 'package:shop/services/cart_service.dart';
// import 'package:shop/services/sub_and_categery_api.dart';
//
// class CategoryProductsScreen extends StatefulWidget {
//   final String categoryId;
//   final String categoryTitle;
//
//   const CategoryProductsScreen({
//     super.key,
//     required this.categoryId,
//     required this.categoryTitle,
//   });
//
//   @override
//   State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
// }
//
// class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
//
//   List<ProductModel> products = [];
//   bool isLoading = true;
//   String? errorMessage;
//
//   @override
//   void didChangeDependencies() {
//
//     _loadCategoryProducts();
//   }
//
//   Future<void> _loadCategoryProducts() async {
//     try {
//       final String storeId = "67fa545f6971a95b3e78f49b";
//
//       setState(() {
//         isLoading = true;
//         errorMessage = null;
//       });
//
//       final productsData = await ApiService.getCategoryProducts(
//         storeId: storeId,
//         categoryId: widget.categoryId,
//       );
//
//       setState(() {
//         // تأكد من فلترة المنتجات بالقسم يدويًا
//         products = productsData
//             .where((p) => p.isActive && p.categoryId == widget.categoryId)
//             .toList();
//       });
//     } catch (e) {
//       setState(() {
//         errorMessage = 'خطأ في تحميل منتجات القسم: ${e.toString()}';
//       });
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.categoryTitle),
//         centerTitle: true,
//       ),
//       body: _buildProductList(),
//     );
//   }
//
//   Widget _buildProductList() {
//     if (isLoading) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }
//
//     if (errorMessage != null) {
//       return Center(
//         child: Text(
//           errorMessage!,
//           style: TextStyle(
//             color: Theme.of(context).textTheme.bodyLarge?.color,
//           ),
//         ),
//       );
//     }
//
//     if (products.isEmpty) {
//       return Center(
//         child: Text(
//           'لا توجد منتجات في هذا القسم',
//           style: TextStyle(
//             color: Colors.grey[600],
//             fontSize: 18,
//           ),
//         ),
//       );
//     }
//
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: GridView.builder(
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 12,
//             mainAxisSpacing: 12,
//             childAspectRatio: 0.6,
//           ),
//           itemCount: products.length,
//           itemBuilder: (context, index) {
//             final product = products[index];
//             return ProductCard(
//               image: product.imageUrl ?? "",
//               descripti: product.descripti ?? "",
//               title: product.title,
//               price: product.productPrice,
//               priceAfetDiscount: product.salePrice,
//               dicountpercent: product.discountPercentage,
//               press: () {
//                 Navigator.pushNamed(
//                   context,
//                   productDetailsScreenRoute,
//                   arguments: product,
//                 );
//               },
//               addToCart: () async {
//                 try {
//                   final isProductInCart = await CartService.isInCart(product.id);
//
//                   if (!isProductInCart) {
//                     await CartService.addToCart(product.toJson());
//                     if (context.mounted) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("✅ تمت إضافة المنتج إلى السلة"),
//                           duration: Duration(seconds: 2),
//                         ),
//                       );
//                     }
//                   } else {
//                     if (context.mounted) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text("⚠️ المنتج موجود مسبقًا في السلة"),
//                           duration: Duration(seconds: 2),
//                         ),
//                       );
//                     }
//                   }
//                 } catch (e) {
//                   if (context.mounted) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text("❌ فشل إضافة المنتج: ${e.toString()}"),
//                         duration: const Duration(seconds: 2),
//                       ),
//                     );
//                   }
//                 }
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
