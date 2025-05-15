import 'dart:convert';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shop/constants.dart';
import 'package:shop/models/StoreModel.dart';
import 'package:shop/route/screen_export.dart';
import 'package:shop/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:shop/theme/theme_data.dart';
import 'package:shop/theme/theme_provider.dart'; // استيراد Provider للتحكم في الـ ThemeMode

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  final String storeId = "67fa545f6971a95b3e78f49b";
  late List<Widget> _pages;
  Store? storeModel;
  Map<String, dynamic>? customizations;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(storeId: storeId),
      DiscoverScreen(storeId: storeId),
      BookmarkScreen(storeId: storeId),
      CartScreen(storeId: storeId),
      ProfileScreen(storeId: storeId),
    ];

    // جلب بيانات المتجر
    ApiService.fetchStore(storeId: storeId).then((store) {
      if (mounted && store != null) {
        setState(() {
          storeModel = store;
        });
      }
    });

    // جلب بيانات التخصيص
    ApiService.fetchStoreCustomizations(storeId: storeId).then((data) {
      if (mounted && data != null) {
        setState(() {
          customizations = data;
        });
      }
    });
  }

  Color get primaryColorFromCustomization {
    final colorHex = customizations?['primaryColor'];
    if (colorHex != null && colorHex is String) {
      return HexColor.fromHex(colorHex);
    }
    return primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    // SvgIcon function
    SvgPicture svgIcon(String src, {Color? color}) {
      return SvgPicture.asset(
        src,
        height: 24,
        colorFilter: ColorFilter.mode(
            color ?? Theme.of(context).iconTheme.color!.withOpacity(
                Theme.of(context).brightness == Brightness.dark ? 0.3 : 1),
            BlendMode.srcIn),
      );
    }

    // التبديل بين الوضع الليلي والنهاري
    void _toggleTheme() {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      themeProvider.toggleTheme();  // التبديل بين الوضعين
      debugPrint('Current theme: ${themeProvider.isDarkMode ? 'Dark' : 'Light'}');  // طباعة الوضع الحالي للتحقق
    }


    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: const SizedBox(),
          leadingWidth: 0,
          centerTitle: false,
          title: storeModel != null && storeModel!.profileImageUrl != null
              ? Row(
            children: [
              Image.network(
                storeModel!.profileImageUrl!,
                height: 40,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => SvgPicture.asset(
                  "assets/logo/Shoplon.svg",
                  height: 20,
                  width: 100,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).iconTheme.color!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(  // Wrap the Text widget with Flexible to prevent overflow
                child: Text(
                  storeModel!.businessName ?? "اسم المتجر",
                  style: Theme.of(context).textTheme.headline6,
                  overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                ),
              ),
            ],
          )
              : SvgPicture.asset(
            "assets/logo/Shoplon.svg",
            height: 20,
            width: 100,
            colorFilter: ColorFilter.mode(
              Theme.of(context).iconTheme.color!,
              BlendMode.srcIn,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.pushNamed(context, searchScreenRoute),
              icon: SvgPicture.asset(
                "assets/icons/Search.svg",
                height: 24,
                colorFilter: ColorFilter.mode(
                    Theme.of(context).textTheme.bodyLarge!.color!, BlendMode.srcIn),
              ),
              tooltip: 'بحث',
            ),
            IconButton(
              onPressed: () => Navigator.pushNamed(context, notificationsScreenRoute),
              icon: SvgPicture.asset(
                "assets/icons/Notification.svg",
                height: 24,
                colorFilter: ColorFilter.mode(
                    Theme.of(context).textTheme.bodyLarge!.color!, BlendMode.srcIn),
              ),
              tooltip: 'الإشعارات',
            ),
            // إضافة زر التبديل بين الوضعين
            IconButton(


                onPressed: () => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),

              icon: Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return Icon(
                    themeProvider.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                    size: 24,
                  );
                },
              ),
              tooltip: 'تبديل الوضع',
            ),



          ],
        ),
        body: PageTransitionSwitcher(
          duration: defaultDuration,
          transitionBuilder: (child, animation, secondAnimation) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondAnimation,
              child: child,
            );
          },
          child: _pages[_currentIndex],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(top: defaultPadding / 2),
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : const Color(0xFF101015),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : const Color(0xFF101015),
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            selectedItemColor: primaryColorFromCustomization,
            unselectedItemColor: Colors.grey,
            items: [
              BottomNavigationBarItem(
                icon: svgIcon("assets/icons/Shop.svg"),
                activeIcon: svgIcon("assets/icons/Shop.svg", color: primaryColorFromCustomization),
                label: "المتجر",
              ),
              BottomNavigationBarItem(
                icon: svgIcon("assets/icons/Category.svg"),
                activeIcon: svgIcon("assets/icons/Category.svg", color: primaryColorFromCustomization),
                label: "اكتشف",
              ),
              BottomNavigationBarItem(
                icon: svgIcon("assets/icons/Bookmark.svg"),
                activeIcon: svgIcon("assets/icons/Bookmark.svg", color: primaryColorFromCustomization),
                label: "المحفوظات",
              ),
              BottomNavigationBarItem(
                icon: svgIcon("assets/icons/Bag.svg"),
                activeIcon: svgIcon("assets/icons/Bag.svg", color: primaryColorFromCustomization),
                label: "السلة",
              ),
              BottomNavigationBarItem(
                icon: svgIcon("assets/icons/Profile.svg"),
                activeIcon: svgIcon("assets/icons/Profile.svg", color: primaryColorFromCustomization),
                label: "الملف الشخصي",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor.fromHex(final String hexColor) : super(_getColorFromHex(hexColor));
}
