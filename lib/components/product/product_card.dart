// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:shop/theme/input_decoration_theme.dart';
//
// import '../../constants.dart';
// import '../network_image_with_loader.dart';
//
// class ProductCard extends StatelessWidget {
//   const ProductCard({
//     super.key,
//     required this.image,
//     required this.descripti,
//     required this.addToCart,
//     required this.title,
//     required this.price,
//     this.priceAfetDiscount,
//     this.dicountpercent,
//     required this.press,
//   });
//
//   final VoidCallback addToCart;
//   final String image, descripti, title;
//   final double price;
//   final double? priceAfetDiscount;
//   final int? dicountpercent;
//   final VoidCallback press;
//
//   @override
//   Widget build(BuildContext context) {
//     return OutlinedButton(
//       onPressed: press,
//       style: OutlinedButton.styleFrom(
//         minimumSize: const Size(140, 220),
//         maximumSize: const Size(140, 220),
//         padding: const EdgeInsets.all(8),
//         side: BorderSide(
//           color: Theme.of(context).brightness == Brightness.dark
//               ? Colors.white.withOpacity(0.1)
//               : Colors.black.withOpacity(0.1),
//         ),
//       ),
//       child: Column(
//         children: [
//           AspectRatio(
//             aspectRatio: 1.15,
//             child: Stack(
//               children: [
//                 NetworkImageWithLoader(image, radius: defaultBorderRadious),
//                 if (dicountpercent != null)
//                   Positioned(
//                     right: defaultPadding / 2,
//                     top: defaultPadding / 2,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: defaultPadding / 2),
//                       height: 16,
//                       decoration: BoxDecoration(
//                         color: errorColor, // اللون المخصص للخصم
//                         borderRadius: const BorderRadius.all(
//                           Radius.circular(defaultBorderRadious),
//                         ),
//                       ),
//                       child: Text(
//                         "$dicountpercent% off",
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 10,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   )
//               ],
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                   horizontal: defaultPadding / 2, vertical: defaultPadding / 2),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: Theme.of(context)
//                         .textTheme
//                         .titleSmall!
//                         .copyWith(fontSize: 12, color: primaryColor), // تخصيص اللون هنا
//                   ),
//                   const SizedBox(height: defaultPadding / 2),
//                   Text(
//                     descripti.toUpperCase(),
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyMedium!
//                         .copyWith(fontSize: 10, color: primaryColor), // تخصيص لون النص هنا
//                   ),
//                   const Spacer(),
//                   priceAfetDiscount != null
//                       ? Row(
//                     children: [
//                       Text(
//                         "\$$priceAfetDiscount",
//                         style: TextStyle(
//                           color: primaryColor, // تخصيص اللون بعد الخصم
//                           fontWeight: FontWeight.w500,
//                           fontSize: 12,
//                         ),
//                       ),
//                       const SizedBox(width: defaultPadding / 4),
//                       Text(
//                         "\$$price",
//                         style: TextStyle(
//                           color: Theme.of(context)
//                               .textTheme
//                               .bodyMedium!
//                               .color,
//                           fontSize: 10,
//                           decoration: TextDecoration.lineThrough,
//                         ),
//                       ),
//                     ],
//                   )
//                       : Text(
//                     "\$$price",
//                     style: TextStyle(
//                       color: primaryColor, // تخصيص اللون هنا
//                       fontWeight: FontWeight.w500,
//                       fontSize: 12,
//                     ),
//                   ),
//                   const Spacer(),
//                   Align(
//                     alignment: Alignment.bottomLeft,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: primaryColor.withOpacity(0.1), // تخصيص الظل
//                             blurRadius: 7,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: IconButton(
//                         icon: const Icon(
//                           Icons.add_shopping_cart,
//                           size: 20,
//                         ),
//                         color: primaryColor, // تخصيص لون الأيقونة
//                         tooltip: 'إضافة إلى السلة',
//                         padding: const EdgeInsets.all(5),
//                         constraints: const BoxConstraints(),
//                         onPressed: addToCart,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/theme/input_decoration_theme.dart';

import '../../constants.dart';
import '../network_image_with_loader.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.image,
    required this.descripti,
    required this.addToCart,
    required this.title,
    required this.price,
    this.priceAfetDiscount,
    this.dicountpercent,
    required this.press,
  });

  final VoidCallback addToCart;
  final String image, descripti, title;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? Colors.grey[900] // خلفية داكنة مائلة للرمادي في الوضع الليلي
        : Colors.grey[100]; // خلفية فاتحة مائلة للرمادي في الوضع النهاري

    return Directionality(
      textDirection: TextDirection.rtl,
      child: OutlinedButton(
        onPressed: press,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          minimumSize: const Size(140, 220),
          maximumSize: const Size(140, 220),
          padding: const EdgeInsets.all(8),
          side: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.4)
                : Colors.black.withOpacity(0.4),
          ),
        ),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1.15,
              child: Stack(
                children: [
                  NetworkImageWithLoader(image, radius: defaultBorderRadious),
                  if (dicountpercent != null)
                    Positioned(
                      right: defaultPadding / 2,
                      top: defaultPadding / 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding / 2),
                        height: 16,
                        decoration: BoxDecoration(
                          color: errorColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(defaultBorderRadious),
                          ),
                        ),
                        child: Text(
                          "$dicountpercent% خصم",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding / 2,
                    vertical: defaultPadding / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 12, color: primaryColor),
                    ),
                    const SizedBox(height: defaultPadding / 2),
                    Text(
                      descripti.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontSize: 10, color: primaryColor),
                    ),
                    const Spacer(),
                    priceAfetDiscount != null
                        ? Row(
                      children: [
                        Text(
                          "\$$priceAfetDiscount",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: defaultPadding / 4),
                        Text(
                          "\$$price",
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .color,
                            fontSize: 10,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    )
                        : Text(
                      "\$$price",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,

                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.1),
                              blurRadius: 7,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.add_shopping_cart,
                            size: 20,
                          ),
                          color:
                          Theme.of(context).textTheme.bodyMedium!.backgroundColor,

                          tooltip: 'إضافة إلى السلة',
                          padding: const EdgeInsets.all(7),
                          constraints: const BoxConstraints(),
                          onPressed: addToCart,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
