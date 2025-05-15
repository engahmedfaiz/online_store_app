// import 'package:flutter/material.dart';
// import '../../constants.dart';
// import '../network_image_with_loader.dart';
//
// class WholesaleProductCard extends StatelessWidget {
//   const WholesaleProductCard({
//     super.key,
//     required this.image,
//     required this.title,
//     required this.wholesalePrice,
//     required this.wholesaleQty,
//     required this.press,
//     required this.addToCart,
//   });
//
//   final String image, title;
//   final double wholesalePrice;
//   final int wholesaleQty;
//   final VoidCallback press;
//   final VoidCallback addToCart;
//
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: OutlinedButton(
//         onPressed: press,
//         style: OutlinedButton.styleFrom(
//           minimumSize: const Size(140, 230),
//           maximumSize: const Size(140, 230),
//           padding: const EdgeInsets.all(8),
//         ),
//         child: Column(
//           children: [
//             AspectRatio(
//               aspectRatio: 1.15,
//               child: NetworkImageWithLoader(image, radius: defaultBorderRadious),
//             ),
//             const SizedBox(height: 4),
//             Flexible(
//               fit: FlexFit.tight,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Tooltip(
//                     message: title,
//                     child: Text(
//                       title,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 11),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     "سعر الجملة: \$${wholesalePrice.toStringAsFixed(2)}",
//                     style: const TextStyle(
//                       fontSize: 11,
//                       color: Colors.green,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     "أقل كمية: $wholesaleQty قطعة",
//                     style: const TextStyle(
//                       fontSize: 10,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   const Spacer(),
//                   Align(
//                     alignment: Alignment.bottomLeft,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: primaryColor.withOpacity(0.1),
//                             blurRadius: 7,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: IconButton(
//                         icon: const Icon(Icons.add_shopping_cart,size: 20,),
//                         color: primaryColor,
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
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../network_image_with_loader.dart';

class WholesaleProductCard extends StatelessWidget {
  const WholesaleProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.wholesalePrice,
    required this.wholesaleQty,
    required this.press,
    required this.addToCart,
  });

  final String image, title;
  final double wholesalePrice;
  final int wholesaleQty;
  final VoidCallback press;
  final VoidCallback addToCart;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? Colors.grey[900] // أسود مائل للرمادي في الوضع الليلي
        : Colors.grey[100]; // أبيض مائل للرمادي في الوضع النهاري

    return Directionality(
      textDirection: TextDirection.rtl,
      child: OutlinedButton(
        onPressed: press,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          minimumSize: const Size(140, 230),
          maximumSize: const Size(140, 230),
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
              child:
              NetworkImageWithLoader(image, radius: defaultBorderRadious),
            ),
            const SizedBox(height: 4),
            Flexible(
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Tooltip(
                    message: title,
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "سعر الجملة: \$${wholesalePrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "أقل كمية: $wholesaleQty قطعة",
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,

                        // يتغير مع الثيم
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.1),
                            blurRadius: 7,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .backgroundColor,
                        icon: const Icon(Icons.add_shopping_cart, size: 20),
                        tooltip: 'إضافة إلى السلة',
                        padding: const EdgeInsets.all(5),
                        constraints: const BoxConstraints(),
                        onPressed: addToCart,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
