import 'package:flutter/material.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/services/cart_service.dart';
import '../../../../components/product/product_card_flash.dart';
import '../../../../constants.dart';
import '../../../../models/product_model.dart';
import '../../../../services/api_service.dart';

class FlashSale extends StatefulWidget {
  final String storeId;

  const FlashSale({super.key,
  required this.storeId,
  });

  @override
  State<FlashSale> createState() => _FlashSaleState();
}

class _FlashSaleState extends State<FlashSale> {
  List<ProductModel> products = [];

  @override
  void initState() {
    super.initState();
    fetchFlashSaleProducts();
  }

  void fetchFlashSaleProducts() async {
    try {
      final data = await ApiService.getProducts(widget.storeId);
      setState(() {
        products = data.where((product) =>
        product.isActive &&
            product.wholesalePrice != null &&
            product.wholesalePrice! > 0 &&
            product.wholesaleQty != null &&
            product.wholesaleQty! > 0
        ).toList();
      });
    } catch (e) {
      print("خطأ في جلب المنتجات: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // دعم اللغة العربية
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: defaultPadding / 2),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Text(
              "تخفيضات الجملة",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontFamily: 'Cairo', // تأكد من إضافة الخط في pubspec.yaml
              ),
            ),
          ),
          products.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Padding(
                  padding: EdgeInsets.only(
                    right: defaultPadding,
                    left: index == products.length - 1
                        ? defaultPadding
                        : 0,
                  ),
                  child: WholesaleProductCard(
                    image: product.imageUrl ?? "",
                    title: product.title,
                    wholesalePrice: product.wholesalePrice!,
                    wholesaleQty: product.wholesaleQty ?? 1,
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
                          final cartItem = product.toJson();
                          cartItem['quantity'] = product.wholesaleQty ?? 1;
                          await CartService.addToCart(cartItem);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("✅ تمت إضافة المنتج بالجملة إلى السلة"),
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
        ],
      ),
    );
  }

  int calculateDiscount(double price, double sale) {
    final discount = ((price - sale) / price) * 100;
    return discount.round();
  }
}
