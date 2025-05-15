import 'package:flutter/material.dart';
import 'package:shop/entry_point.dart';
import 'package:shop/models/DeliveringProvider.dart';
import 'package:shop/models/PaymentProvider.dart';
import 'package:shop/models/ShippingAddress.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/screens/checkout/select_delivering_company_screen.dart';
import 'package:shop/screens/checkout/select_payment_method_screen.dart';
import 'package:shop/screens/checkout/shipping_address_step.dart';
import 'package:shop/screens/home/views/components/product_screen.dart';
import 'package:shop/screens/profile/orders_screen.dart';
import 'package:shop/screens/profile/views/components/location_settings_screen.dart';
import 'package:shop/screens/profile/views/faq_screen.dart';

import '../screens/home/views/components/DiscoverWithImageScreen.dart';
import 'screen_export.dart';

// Yuo will get 50+ screens and more once you have the full template
// 🔗 Full template: https://theflutterway.gumroad.com/l/fluttershop

// NotificationPermissionScreen()
// PreferredLanguageScreen()
// SelectLanguageScreen()
// SignUpVerificationScreen()
// ProfileSetupScreen()
// VerificationMethodScreen()
// OtpScreen()
// SetNewPasswordScreen()
// DoneResetPasswordScreen()
// TermsOfServicesScreen()
// SetupFingerprintScreen()
// SetupFingerprintScreen()
// SetupFingerprintScreen()
// SetupFingerprintScreen()
// SetupFaceIdScreen()
// OnSaleScreen()
// BannerLStyle2()
// BannerLStyle3()
// BannerLStyle4()
// SearchScreen()
// SearchHistoryScreen()
// NotificationsScreen()
// EnableNotificationScreen()
// NoNotificationScreen()
// NotificationOptionsScreen()
// ProductInfoScreen()
// ShippingMethodsScreen()
// ProductReviewsScreen()
// SizeGuideScreen()
// BrandScreen()
// CartScreen()
// EmptyCartScreen()
// PaymentMethodScreen()
// ThanksForOrderScreen()
// CurrentPasswordScreen()
// EditUserInfoScreen()
// OrdersScreen()
// OrderProcessingScreen()
// OrderDetailsScreen()
// CancleOrderScreen()
// DelivereOrdersdScreen()
// AddressesScreen()
// NoAddressScreen()
// AddNewAddressScreen()
// ServerErrorScreen()
// NoInternetScreen()
// ChatScreen()
// DiscoverWithImageScreen()
// SubDiscoverScreen()
// AddNewCardScreen()
// EmptyPaymentScreen()
// GetHelpScreen()

