// lib/screens/product_screen.dart

import 'package:flutter/material.dart';
import 'package:shop/models/product_model.dart';  // تأكد من أنك قد أنشأت النموذج (model) المناسب
import 'package:shop/services/api_service.dart'; // API Service لجلب البيانات
class ProductScreen extends StatefulWidget {
  final String subcategoryId;
  final String subcategoryTitle;
  final String storeId;

  const ProductScreen({
    Key? key,
    required this.subcategoryId,
    required this.subcategoryTitle,
    required this.storeId,
  }) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late Future<List<ProductModel>> productsFuture;

  @override
  void initState() {
    super.initState();
    productsFuture = ApiService.getPrxoducts(
      subcategoryId: widget.subcategoryId,
      categoryId: widget.storeId, // استخدم storeId أو categoryId حسب ما هو مطلوب
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subcategoryTitle),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  leading: product.imageUrl!.isNotEmpty
                      ? Image.network(product.imageUrl ?? '', width: 50)
                      : Icon(Icons.image),
                  title: Text(product.title),
                  subtitle: Text(product.descripti.toString()),
                );
              },
            );
          }

          return const Center(child: Text('لا توجد منتجات'));
        },
      ),
    );
  }
}
