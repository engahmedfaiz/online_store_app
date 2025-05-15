import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/components/buy_full_ui_kit.dart';
import 'package:shop/components/custom_modal_bottom_sheet.dart';
import 'package:shop/components/product/product_card.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/screens/product/views/components/notify_me_card.dart';
import 'package:shop/screens/product/views/components/product_images.dart';
import 'package:shop/screens/product/views/components/product_info.dart';
import 'package:shop/screens/product/views/product_returns_screen.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/services/cart_service.dart';
import 'package:shop/services/shared_preferences.dart';

import '../../../components/review_card.dart';
import '../../product/views/components/product_list_tile.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final isFavorite = await FavoriteService.isFavorite(widget.product.id);
    if (mounted) {
      setState(() {
        _isFavorite = isFavorite;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await FavoriteService.removeFromFavorites(widget.product.id);
    } else {
      await FavoriteService.addToFavorites(widget.product.id);
    }

    if (mounted) {
      setState(() {
        _isFavorite = !_isFavorite;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isFavorite
              ? 'تمت الإضافة إلى المفضلة'
              : 'تمت الإزالة من المفضلة'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isAvailable =
        widget.product.productStock != null && widget.product.productStock! > 0;

    return Scaffold(
      bottomNavigationBar: isAvailable
          ? Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
          onPressed: _addToCart,
          icon: const Icon(Icons.shopping_cart),
          label: const Text("أضف إلى السلة"),
        ),
      )
          : NotifyMeCard(
        isNotify: false,
        onChanged: (value) {},
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                floating: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    onPressed: _toggleFavorite,
                    icon: SvgPicture.asset(
                      "assets/icons/Bookmark.svg",
                      color: _isFavorite
                          ? Colors.red
                          : Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                ],
              ),

              /// صور المنتج
              ProductImages(images: widget.product.productImages ?? []),

              /// معلومات المنتج
              ProductInfo(
                brand: "",
                title: widget.product.title,
                isAvailable: isAvailable,
                descripti: widget.product.descripti ?? "لا يوجد وصف",
                rating: 4.4,
                numOfReviews: 126,
              ),

              /// تفاصيل أخرى
              ProductListTile(
                svgSrc: "assets/icons/Product.svg",
                title: "تفاصيل المنتج",
                press: () {
                  customModalBottomSheet(
                    context,
                    height: MediaQuery.of(context).size.height * 0.92,
                    child: const BuyFullKit(
                      images: ["assets/screens/Product detail.png"],
                    ),
                  );
                },
              ),
              ProductListTile(
                svgSrc: "assets/icons/Delivery.svg",
                title: "معلومات الشحن",
                press: () {
                  customModalBottomSheet(
                    context,
                    height: MediaQuery.of(context).size.height * 0.92,
                    child: const BuyFullKit(
                      images: ["assets/screens/Shipping information.png"],
                    ),
                  );
                },
              ),
              ProductListTile(
                svgSrc: "assets/icons/Return.svg",
                title: "المرتجعات",
                isShowBottomBorder: true,
                press: () {
                  customModalBottomSheet(
                    context,
                    height: MediaQuery.of(context).size.height * 0.92,
                    child: const ProductReturnsScreen(),
                  );
                },
              ),

              /// التقييمات
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: ReviewCard(
                    rating: 4.3,
                    numOfReviews: 128,
                    numOfFiveStar: 80,
                    numOfFourStar: 30,
                    numOfThreeStar: 5,
                    numOfTwoStar: 4,
                    numOfOneStar: 1,
                  ),
                ),
              ),
              ProductListTile(
                svgSrc: "assets/icons/Chat.svg",
                title: "التقييمات",
                isShowBottomBorder: true,
                press: () {
                  Navigator.pushNamed(context, productReviewsScreenRoute);
                },
              ),

              /// اقتراح منتجات مشابهة
              SliverPadding(
                padding: const EdgeInsets.all(defaultPadding),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    "قد يعجبك أيضًا",
                    style: Theme.of(context).textTheme.titleSmall!,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(
                        left: defaultPadding,
                        right: index == 4 ? defaultPadding : 0,
                      ),
                      child: ProductCard(
                        image: widget.product.imageUrl ?? "",
                        title: widget.product.title,
                        descripti: widget.product.descripti ?? "",
                        price: widget.product.productPrice,
                        priceAfetDiscount: widget.product.salePrice,
                        dicountpercent: 25,
                        press: () {},
                        addToCart: _addToCart,
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: defaultPadding),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addToCart() async {
    try {
      final isProductInCart = await CartService.isInCart(widget.product.id);

      if (!isProductInCart) {
        await CartService.addToCart(widget.product.toJson());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("✅ تمت إضافة المنتج إلى السلة"),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("⚠️ المنتج موجود مسبقًا في السلة"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("❌ فشل إضافة المنتج: ${e.toString()}"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}