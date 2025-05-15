// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:shop/components/list_tile/divider_list_tile.dart';
//
// class ProfileMenuListTile extends StatelessWidget {
//   const ProfileMenuListTile({
//     super.key,
//     required this.text,
//     required this.svgSrc,
//     required this.press,
//     this.isShowDivider = true, required bool isDarkMode,
//   });
//
//   final String text, svgSrc;
//   final VoidCallback press;
//   final bool isShowDivider;
//
//   @override
//   Widget build(BuildContext context) {
//     return DividerListTile(
//       minLeadingWidth: 24,
//       leading: SvgPicture.asset(
//         svgSrc,
//         height: 24,
//         width: 24,
//         colorFilter: ColorFilter.mode(
//           Theme.of(context).iconTheme.color!,
//           BlendMode.srcIn,
//         ),
//       ),
//       title: Text(
//         text,
//         style: const TextStyle(fontSize: 14, height: 1),
//       ),
//       press: press,
//       isShowDivider: isShowDivider,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/components/list_tile/divider_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/components/list_tile/divider_list_tile.dart';
class ProfileMenuListTile extends StatelessWidget {
  const ProfileMenuListTile({
    super.key,
    required this.text,
    required this.svgSrc,
    required this.press,
    this.isShowDivider = true,
  });

  final String text, svgSrc;
  final VoidCallback press;
  final bool isShowDivider;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return DividerListTile(
      minLeadingWidth: 24,
      leading: SvgPicture.asset(
        svgSrc,
        height: 24,
        width: 24,
        colorFilter: ColorFilter.mode(
          isDarkMode ? Colors.white : Colors.black,
          BlendMode.srcIn,
        ),
      ),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          height: 1,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      press: press,
      isShowDivider: isShowDivider,
    );
  }
}
