// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import 'package:shop/components/Banner/M/banner_m_style_1.dart';
// // import 'package:shop/components/dot_indicators.dart';
// // import 'package:shop/constants.dart';
// // import 'package:shop/models/banner_model.dart';
// // import 'package:shop/services/api_service.dart';
// //
// // class OffersCarousel extends StatefulWidget {
// //   final String storeId;
// //
// //   const OffersCarousel({
// //     super.key,
// //     required this.storeId,
// //   });
// //
// //   @override
// //   State<OffersCarousel> createState() => _OffersCarouselState();
// // }
// //
// // class _OffersCarouselState extends State<OffersCarousel> {
// //   late final PageController _pageController;
// //   Timer? _timer; // Changed to nullable
// //   List<BannerModel> _banners = [];
// //   int _selectedIndex = 0;
// //   bool _isDisposed = false; // Track widget disposal
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _pageController = PageController(initialPage: 0);
// //     _loadBanners();
// //   }
// //
// //   Future<void> _loadBanners() async {
// //     try {
// //       final banners = await ApiService.getBanners(widget.storeId);
// //       if (!_isDisposed) { // Check if widget is still mounted
// //         setState(() => _banners = banners);
// //         if (_banners.isNotEmpty) {
// //           _startAutoScroll();
// //         }
// //       }
// //     } catch (e) {
// //       debugPrint("Error loading banners: $e");
// //     }
// //   }
// //
// //   void _startAutoScroll() {
// //     _timer?.cancel(); // Cancel any existing timer
// //     _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
// //       if (_isDisposed) return; // Exit if widget is disposed
// //
// //       final newIndex = _selectedIndex < _banners.length - 1
// //           ? _selectedIndex + 1
// //           : 0;
// //
// //       if (_pageController.hasClients) { // Check if controller is attached
// //         _pageController.animateToPage(
// //           newIndex,
// //           duration: const Duration(milliseconds: 350),
// //           curve: Curves.easeOutCubic,
// //         ).then((_) {
// //           if (!_isDisposed) {
// //             setState(() => _selectedIndex = newIndex);
// //           }
// //         });
// //       }
// //     });
// //   }
// //
// //   Widget _buildBanner(BannerModel banner) {
// //     return BannerMStyle1(
// //       banner: banner,
// //       press: () => _handleBannerPress(banner),
// //       text: '', // Add appropriate text if needed
// //     );
// //   }
// //
// //   void _handleBannerPress(BannerModel banner) {
// //     // Handle banner tap navigation
// //     debugPrint("Banner tapped: ${banner.id}");
// //   }
// //
// //   @override
// //   void dispose() {
// //     _isDisposed = true;
// //     _timer?.cancel(); // Safe cancel
// //     _pageController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     if (_banners.isEmpty) return const SizedBox.shrink();
// //
// //     return AspectRatio(
// //       aspectRatio: 1.87,
// //       child: Stack(
// //         alignment: Alignment.bottomRight,
// //         children: [
// //           PageView.builder(
// //             controller: _pageController,
// //             itemCount: _banners.length,
// //             onPageChanged: (int index) {
// //               if (!_isDisposed) {
// //                 setState(() => _selectedIndex = index);
// //               }
// //             },
// //             itemBuilder: (context, index) => _buildBanner(_banners[index]),
// //           ),
// //           _buildIndicators(),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildIndicators() {
// //     return Padding(
// //       padding: EdgeInsets.all(defaultPadding),
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: List.generate(
// //           _banners.length,
// //               (index) => DotIndicator(
// //             isActive: index == _selectedIndex,
// //             activeColor: Colors.white70,
// //             inActiveColor: Colors.white54,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// // ملف: offers_carousel.dart
// import 'package:flutter/material.dart';
// import 'package:shop/components/dot_indicators.dart';
// import 'package:shop/constants.dart';
// import 'package:shop/models/banner_model.dart';
//
// class OffersCarousel extends StatelessWidget {
//   final List<BannerModel> banners;
//   final PageController pageController;
//   final int currentIndex;
//
//   const OffersCarousel({
//     super.key,
//     required this.banners,
//     required this.pageController,
//     required this.currentIndex,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (banners.isEmpty) return const SizedBox.shrink();
//
//     return AspectRatio(
//       aspectRatio: 1.87,
//       child: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           PageView.builder(
//             controller: pageController,
//             itemCount: banners.length,
//             itemBuilder: (context, index) => _BannerSlide(banner: banners[index]),
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
//           banners.length,
//               (index) => DotIndicator(
//             isActive: index == currentIndex,
//             activeColor: Colors.white,
//             inActiveColor: Colors.white54,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _BannerSlide extends StatelessWidget {
//   final BannerModel banner;
//
//   const _BannerSlide({
//     required this.banner,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         image: DecorationImage(
//           image: banner.imageUrl != null
//               ? NetworkImage(banner.imageUrl!)
//               : const AssetImage('assets/images/banner_placeholder.png') as ImageProvider,
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           gradient: LinearGradient(
//             begin: Alignment.bottomCenter,
//             end: Alignment.topCenter,
//             colors: [
//               Colors.black.withOpacity(0.7),
//               Colors.transparent,
//             ],
//           ),
//         ),
//         padding: const EdgeInsets.all(defaultPadding),
//         child: Align(
//           alignment: Alignment.bottomLeft,
//           child: Text(
//             banner.title,
//             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shop/components/dot_indicators.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/banner_model.dart';
import 'package:shop/services/api_service.dart';

class OffersCarousel extends StatefulWidget {
  final String storeId;

  const OffersCarousel({
    super.key,
    required this.storeId,
  });

  @override
  State<OffersCarousel> createState() => _OffersCarouselState();
}

class _OffersCarouselState extends State<OffersCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  List<BannerModel> _banners = [];
  int _selectedIndex = 0;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _loadBanners();
  }

  Future<void> _loadBanners() async {
    try {
      final banners = await ApiService.getBanners(widget.storeId);
      if (!_isDisposed) {
        setState(() => _banners = banners);
        if (_banners.isNotEmpty) _startAutoScroll();
      }
    } catch (e) {
      debugPrint("Error loading banners: $e");
    }
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_isDisposed) return;

      final newIndex = _selectedIndex < _banners.length - 1
          ? _selectedIndex + 1
          : 0;

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          newIndex,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_banners.isEmpty) return const SizedBox.shrink();

    return AspectRatio(
      aspectRatio: 1.87,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _banners.length,
            onPageChanged: (int index) {
              if (!_isDisposed) setState(() => _selectedIndex = index);
            },
            itemBuilder: (context, index) => _BannerSlide(banner: _banners[index]),
          ),
          _buildIndicators(),
        ],
      ),
    );
  }

  Widget _buildIndicators() {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _banners.length,
              (index) => DotIndicator(
            isActive: index == _selectedIndex,
            activeColor: Colors.white,
            inActiveColor: Colors.white54,
          ),
        ),
      ),
    );
  }
}

class _BannerSlide extends StatelessWidget {
  final BannerModel banner;

  const _BannerSlide({
    required this.banner,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(banner.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        padding: const EdgeInsets.all(defaultPadding),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            banner.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}