import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shop/models/category_model.dart';
import '../../../constants.dart';
import 'banner_s.dart';
import '../../../models/banner_model.dart'; // تأكد من استيراد النموذج

class BannerSStyle5 extends StatelessWidget {
  const BannerSStyle5({
    super.key,
    required this.categories, // استقبال النموذج كامل
    required this.press,
  });

  final CategoryModel categories;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return BannerS(
      imageUrl: categories.imageUrl ?? '', // استخدام imageUrl من النموذج
      press: press,
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (categories.title != null)
                      _buildSubtitle(context),
                    const SizedBox(height: defaultPadding / 2),
                    _buildTitle(),
                    if (categories.description != null)
                      _buildBottomText(),
                  ],
                ),
              ),
              const SizedBox(width: defaultPadding *6),
              _buildIcon(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding / 2,
        vertical: defaultPadding / 8,
      ),
      color: primaryMaterialColor,
      child: Text(
        categories.title!,
        style: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      categories.title.toUpperCase(),
      style: const TextStyle(
        fontFamily: grandisExtendedFont,
        fontSize: 28,
        fontWeight: FontWeight.w900,
        color: Colors.white,
        height: 1,
      ),
    );
  }

  Widget _buildBottomText() {
    return Text(
      categories.description!,
      style: const TextStyle(
        fontFamily: grandisExtendedFont,
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildIcon() {
    return SvgPicture.asset(
      "assets/icons/miniRight.svg",
      height: 28,
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
    );
  }
}