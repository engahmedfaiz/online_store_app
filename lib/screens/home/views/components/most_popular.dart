import 'package:flutter/material.dart';
import 'package:shop/components/product/secondary_product_card.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/services/api_service.dart';

import '../../../../constants.dart';
import '../../../../route/route_constants.dart';

class MostPopular extends StatefulWidget {

  const MostPopular({super.key, required String storeId});

  @override
  State<MostPopular> createState() => _MostPopularState();
}

class _MostPopularState extends State<MostPopular> {
  final String storeId = "67fa545f6971a95b3e78f49b"; // استخدم المتجر المناسب
  List<ProductModel> products = [];

  @override
  void initState() {
    super.initState();
    fetchMostPopular();
  }

  void fetchMostPopular() async {
    try {
      final data = await ApiService.getProducts(storeId);
      setState(() {
        products = data.where((p) => p.isActive).toList(); // فلترة حسب الطلب
      });
    } catch (e) {
      print("خطأ في جلب المنتجات: $e");
    }
  }

  int calculateDiscount(double price, double sale) {
    final discount = ((price - sale) / price) * 100;
    return discount.round();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "Most popular",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        products.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
          height: 114,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding: EdgeInsets.only(
                  left: defaultPadding,
                  right: index == products.length - 1
                      ? defaultPadding
                      : 0,
                ),
                child: SecondaryProductCard(
                  image: product.imageUrl ?? "",
                  brandName: "", // أضف لاحقًا إذا متاح
                  title: product.title,
                  price: product.productPrice,
                  priceAfetDiscount: product.salePrice,
                  dicountpercent: calculateDiscount(
                    product.productPrice,
                    product.salePrice,
                  ),
                  press: () {
                    Navigator.pushNamed(
                      context,
                      productDetailsScreenRoute,
                      arguments: product,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
