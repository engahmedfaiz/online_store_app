import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop/constants.dart';
import 'package:shop/route/screen_export.dart';
import 'package:shop/screens/profile/address_management_page.dart';
import 'package:shop/screens/profile/views/components/profile_card.dart';
import 'package:shop/screens/profile/views/components/profile_menu_item_list_tile.dart';
import 'package:shop/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  final String storeId;

  const ProfileScreen({super.key, required this.storeId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? errorMessage;
  bool isLoggedIn = false;
  String? customerId;
  String? token;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final loggedIn = await AuthService.isLoggedIn();

      if (mounted) {
        setState(() => isLoggedIn = loggedIn);
      }

      if (loggedIn) {
        await _loadAuthData();
        await _fetchUserProfile();
      } else {
        if (mounted) {
          setState(() => isLoading = false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = "حدث خطأ أثناء تحميل البيانات: ${e.toString()}";
        });
      }
    }
  }

  Future<void> _loadAuthData() async {
    try {
      final fetchedCustomerId = await AuthService.getCustomerId() ?? '';
      final fetchedToken = await AuthService.getToken() ?? '';

      if (mounted) {
        setState(() {
          customerId = fetchedCustomerId;
          token = fetchedToken;
          errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = "حدث خطأ في تحميل بيانات المصادقة: ${e.toString()}";
        });
      }
    }
  }

  Future<void> _fetchUserProfile() async {
    try {
      final token = await AuthService.getToken();
      if (token == null || token.isEmpty) {
        if (mounted) {
          setState(() {
            isLoggedIn = false;
            isLoading = false;
          });
        }
        return;
      }

      final payload = AuthService.decodeJwtPayload(token);
      if (mounted) {
        setState(() {
          userData = payload;
          isLoggedIn = true;
          isLoading = false;
          errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          isLoggedIn = false;
          errorMessage = "حدث خطأ في تحميل بيانات الملف الشخصي";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) return _buildLoadingState(isDarkMode);
    if (errorMessage != null) return _buildErrorState(isDarkMode);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: RefreshIndicator(
        onRefresh: _initializeApp,
        color: isDarkMode ? Colors.white : Colors.black,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            _buildProfileSection(isDarkMode),
            const SizedBox(height: defaultPadding * 2),
            _buildAuthActionButton(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthActionButton(bool isDarkMode) {
    return ListTile(
      onTap: () async {
        if (isLoggedIn) {
          await AuthService.logout();
          if (mounted) {
            setState(() => isLoggedIn = false);
          }
        } else {
          _navigateToLogin();
        }
      },
      minLeadingWidth: 24,
      leading: SvgPicture.asset(
        isLoggedIn ? "assets/icons/Logout.svg" : "assets/icons/Login.svg",
        colorFilter: ColorFilter.mode(
          isLoggedIn ? errorColor : primaryColor,
          BlendMode.srcIn,
        ),
      ),
      title: Text(
        isLoggedIn ? "تسجيل الخروج" : "تسجيل الدخول",
        style: TextStyle(
          color: isLoggedIn ? errorColor : primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      tileColor: isDarkMode ? Colors.grey[900] : Colors.white,
    );
  }

  Widget _buildProfileSection(bool isDarkMode) {
    if (!isLoggedIn) return _buildGuestUI(isDarkMode);
    if (userData == null) return _buildLoadingState(isDarkMode);

    return Column(
      children: [
        _buildUserProfileCard(isDarkMode),
        _buildPromoBanner(isDarkMode),
        _buildAccountSection(isDarkMode),
        _buildHelpSection(isDarkMode),
      ],
    );
  }

  Widget _buildUserProfileCard(bool isDarkMode) {
    return ProfileCard(
      name: _getUserName(),
      email: userData?['email'] ?? 'بريد إلكتروني غير معروف',
      imageSrc: 'assets/images/default_profile.png',
      press: () => isLoggedIn
          ? Navigator.pushNamed(context, userInfoScreenRoute)
          : _navigateToLogin(),
      isDarkMode: isDarkMode,
    );
  }

  String _getUserName() {
    if (!isLoggedIn) return 'زائر';
    return userData != null
        ? '${userData!['firstName'] ?? ''} ${userData!['lastName'] ?? ''}'.trim()
        : 'مستخدم';
  }

  Widget _buildPromoBanner(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding * 1.5,
      ),
      child: AspectRatio(
        aspectRatio: 1.8,
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[900] : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Icon(
              Icons.local_offer,
              color: isDarkMode ? Colors.white : Colors.black,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 8),
          child: Text(
            "الحساب",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        _buildMenuTile("الطلبات", "Order.svg",
                () => isLoggedIn ? _navigateToOrders() : _navigateToLogin(),
            isDarkMode: isDarkMode),
        _buildMenuTile(
          "المفضلة",
          "Wishlist.svg",
              () => isLoggedIn
              ? Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookmarkScreen(storeId: widget.storeId),
            ),
          )
              : _navigateToLogin(),
          isDarkMode: isDarkMode,
        ),
        _buildMenuTile(
          "ادارة العناوين",
          "Address.svg",
              () => isLoggedIn ? _navigateToAddresses() : _navigateToLogin(),
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  Widget _buildHelpSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 8),
          child: Text(
            "المساعدة والدعم",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        _buildMenuTile(
          "الحصول على مساعدة",
          "Help.svg",
              () => _navigateToHelp(storeId: widget.storeId),
          isDarkMode: isDarkMode,
        ),

        _buildMenuTile("الأسئلة الشائعة", "FAQ.svg", () => _navigateToFAQ(),
          isDarkMode: isDarkMode,
          isShowDivider: false,
        ),
      ],
    );
  }

  Widget _buildMenuTile(
      String title,
      String icon,
      VoidCallback action, {
        bool isShowDivider = true,
        required bool isDarkMode,
      }) {
    return ProfileMenuListTile(
      text: title,
      svgSrc: "assets/icons/$icon",
      press: action,
      isShowDivider: isShowDivider,
    );
  }

  Widget _buildGuestUI(bool isDarkMode) {
    return Column(
      children: [
        ProfileCard(
          name: 'زائر',
          email: 'سجل الدخول للوصول إلى حسابك',
          imageSrc: 'assets/images/default_profile.png',
          press: _navigateToLogin,
          isDarkMode: isDarkMode,
        ),
        _buildPromoBanner(isDarkMode),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "سجل الدخول للوصول إلى جميع الميزات",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey,
                fontSize: 16
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(bool isDarkMode) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Center(
        child: CircularProgressIndicator(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildErrorState(bool isDarkMode) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDarkMode ? Colors.red[300] : errorColor,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _initializeApp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.grey[800] : primaryColor,
                ),
                child: Text(
                  "إعادة المحاولة",
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.pushNamed(
      context,
      logInScreenRoute,
      arguments: {
        "storeId": widget.storeId,
        "onSuccess": (String newToken) async {
          await AuthService.saveToken(newToken);
          if (mounted) {
            setState(() => isLoggedIn = true);
            await _initializeApp();
          }
        },
        "isRedirected": true,
      },
    );
  }

  void _navigateToAddresses() {
    if (customerId == null || token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('جاري تحميل البيانات، يرجى الانتظار...')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressManagerPage(
          customerId: customerId!,
          storeId: widget.storeId,
          token: token!,
        ),
      ),
    );
  }

  void _navigateToOrders() => Navigator.pushNamed(context, ordersScreenRoute);
  void _navigateToHelp({required String storeId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HelpScreen(storeId: storeId),
      ),
    );
  }
  void _navigateToFAQ() => Navigator.pushNamed(context, faqScreenRoute);
}