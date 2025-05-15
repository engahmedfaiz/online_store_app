// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import '../banner_discount_tag.dart';
// import '../../../constants.dart';
// import 'banner_s.dart';
// import '../../../models/banner_model.dart'; // تأكد من استيراد النموذج
//
// class BannerSStyle1 extends StatelessWidget {
//   const BannerSStyle1({
//     super.key,
//     required this.banner, // استقبال النموذج كامل
//     required this.press,
//   });
//
//   final BannerModel banner;
//   final VoidCallback press;
//
//   @override
//   Widget build(BuildContext context) {
//     return BannerS(
//       imageUrl: banner.imageUrl, // استخدام imageUrl من النموذج
//       press: press,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(defaultPadding),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       banner.title.toUpperCase(), // استخدام title من النموذج
//                       style: const TextStyle(
//                         fontFamily: grandisExtendedFont,
//                         fontSize: 28,
//                         fontWeight: FontWeight.w900,
//                         color: Colors.white,
//                         height: 1,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     if (banner.subtitle != null)
//                       Padding(
//                         padding: const EdgeInsets.only(top: defaultPadding / 4),
//                         child: Text(
//                           banner.subtitle!.toUpperCase(),
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: defaultPadding),
//               _buildActionButton(),
//             ],
//           ),
//         ),
//         if (banner.discountPercentage != null && banner.discountPercentage! > 0)
//           Align(
//             alignment: Alignment.topCenter,
//             child: BannerDiscountTag(
//               percentage: banner.discountPercentage!,
//               height: 56,
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildActionButton() {
//     return SizedBox(
//       height: 48,
//       width: 48,
//       child: ElevatedButton(
//         onPressed: press,
//         style: ElevatedButton.styleFrom(
//           shape: const CircleBorder(),
//           backgroundColor: Colors.white,
//         ),
//         child: SvgPicture.asset(
//           "assets/icons/Arrow - Right.svg",
//           colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import '../banner_discount_tag.dart';
// import '../../../constants.dart';
// import 'banner_s.dart';
// import '../../../models/banner_model.dart'; // تأكد من استيراد النموذج
//
// class BannerSStyle1 extends StatelessWidget {
//   const BannerSStyle1({
//     super.key,
//     required this.banner, // استقبال النموذج كامل
//     required this.press,
//   });
//
//   final BannerModel banner;
//   final VoidCallback press;
//
//   @override
//   Widget build(BuildContext context) {
//     return BannerS(
//       imageUrl: banner.imageUrl, // استخدام imageUrl من النموذج
//       press: press,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(defaultPadding),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       banner.title.toUpperCase(), // استخدام title من النموذج
//                       style: const TextStyle(
//                         fontFamily: grandisExtendedFont,
//                         fontSize: 28,
//                         fontWeight: FontWeight.w900,
//                         color: Colors.white,
//                         height: 1,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     if (banner.subtitle != null)
//                       Padding(
//                         padding: const EdgeInsets.only(top: defaultPadding / 4),
//                         child: Text(
//                           banner.subtitle!.toUpperCase(),
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: defaultPadding),
//               _buildActionButton(),
//             ],
//           ),
//         ),
//         if (banner.discountPercentage != null && banner.discountPercentage! > 0)
//           Align(
//             alignment: Alignment.topCenter,
//             child: BannerDiscountTag(
//               percentage: banner.discountPercentage!,
//               height: 56,
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildActionButton() {
//     return SizedBox(
//       height: 48,
//       width: 48,
//       child: ElevatedButton(
//         onPressed: press,
//         style: ElevatedButton.styleFrom(
//           shape: const CircleBorder(),
//           backgroundColor: Colors.white,
//         ),
//         child: SvgPicture.asset(
//           "assets/icons/Arrow - Right.svg",
//           colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../banner_discount_tag.dart';
import '../../../constants.dart';
import 'banner_s.dart';
import '../../../models/banner_model.dart';

class BannerSStyle1 extends StatefulWidget {
  const BannerSStyle1({
    super.key,
    required this.banner,
    required this.press,
  });

  final BannerModel banner;
  final VoidCallback press;

  @override
  State<BannerSStyle1> createState() => _BannerSStyle1State();
}

class _BannerSStyle1State extends State<BannerSStyle1> {
  bool _showText = true;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // التبديل بين العناصر كل 3 ثوانٍ
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      setState(() => _showText = !_showText);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BannerS(
      imageUrl: widget.banner.imageUrl,
      press: widget.press,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _showText
              ? _buildTextOverlay()
              : _buildDiscountTag(),
        ),
      ],
    );
  }

  Widget _buildTextOverlay() {
    return Padding(
      key: const ValueKey('text'),
      padding: const EdgeInsets.all(defaultPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.banner.title.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: grandisExtendedFont,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.banner.subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: defaultPadding / 4),
                    child: Text(
                      widget.banner.subtitle!.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: defaultPadding),
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildDiscountTag() {
    return Align(
      key: const ValueKey('discount'),
      alignment: Alignment.topCenter,
      child: BannerDiscountTag(
        percentage: widget.banner.discountPercentage ?? 0,
        height: 56,
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      height: 48,
      width: 48,
      child: ElevatedButton(
        onPressed: widget.press,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: Colors.white,
        ),
        child: SvgPicture.asset(
          "assets/icons/Arrow - Right.svg",
          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
        ),
      ),
    );
  }
}
