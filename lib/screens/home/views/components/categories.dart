// // import 'package:flutter/material.dart';
// // import 'package:flutter_svg/flutter_svg.dart';
// // import 'package:shop/components/skleton/skelton.dart';
// // import 'package:shop/constants.dart';
// // import 'package:shop/models/category_model.dart';
// // import 'package:shop/services/api_service.dart';
// // import 'package:shop/route/screen_export.dart'; // تأكد من وجود هذا الاستيراد
// //
// // class Categories extends StatefulWidget {
// //   final String storeId;
// //
// //   const Categories({
// //     super.key,
// //     required this.storeId,
// //   });
// //
// //   @override
// //   State<Categories> createState() => _CategoriesState();
// // }
// //
// // class _CategoriesState extends State<Categories> {
// //   late Future<List<CategoryModel>> _categoriesFuture;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _categoriesFuture = ApiService.getCategories(widget.storeId);
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return FutureBuilder<List<CategoryModel>>(
// //       future: _categoriesFuture,
// //       builder: (context, snapshot) {
// //         if (snapshot.connectionState == ConnectionState.waiting) {
// //           return const _CategoriesSkeleton();
// //         }
// //
// //         if (snapshot.hasError || !snapshot.hasData) {
// //           return const Center(child: Text('Failed to load categories'));
// //         }
// //
// //         return _CategoriesList(
// //           categories: snapshot.data!,
// //           storeId: widget.storeId, // تمرير storeId هنا
// //         );
// //       },
// //     );
// //   }
// // }
// //
// // class _CategoriesList extends StatelessWidget {
// //   final List<CategoryModel> categories;
// //   final String storeId; // تم إضافة storeId هنا
// //
// //   const _CategoriesList({
// //     required this.categories,
// //     required this.storeId, // تأكد من تمرير storeId هنا
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SingleChildScrollView(
// //       scrollDirection: Axis.horizontal,
// //       child: Row(
// //         children: categories.map((category) =>
// //             Padding(
// //               padding: EdgeInsets.only(
// //                 left: categories.indexOf(category) == 0 ? defaultPadding : defaultPadding / 2,
// //                 right: categories.indexOf(category) == categories.length - 1 ? defaultPadding : 0,
// //               ),
// //               child: CategoryBtn(
// //                 category: category,
// //                 storeId: storeId, // تأكد من تمرير storeId هنا
// //               ),
// //             ),
// //         ).toList(),
// //       ),
// //     );
// //   }
// // }
// //
// // class CategoryBtn extends StatelessWidget {
// //   final CategoryModel category;
// //   final String storeId; // تم إضافة storeId هنا
// //
// //   const CategoryBtn({
// //     super.key,
// //     required this.category,
// //     required this.storeId, // تأكد من تمرير storeId هنا
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return InkWell(
// //       onTap: () => _handleCategoryPress(context),
// //       borderRadius: BorderRadius.circular(30),
// //       child: Container(
// //         height: 36,
// //         padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
// //         decoration: BoxDecoration(
// //           color: _isActive ? primaryColor : Colors.transparent,
// //           border: Border.all(color: _isActive ? Colors.transparent : Theme.of(context).dividerColor),
// //           borderRadius: BorderRadius.circular(30),
// //         ),
// //         child: Row(
// //           children: [
// //             if (category.imageUrl != null)
// //               Image.network(
// //                 category.imageUrl!,
// //                 height: 20,
// //                 width: 20,
// //                 errorBuilder: (_, __, ___) => const Icon(Icons.category),
// //               ),
// //             const SizedBox(width: defaultPadding / 2),
// //             Text(
// //               category.title,
// //               style: TextStyle(
// //                 fontSize: 12,
// //                 fontWeight: FontWeight.w500,
// //                 color: _isActive ? Colors.white : Theme.of(context).textTheme.bodyLarge!.color,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   void _handleCategoryPress(BuildContext context) {
// //     Navigator.pushNamed(
// //       context,
// //       '/DiscoverWithImageScreen',
// //       arguments: {
// //         'storeId': storeId, // تمرير storeId هنا
// //         'categoryId': category.id, // تأكد من تمرير categoryId هنا
// //         'title': category.title, // تأكد من تمرير title هنا
// //       },
// //     );
// //   }
// //
// //   bool get _isActive => category.isActive;
// // }
// //
// // class _CategoriesSkeleton extends StatelessWidget {
// //   const _CategoriesSkeleton();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SingleChildScrollView(
// //       scrollDirection: Axis.horizontal,
// //       child: Row(
// //         children: List.generate(
// //           5,
// //               (index) => Padding(
// //             padding: EdgeInsets.only(
// //               left: index == 0 ? defaultPadding : defaultPadding / 2,
// //               right: index == 4 ? defaultPadding : 0,
// //             ),
// //             child: const Skeleton(height: 36, width: 100),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:shop/components/skleton/skelton.dart';
// import 'package:shop/constants.dart';
// import 'package:shop/models/category_model.dart';
// import 'package:shop/services/api_service.dart';
// import 'package:shop/route/screen_export.dart';
//
// import '../../../../components/dot_indicators.dart';
//
// class Categories extends StatefulWidget {
//   final String storeId;
//
//   const Categories({
//     super.key,
//     required this.storeId,
//   });
//
//   @override
//   State<Categories> createState() => _CategoriesState();
// }
//
// class _CategoriesState extends State<Categories> {
//   late Future<List<CategoryModel>> _categoriesFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _categoriesFuture = ApiService.getCategories(widget.storeId);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<CategoryModel>>(
//       future: _categoriesFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const _CategoriesSkeleton();
//         }
//
//         if (snapshot.hasError) {
//           return const Center(child: Text('فشل تحميل التصنيفات'));
//         }
//
//         final categories = snapshot.data ?? [];
//
//         if (categories.isEmpty) {
//           return const Center(child: Text('لا توجد تصنيفات متاحة'));
//         }
//
//         return _CategoriesCarousel(
//           categories: categories,
//           storeId: widget.storeId,
//         );
//       },
//     );
//   }
// }
//
// class _CategoriesCarousel extends StatefulWidget {
//   final List<CategoryModel> categories;
//   final String storeId;
//
//   const _CategoriesCarousel({
//     required this.categories,
//     required this.storeId,
//   });
//
//   @override
//   State<_CategoriesCarousel> createState() => _CategoriesCarouselState();
// }
//
// class _CategoriesCarouselState extends State<_CategoriesCarousel> {
//   late final PageController _pageController;
//   Timer? _timer;
//   int _selectedIndex = 0;
//   bool _isDisposed = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController(initialPage: 0);
//     _startAutoScroll();
//   }
//
//   void _startAutoScroll() {
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
//       if (_isDisposed) return;
//
//       final newIndex = _selectedIndex < widget.categories.length - 1
//           ? _selectedIndex + 1
//           : 0;
//
//       if (_pageController.hasClients) {
//         _pageController.animateToPage(
//           newIndex,
//           duration: const Duration(milliseconds: 350),
//           curve: Curves.easeOutCubic,
//         ).then((_) {
//           if (!_isDisposed) {
//             setState(() => _selectedIndex = newIndex);
//           }
//         });
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _isDisposed = true;
//     _timer?.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1.87,
//       child: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           PageView.builder(
//             controller: _pageController,
//             itemCount: widget.categories.length,
//             onPageChanged: (int index) {
//               if (!_isDisposed) {
//                 setState(() => _selectedIndex = index);
//               }
//             },
//             itemBuilder: (context, index) => _CategorySlide(
//               category: widget.categories[index],
//               storeId: widget.storeId,
//             ),
//           ),
//           _buildIndicators(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildIndicators() {
//     return Padding(
//       padding: const EdgeInsets.all(defaultPadding),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: List.generate(
//           widget.categories.length,
//               (index) => DotIndicator(
//             isActive: index == _selectedIndex,
//             activeColor: Colors.white,
//             inActiveColor: Colors.white54,
//             size: 8.0,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _CategorySlide extends StatelessWidget {
//   final CategoryModel category;
//   final String storeId;
//
//   const _CategorySlide({
//     required this.category,
//     required this.storeId,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _handleCategoryPress(context),
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           image: DecorationImage(
//             image: category.imageUrl != null
//                 ? NetworkImage(category.imageUrl!)
//                 : const AssetImage('assets/images/placeholder.png') as ImageProvider,
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             gradient: LinearGradient(
//               begin: Alignment.bottomCenter,
//               end: Alignment.topCenter,
//               colors: [
//                 Colors.black.withOpacity(0.7),
//                 Colors.transparent,
//               ],
//             ),
//           ),
//           padding: const EdgeInsets.all(defaultPadding),
//           child: Align(
//             alignment: Alignment.bottomLeft,
//             child: Text(
//               category.title,
//               style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _handleCategoryPress(BuildContext context) {
//     if (category.id == null) return;
//
//     Navigator.pushNamed(
//       context,
//       '/DiscoverWithImageScreen',
//       arguments: {
//         'storeId': storeId,
//         'categoryId': category.id!,
//         'title': category.title,
//       },
//     );
//   }
// }
//
// class _CategoriesSkeleton extends StatelessWidget {
//   const _CategoriesSkeleton();
//
//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1.87,
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           color: Colors.grey.shade200,
//         ),
//       ),
//     );
//   }
// }
// ملف: categories.dart
import 'package:flutter/material.dart';
import 'package:shop/models/category_model.dart';
import 'sub_category_story_screen.dart';

class ProfessionalCategoriesCarousel extends StatelessWidget {
  final List<CategoryModel> categories;
  final PageController pageController;
  final int currentIndex;
  final String storeId;

  const ProfessionalCategoriesCarousel({
    super.key,
    required this.categories,
    required this.pageController,
    required this.currentIndex,
    required this.storeId,
  });


  void _handleCategoryTap(BuildContext context, CategoryModel category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SubCategoryStoryScreen(
          category: category,
          storeId: storeId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () => _handleCategoryTap(context, category),
            child: _CategoryCircle(category: category),
          );
        },
      ),
    );
  }
}

class _CategoryCircle extends StatelessWidget {
  final CategoryModel category;

  const _CategoryCircle({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: CircleAvatar(
        radius: 40,
        backgroundImage: category.imageUrl != null
            ? NetworkImage(category.imageUrl!)
            : const AssetImage('assets/placeholder.png') as ImageProvider,
      ),
    );
  }
}