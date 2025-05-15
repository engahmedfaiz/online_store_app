import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/models/category_model.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/services/api_service.dart';
import 'package:shop/services/cart_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final String storeId = "67fa545f6971a95b3e78f49b";
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;

  List<ProductModel> _allProducts = [];
  List<ProductModel> _filtered = [];
  List<CategoryModel> _allCategories = [];
  String? _selectedCategoryId;

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAllProductsAndCategories();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadAllProductsAndCategories() async {
    try {
      final products = await ApiService.getProducts(storeId);
      final categories = await ApiService.getCategories(storeId);
      setState(() {
        _allProducts = products.where((p) => p.isActive).toList();
        _filtered = List.from(_allProducts);
        _allCategories = categories;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'خطأ في التحميل: $e';
        _loading = false;
      });
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), _applyFilter);
  }

  void _onCategoryChanged(String? catId) {
    setState(() => _selectedCategoryId = catId);
    _applyFilter();
  }

  void _applyFilter() {
    final query = _controller.text.trim().toLowerCase();
    setState(() {
      _filtered = _allProducts.where((p) {
        final matchesText = query.isEmpty ||
            p.title.toLowerCase().contains(query) ||
            (p.descripti ?? '').toLowerCase().contains(query) ||
            p.tags.any((t) => t.toLowerCase().contains(query));
        final matchesCategory = _selectedCategoryId == null ||
            p.categoryId == _selectedCategoryId;
        return matchesText && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('بحث المنتجات')),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'اكتب اسم المنتج أو الكود...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _controller.text.isEmpty
                  ? null
                  : IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  _focusNode.requestFocus();
                  _applyFilter();
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
        ),

        // شريط اختيار التصنيف
        if (_allCategories.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ChoiceChip(
                    label: const Text('الكل'),
                    selected: _selectedCategoryId == null,
                    onSelected: (_) => _onCategoryChanged(null),
                  ),
                  const SizedBox(width: 8),
                  ..._allCategories.map((cat) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat.title),
                      selected: _selectedCategoryId == cat.id,
                      onSelected: (_) => _onCategoryChanged(cat.id),
                    ),
                  )),
                ],
              ),
            ),
          ),

        const SizedBox(height: 8),

        // المحتوى الرئيسي
        if (_loading)
          const Expanded(child: Center(child: CircularProgressIndicator()))
        else if (_error != null)
          Expanded(child: Center(child: Text(_error!, style: const TextStyle(color: Colors.red))))
        else if (_filtered.isEmpty)
            const Expanded(child: Center(child: Text('لم يتم العثور على نتائج')))
          else
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemCount: _filtered.length,
                itemBuilder: (context, index) {
                  final p = _filtered[index];
                  return ProductCard(
                    image: p.imageUrl ?? "",
                    descripti: p.descripti ?? "",
                    title: p.title,
                    price: p.productPrice,
                    priceAfetDiscount: p.salePrice,
                    dicountpercent: p.discountPercentage,
                    press: () {
                      Navigator.pushNamed(context, productDetailsScreenRoute, arguments: p);
                    },
                    addToCart: ()async {
                      // try {
                      //
                      //   final isProductInCart = await CartService.isInCart(product.id);
                      //
                      //   if (!isProductInCart) {
                      //     await CartService.addToCart(product.toJson());
                      //     if (context.mounted) {
                      //       ScaffoldMessenger.of(context).showSnackBar(
                      //         const SnackBar(
                      //           content: Text("✅ تمت إضافة المنتج إلى السلة"),
                      //           duration: Duration(seconds: 2),
                      //         ),
                      //       );
                      //     }
                      //   } else {
                      //     if (context.mounted) {
                      //       ScaffoldMessenger.of(context).showSnackBar(
                      //         const SnackBar(
                      //           content: Text("⚠️ المنتج موجود مسبقًا في السلة"),
                      //           duration: Duration(seconds: 2),
                      //         ),
                      //       );
                      //     }
                      //   }
                      // } catch (e) {
                      //   if (context.mounted) {
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       SnackBar(
                      //         content: Text("❌ فشل إضافة المنتج: ${e.toString()}"),
                      //         duration: const Duration(seconds: 2),
                      //       ),
                      //     );
                      //   }
                      // }
                    },

                  );
                },
              ),
            ),
      ]),
    );
  }
}
