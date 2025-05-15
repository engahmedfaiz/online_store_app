import 'package:flutter/material.dart';
import '../../network_image_with_loader.dart';

class BannerS extends StatelessWidget {
  const BannerS({
    super.key,
    required this.imageUrl, // تغيير الاسم إلى imageUrl
    required this.press,
    required this.children,
  });

  final String imageUrl; // تحديث اسم المتغير
  final VoidCallback press;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.56,
      child: GestureDetector(
        onTap: press,
        child: Stack(
          children: [
            NetworkImageWithLoader(imageUrl, radius: 0), // استخدام imageUrl
            Container(color: Colors.black45),
            ...children,
          ],
        ),
      ),
    );
  }
}