// ℹ️ All the comments screen are included in the full template
// 🔗 Full template: https://theflutterway.gumroad.com/l/fluttershop

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case onbordingScreenRoute:
      final storeId = settings.arguments as String;

      return MaterialPageRoute(
        builder: (context) =>  HomeScreen(  storeId: storeId,
        ),
      );



    case verification:
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => VerificationCodeScreen(
          email: args['email'],
          storeId: args['storeId'],
          onSuccess: args['onSuccess'],
        ),
      );
    case completeProfile:
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => CompleteProfileScreen(
          email: args['email'],
          onSuccess: args['onSuccess'],

        ),
      );
    // case profileSetupScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const ProfileSetupScreen(),
    //   );
    case logInScreenRoute:
      final Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (context) => LoginScreen(
          storeId: args['storeId'],
          onSuccess: args['onSuccess'],
        ),
      );


    case '/select-delivery':
      return MaterialPageRoute(
        builder: (_) => SelectDeliveringCompanyScreen(
          onProviderSelected: (DeliveringProvider provider) {
            // تنفيذ إجراءات لتخزين البيانات من DeliveringProvider
          },
          deliveringProviders: [], // هنا يجب تمرير قائمة شركات الشحن المحملة من API
        ),
      );

    case '/select-payment':
      return MaterialPageRoute(
        builder: (_) => SelectPaymentMethodScreen(
          onPaymentSelected: (PaymentProvider provider) {
            // تنفيذ إجراءات لتخزين البيانات من PaymentProvider
          },
          paymentProviders: [], // هنا يجب تمرير قائمة طرق الدفع المحملة من API
        ),
      );

    case orderSuccessreenRout:

      final Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;

      return MaterialPageRoute(
        builder: (_) => OrderConfirmationScreen(
          orderData: args['orderData'],),
      );



    case locationSettingsRoute:
      return MaterialPageRoute(builder: (_) => const LocationSettingsScreen());
    case faqScreenRoute:
      return MaterialPageRoute(builder: (_) => const CustomerFAQScreen());



    case productDetailsScreenRoute:
      return MaterialPageRoute(
        builder: (context) {
          final product = settings.arguments as ProductModel;
          return ProductDetailsScreen(product: product);
        },
      );

    // case productReviewsScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const ProductReviewsScreen(),
    //   );
    // case addReviewsScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const AddReviewScreen(),
    //   );
    case '/productScreen':
      final args = settings.arguments as Map<String, dynamic>;
      final subcategoryId = args['subcategoryId'];
      final subcategoryTitle = args['subcategoryTitle'];
      final storeId = args['storeId'];  // تأكد من أنك تمرر storeId أيضًا

      return MaterialPageRoute(
        builder: (_) => ProductScreen(
          subcategoryId: subcategoryId,
          subcategoryTitle: subcategoryTitle,
          storeId: storeId,  // تمرير storeId إلى الشاشة
        ),
      );
    case cartScreenRoute:
      final storeId = settings.arguments as String;

      return MaterialPageRoute(builder: (_) =>  CartScreen(
          storeId: storeId,

      ));
    case homeScreenRoute:
      final storeId = settings.arguments as String;

      return MaterialPageRoute(
        builder: (context) =>  HomeScreen(
          storeId: storeId,

        ),
      );
    // case brandScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const BrandScreen(),
    //   );
    case discoverWithImageScreenRoute:
      return MaterialPageRoute(
        builder: (context) {
          final args = settings.arguments as Map<String, dynamic>;
          final storeId = args['storeId'];
          final categoryId = args['categoryId'];
          final title = args['title'];

          return DiscoverWithImageScreen(
            storeId: storeId,
            categoryId: categoryId,
            title: title,
          );
        },
      );


  // case subDiscoverScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const SubDiscoverScreen(),
    //   );
    case discoverScreenRoute:
      final storeId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => DiscoverScreen(storeId: storeId),
      );
    // case onSaleScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const OnSaleScreen(),
    //   );

    case searchScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const SearchScreen(),
      );
    case categoryProductsScreenRoute:
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => CategoryProductsScreen(

          categoryId: args['categoryId'],
          categoryTitle: args['title'],
        ),
      );
    // case searchHistoryScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const SearchHistoryScreen(),
    //   );
    case bookmarkScreenRoute:
      final storeId = settings.arguments as String;

      return MaterialPageRoute(

        builder: (context) =>  BookmarkScreen(storeId: storeId),
      );
    case entryPointScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const EntryPoint(),
      );
    case profileScreenRoute:
      final storeId = settings.arguments as String;

      return MaterialPageRoute(
        builder: (context) =>  ProfileScreen(storeId: storeId),
      );
    // case getHelpScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const GetHelpScreen(),
    //   );
    // case chatScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const ChatScreen(),
    //   );
    case userInfoScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const UserInfoScreen(),
      );
    // case currentPasswordScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const CurrentPasswordScreen(),
    //   );
    // case editUserInfoScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const EditUserInfoScreen(),
    //   );

    case notificationsScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const NotificationsScreen(),
      );
    case noNotificationScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const NoNotificationScreen(),
      );
    case enableNotificationScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const EnableNotificationScreen(),
      );
    case notificationOptionsScreenRoute:
      final storeId = settings.arguments as String;

      return MaterialPageRoute(

        builder: (context) =>  HelpScreen(storeId: storeId,),
      );
    // case selectLanguageScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const SelectLanguageScreen(),
    //   );
    // case noAddressScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const NoAddressScreen(),
    //   );

    // case addNewAddressesScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const AddNewAddressScreen(),
    //   );

    case ordersScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const OrdersScreen(),
      );
    // case orderProcessingScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const OrderProcessingScreen(),
    //   );
    // case orderDetailsScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const OrderDetailsScreen(),
    //   );
    // case cancleOrderScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const CancleOrderScreen(),
    //   );
    // case deliveredOrdersScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const DelivereOrdersdScreen(),
    //   );
    // case cancledOrdersScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const CancledOrdersScreen(),
    //   );

    case preferencesScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const PreferencesScreen(),
      );
    // case emptyPaymentScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const EmptyPaymentScreen(),
    //   );
    case emptyWalletScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const EmptyWalletScreen(),
      );
    case walletScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const WalletScreen(),
      );
    case cartScreenRoute:
      final storeId = settings.arguments as String;

      return MaterialPageRoute(builder: (context) =>  CartScreen(
        storeId: storeId,
      ),
      );

    // case paymentMethodScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const PaymentMethodScreen(),
    //   );
    // case addNewCardScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const AddNewCardScreen(),
    //   );
    // case thanksForOrderScreenRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const ThanksForOrderScreen(),
    //   );
    default:
      return MaterialPageRoute(
        // Make a screen for undefine
        builder: (context) => const OnBordingScreen(),
      );
  }
}
