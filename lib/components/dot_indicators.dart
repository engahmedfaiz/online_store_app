import 'package:flutter/material.dart';

import '../constants.dart';
//
// class DotIndicator extends StatelessWidget {
//   const DotIndicator({
//     super.key,
//     this.isActive = false,
//     this.inActiveColor,
//     this.activeColor = primaryColor, required double size,
//   });
//
//   final bool isActive;
//
//   final Color? inActiveColor, activeColor;
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: defaultDuration,
//       height: isActive ? 12 : 4,
//       width: 4,
//       decoration: BoxDecoration(
//         color: isActive
//             ? activeColor
//             : inActiveColor ?? primaryMaterialColor.shade100,
//         borderRadius: const BorderRadius.all(Radius.circular(defaultPadding)),
//       ),
//     );
//   }
// }
class DotIndicator extends StatelessWidget {
  final bool isActive;
  final Color activeColor;
  final Color inActiveColor;
  final double size;

  const DotIndicator({
    super.key,
    required this.isActive,
    required this.activeColor,
    required this.inActiveColor,
    this.size = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inActiveColor,
        borderRadius: BorderRadius.circular(size / 2),
      ),
    );
  }
}