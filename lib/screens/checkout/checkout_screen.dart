//
// import 'package:flutter/material.dart';
// import 'package:shop/screens/checkout/PaymentMethodStep.dart';
// import 'package:shop/screens/checkout/ShippingCompanyStep.dart';
// import 'package:shop/screens/checkout/shipping_address_step.dart';
// import 'package:shop/services/auth_service.dart';
//
// class CheckoutScreen extends StatefulWidget {
//   const CheckoutScreen({super.key});
//
//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }
// class _CheckoutScreenState extends State<CheckoutScreen> {
//   int currentStep = 0;
//   Map<String, dynamic>? selectedAddress;
//   Map<String, dynamic>? selectedShippingCompany;
//   Map<String, dynamic>? selectedPaymentMethod;
//
//   String? storeId;
//   String? customerId;
//   String? token;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadAuthData();
//   }
//
//   Future<void> _loadAuthData() async {
//     try {
//       final fetchedStoreId = await AuthService.getStoreId();
//       final fetchedCustomerId = await AuthService.getCustomerId();
//       final fetchedToken = await AuthService.getToken();
//
//       if (fetchedStoreId == null ||
//           fetchedCustomerId == null ||
//           fetchedToken == null) {
//         throw Exception('بيانات المستخدم مفقودة');
//       }
//
//       setState(() {
//         storeId = fetchedStoreId;
//         customerId = fetchedCustomerId;
//         token = fetchedToken;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() => isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("فشل تحميل بيانات المستخدم: ${e.toString()}")),
//       );
//     }
//   }
//
//   void _goToNextStep() {
//     if (currentStep < 2) {
//       setState(() => currentStep++);
//     }
//   }
//
//   void _goToPreviousStep() {
//     if (currentStep > 0) {
//       setState(() => currentStep--);
//     }
//   }
//
//   void _submitOrder() {
//     debugPrint("Submit order with:");
//     debugPrint("Address: $selectedAddress");
//     debugPrint("Shipping: $selectedShippingCompany");
//     debugPrint("Payment: $selectedPaymentMethod");
//     // هنا يمكنك إرسال الطلب إلى السيرفر
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // شاشة التحميل
//     if (isLoading) {
//       return Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: const [
//               CircularProgressIndicator(),
//               SizedBox(height: 20),
//               Text('جارٍ تحميل البيانات...'),
//             ],
//           ),
//         ),
//       );
//     }
//
//     // شاشة الخطأ عند عدم توفر البيانات
//     if (storeId == null || customerId == null || token == null) {
//       return Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(Icons.error, color: Colors.red, size: 40),
//               const SizedBox(height: 20),
//               const Text('بيانات المستخدم مفقودة، الرجاء المحاولة لاحقًا.'),
//               TextButton(
//                 onPressed: () =>
//                     Navigator.pushReplacementNamed(context, '/login'),
//                 child: const Text('إعادة المحاولة'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     // الشاشة الرئيسية لعملية الدفع
//     return Scaffold(
//       appBar: AppBar(title: const Text("إتمام الطلب")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // المنطقة التي تحتوي على الخطوات
//             Expanded(
//               child: IndexedStack(
//                 index: currentStep,
//                 children: [
//                   // خطوة اختيار العنوان
//                   ShippingAddressStep(
//                     customerId: customerId!,
//                     storeId: storeId!,
//                     token: token!,
//                     onAddressSelected: (address) {
//                       selectedAddress = address.toJson();
//                       _goToNextStep();
//                     },
//                   ),
//                   // خطوة اختيار شركة الشحن
//                   ShippingCompanyStep(
//                     storeId: storeId!,
//                     onCompanySelected: (company) {
//                       selectedShippingCompany = company.toJson();
//                       _goToNextStep();
//                     },
//                   ),
//                   // خطوة اختيار طريقة الدفع
//                   PaymentMethodStep(
//                     storeId: storeId!,
//                     onPaymentMethodSelected: (method) {
//                       selectedPaymentMethod = method.toJson();
//                       _goToNextStep();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // أزرار التنقل/الإرسال مع توسيع لمنع العرض اللامحدود
//             Row(
//               children: [
//                 if (currentStep > 0)
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _goToPreviousStep,
//                       child: const Text("السابق"),
//                     ),
//                   ),
//                 if (currentStep > 0 && currentStep < 2)
//                   const SizedBox(width: 12),
//                 if (currentStep < 2)
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _goToNextStep,
//                       child: const Text("التالي"),
//                     ),
//                   ),
//                 if (currentStep == 2)
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: _submitOrder,
//                       child: const Text("إرسال الطلب"),
//                     ),
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shop/models/DeliveringProvider.dart';
import 'package:shop/models/PaymentProvider.dart';
import 'package:shop/models/ShippingAddress.dart';
import 'package:shop/screens/checkout/AddContactInfoScreen.dart';
import 'package:shop/screens/checkout/PaymentMethodStep.dart';
import 'package:shop/screens/checkout/ShippingCompanyStep.dart';
import 'package:shop/screens/checkout/shipping_address_step.dart';
import 'package:shop/screens/order/views/order_confirmation_screen.dart';
import 'package:shop/services/api_service.dart';
import 'package:shop/services/cart_service.dart';
import 'package:shop/services/auth_service.dart';
import '../../route/route_constants.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int currentStep = 0;
  ShippingAddress? selectedAddress;
  DeliveringProvider? selectedShippingCompany;
  PaymentProvider? selectedPaymentMethod;
  bool isSubmitting = false;
  bool isLoading = true;
  String? errorMessage;

  String? storeId;
  String? customerId;
  String? token;

  String? firstName;
  String? lastName;
  String? email;
  String? phone;

  @override
  void initState() {
    super.initState();
    _loadAuthData();
  }

  Future<void> _loadAuthData() async {
    try {
      final fetchedStoreId = await AuthService.getStoreId();
      final fetchedCustomerId = await AuthService.getCustomerId();
      final fetchedToken = await AuthService.getToken();

      if (fetchedStoreId == '' || fetchedCustomerId == null || fetchedToken == null) {
        throw Exception('بيانات المستخدم غير مكتملة');
      }

      setState(() {
        storeId = fetchedStoreId;
        customerId = fetchedCustomerId;
        token = fetchedToken;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "فشل تحميل بيانات المستخدم: ${e.toString()}";
      });
    }
  }

  void _goToNextStep() {
    if (currentStep < 3) setState(() => currentStep++);
  }

  void _goToPreviousStep() {
    if (currentStep > 0) setState(() => currentStep--);
  }

  // Future<void> _submitOrder() async {
  //   if (isSubmitting) return;
  //
  //   if ([firstName, lastName, email, phone].contains(null) ||
  //       selectedAddress == null ||
  //       selectedShippingCompany == null ||
  //       selectedPaymentMethod == null) {
  //     setState(() => errorMessage = "الرجاء إكمال جميع خطوات الدفع");
  //     return;
  //   }
  //
  //   setState(() {
  //     isSubmitting = true;
  //     errorMessage = null;
  //   });
  //
  //   try {
  //     final cartItems = await CartService.getCartItems();
  //     final orderData = {
  //       "checkoutFormData": {
  //         "firstName": firstName,
  //         "lastName": lastName,
  //         "email": email,
  //         "phone": phone,
  //         "streetAddress": selectedAddress!.streetAddress,
  //         "city": selectedAddress!.city,
  //         "country": selectedAddress!.country,
  //         "district": selectedAddress!.district,
  //         "paymentMethod": selectedPaymentMethod!.name,
  //         "shippingCost": selectedShippingCompany!.price,
  //         "storeId": storeId,
  //         "CustomerStoreId": customerId,
  //       },
  //       "orderItems": cartItems
  //           .map((item) => {
  //         "id": item['id'],
  //         "title": item['title'],
  //         "imageUrl": item['imageUrl'] ?? item['image'],
  //         "salePrice": item['salePrice'] ?? item['price'],
  //         "qty": item['qty'],
  //       })
  //           .toList(),
  //     };
  //
  //     final response = await ApiService.placeOrder(token: token!, orderData: orderData);
  //     if (response['success'] ) {
  //       await CartService.clearCart();
  //       if (mounted) {
  //         Navigator.pushReplacementNamed(
  //           context,
  //           ordersScreenRoute,
  //           arguments: {'orderNumber': response['order']['orderNumber']},
  //         );
  //       }
  //     } else {
  //       throw Exception(response['message'] ?? 'فشل إرسال الطلب');
  //     }
  //   } catch (e) {
  //     setState(() => errorMessage = "فشل إرسال الطلب: ${e.toString()}");
  //   } finally {
  //     if (mounted) setState(() => isSubmitting = false);
  //   }
  // }
  Future<void> _submitOrder() async {
    try {
      if (selectedAddress == null ||
          selectedShippingCompany == null ||
          selectedPaymentMethod == null) {
        // تحقق من أن جميع الخيارات قد تم اختيارها
        throw Exception("الرجاء اختيار العنوان وشركة الشحن وطريقة الدفع.");
      }
      setState(() {
        isLoading = true;
      });

      final customerStoreId = await AuthService.fetchCustomerStoreId();

      if (customerStoreId == null) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تعذر الحصول على customerStoreId')),
        );
        return;
      }
          final cartItems = await CartService.getCartItems();

      // بناء بيانات الطلب حسب تنسيق الـ API
      final orderData = {
        "checkoutFormData": {
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "phone": phone,
          "streetAddress": selectedAddress!.streetAddress,
          "city": selectedAddress!.city,
          "country": selectedAddress!.country,
          "district": selectedAddress!.district,
          "paymentMethod": selectedPaymentMethod!.name, // مثل: "COD"
          // "shippingCost": selectedShippingCompany!.price,
          "shippingCost": 1000,
          "storeId": storeId,
          "CustomerStoreId": customerStoreId,
          "location": {} // يمكن تركه فارغاً حالياً
        },
        "orderItems": cartItems.map((item) {
          return {
            "id": item['productId'] ?? item['id'],
            "qty": item['qty'],
            "salePrice": item['salePrice'] ?? item['price'],
            "imageUrl": item['imageUrl'] ?? item['image'],
            "title": item['title'],
          };
        }).toList()
      };
      print("بيانات الطلب قبل الإرسال:");
      print(orderData);

      // إرسال الطلب عبر API
      final response = await http.post(
        Uri.parse('https://www.etjer.store/api/orders'), // غيّر الرابط حسب الخادم
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(orderData),

      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Order created successfully: $responseData');
              await CartService.clearCart();

        // تفريغ السلة أو الانتقال إلى شاشة تأكيد الطلب
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => OrderConfirmationScreen( orderData: responseData)),
        );
      } else {
        print('فشل في إرسال الطلب: ${response.body}');
        throw Exception("حدث خطأ أثناء إرسال الطلب. الرجاء المحاولة مرة أخرى.");
      }
    } catch (e) {
      print('خطأ أثناء إنشاء الطلب: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء إتمام الطلب: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || isSubmitting) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (storeId == null || customerId == null || token == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 40),
              const SizedBox(height: 20),
              Text(errorMessage ?? 'بيانات المستخدم مفقودة، الرجاء تسجيل الدخول أولاً.'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: const Text('تسجيل الدخول'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("إتمام الطلب"), centerTitle: true),
      body: Column(
        children: [
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            ),
          Expanded(
            child: Stepper(
              type: StepperType.vertical,
              currentStep: currentStep,
              onStepContinue: _goToNextStep,
              onStepCancel: _goToPreviousStep,
              onStepTapped: (step) => setState(() => currentStep = step),
              controlsBuilder: (context, details) => Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    if (currentStep > 0)
                      OutlinedButton(
                        onPressed: details.onStepCancel,
                        child: const Text("السابق"),
                      ),
                    if (currentStep < 3) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: const Text("التالي"),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              steps: [
                Step(
                  title: const Text("معلومات العميل"),
                  content: AddContactInfoScreen(
                    onSave: (fName, lName, mail, ph) {
                      setState(() {
                        firstName = fName;
                        lastName = lName;
                        email = mail;
                        phone = ph;
                      });
                      _goToNextStep();
                    },
                  ),
                  isActive: currentStep >= 0,
                  state: currentStep > 0 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: const Text("عنوان الشحن"),
                  content: ShippingAddressStep(
                    customerId: customerId!,
                    token: token!,
                    storeId: storeId!,
                    onAddressSelected: (address) {
                      setState(() => selectedAddress = address);
                      _goToNextStep();
                    },
                  ),
                  isActive: currentStep >= 1,
                  state: currentStep > 1 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: const Text("شركة الشحن"),
                  content: ShippingCompanyStep(
                    storeId: storeId!,
                    onCompanySelected: (company) {
                      setState(() => selectedShippingCompany = company);
                      _goToNextStep();
                    },
                  ),
                  isActive: currentStep >= 2,
                  state: currentStep > 2 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: const Text("طريقة الدفع"),
                  content: PaymentMethodStep(
                    storeId: storeId!,
                    onPaymentMethodSelected: (method) {
                      setState(() => selectedPaymentMethod = method);
                    },
                  ),
                  isActive: currentStep >= 3,
                  state: StepState.indexed,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: currentStep == 3
          ? Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          onPressed: _submitOrder,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text("إرسال الطلب", style: TextStyle(fontSize: 18)),
        ),
      )
          : null,
    );
  }
}














































//
// import 'package:flutter/material.dart';
// import 'package:shop/screens/checkout/PaymentMethodStep.dart';
// import 'package:shop/screens/checkout/ShippingCompanyStep.dart';
// import 'package:shop/screens/checkout/shipping_address_step.dart';
// import 'package:shop/services/auth_service.dart';
//
// class CheckoutScreen extends StatefulWidget {
//   const CheckoutScreen({super.key});
//
//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }
// class _CheckoutScreenState extends State<CheckoutScreen> {
//   int currentStep = 0;
//   Map<String, dynamic>? selectedAddress;
//   Map<String, dynamic>? selectedShippingCompany;
//   Map<String, dynamic>? selectedPaymentMethod;
//
//   String? storeId;
//   String? customerId;
//   String? token;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadAuthData();
//   }
//
//   Future<void> _loadAuthData() async {
//     try {
//       final fetchedStoreId = await AuthService.getStoreId();
//       final fetchedCustomerId = await AuthService.getCustomerId();
//       final fetchedToken = await AuthService.getToken();
//
//       if (fetchedStoreId == null ||
//           fetchedCustomerId == null ||
//           fetchedToken == null) {
//         throw Exception('بيانات المستخدم مفقودة');
//       }
//
//       setState(() {
//         storeId = fetchedStoreId;
//         customerId = fetchedCustomerId;
//         token = fetchedToken;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() => isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("فشل تحميل بيانات المستخدم: ${e.toString()}")),
//       );
//     }
//   }
//
//   void _goToNextStep() {
//     if (currentStep < 2) {
//       setState(() => currentStep++);
//     }
//   }
//
//   void _goToPreviousStep() {
//     if (currentStep > 0) {
//       setState(() => currentStep--);
//     }
//   }
//
//   void _submitOrder() {
//     debugPrint("Submit order with:");
//     debugPrint("Address: $selectedAddress");
//     debugPrint("Shipping: $selectedShippingCompany");
//     debugPrint("Payment: $selectedPaymentMethod");
//     // هنا يمكنك إرسال الطلب إلى السيرفر
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // شاشة التحميل
//     if (isLoading) {
//       return Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: const [
//               CircularProgressIndicator(),
//               SizedBox(height: 20),
//               Text('جارٍ تحميل البيانات...'),
//             ],
//           ),
//         ),
//       );
//     }
//
//     // شاشة الخطأ عند عدم توفر البيانات
//     if (storeId == null || customerId == null || token == null) {
//       return Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               const Icon(Icons.error, color: Colors.red, size: 40),
// //               const SizedBox(height: 20),
// //               const Text('بيانات المستخدم مفقودة، الرجاء المحاولة لاحقًا.'),
// //               TextButton(
// //                 onPressed: () =>
// //                     Navigator.pushReplacementNamed(context, '/login'),
// //                 child: const Text('إعادة المحاولة'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       );
// //     }
// //
// //     // الشاشة الرئيسية لعملية الدفع
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("إتمام الطلب")),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             // المنطقة التي تحتوي على الخطوات
// //             Expanded(
// //               child: IndexedStack(
// //                 index: currentStep,
// //                 children: [
// //                   // خطوة اختيار العنوان
// //                   ShippingAddressStep(
// //                     customerId: customerId!,
// //                     storeId: storeId!,
// //                     token: token!,
// //                     onAddressSelected: (address) {
// //                       selectedAddress = address.toJson();
// //                       _goToNextStep();
// //                     },
// //                   ),
// //                   // خطوة اختيار شركة الشحن
// //                   ShippingCompanyStep(
// //                     storeId: storeId!,
// //                     onCompanySelected: (company) {
// //                       selectedShippingCompany = company.toJson();
// //                       _goToNextStep();
// //                     },
// //                   ),
// //                   // خطوة اختيار طريقة الدفع
// //                   PaymentMethodStep(
// //                     storeId: storeId!,
// //                     onPaymentMethodSelected: (method) {
// //                       selectedPaymentMethod = method.toJson();
// //                       _goToNextStep();
// //                     },
// //                   ),
// //                 ],
// //               ),
// //             ),
// //
// //             const SizedBox(height: 16),
// //
// //             // أزرار التنقل/الإرسال مع توسيع لمنع العرض اللامحدود
// //             Row(
// //               children: [
// //                 if (currentStep > 0)
// //                   Expanded(
// //                     child: ElevatedButton(
// //                       onPressed: _goToPreviousStep,
// //                       child: const Text("السابق"),
// //                     ),
// //                   ),
// //                 if (currentStep > 0 && currentStep < 2)
// //                   const SizedBox(width: 12),
// //                 if (currentStep < 2)
// //                   Expanded(
// //                     child: ElevatedButton(
// //                       onPressed: _goToNextStep,
// //                       child: const Text("التالي"),
// //                     ),
// //                   ),
// //                 if (currentStep == 2)
// //                   Expanded(
// //                     child: ElevatedButton(
// //                       onPressed: _submitOrder,
// //                       child: const Text("إرسال الطلب"),
// //                     ),
// //                   ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:shop/models/DeliveringProvider.dart';
// import 'package:shop/models/PaymentProvider.dart';
// import 'package:shop/models/ShippingAddress.dart';
// import 'package:shop/screens/checkout/AddContactInfoScreen.dart';
// import 'package:shop/screens/checkout/PaymentMethodStep.dart';
// import 'package:shop/screens/checkout/ShippingCompanyStep.dart';
// import 'package:shop/screens/checkout/shipping_address_step.dart';
// import 'package:shop/services/api_service.dart';
// import 'package:shop/services/cart_service.dart';
// import 'package:shop/services/auth_service.dart';
// import '../../route/route_constants.dart';
//
// class CheckoutScreen extends StatefulWidget {
//   const CheckoutScreen({super.key});
//
//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }
//
// class _CheckoutScreenState extends State<CheckoutScreen> {
//   int currentStep = 0;
//   Map<String, dynamic>? selectedAddress;
//   Map<String, dynamic>? selectedShippingCompany;
//   Map<String, dynamic>? selectedPaymentMethod;
//   bool isSubmitting = false;
//   bool isLoading = true;
//   String? errorMessage;
//
//   String? storeId;
//   String? customerId;
//   String? token;
//
//   String? firstName;
//   String? lastName;
//   String? email;
//   String? phone;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadAuthData();
//   }
//
//   Future<void> _loadAuthData() async {
//     try {
//       final fetchedStoreId = await AuthService.getStoreId();
//       final fetchedCustomerId = await AuthService.getCustomerId();
//       final fetchedToken = await AuthService.getToken();
//
//       if (fetchedStoreId == null || fetchedCustomerId == null || fetchedToken == null) {
//         throw Exception('بيانات المستخدم غير مكتملة');
//       }
//
//       setState(() {
//         storeId = fetchedStoreId;
//         customerId = fetchedCustomerId;
//         token = fetchedToken;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         errorMessage = "فشل تحميل بيانات المستخدم: ${e.toString()}";
//       });
//     }
//   }
//
//   void _goToNextStep() {
//     if (currentStep < 3) {
//       setState(() => currentStep++);
//     }
//   }
//
//   void _goToPreviousStep() {
//     if (currentStep > 0) {
//       setState(() => currentStep--);
//     }
//   }
//
//   Future<void> _submitOrder() async {
//     if (isSubmitting) return;
//
//     if (firstName == null || lastName == null || email == null || phone == null ||
//         selectedAddress == null || selectedShippingCompany == null || selectedPaymentMethod == null) {
//       setState(() => errorMessage = "الرجاء إكمال جميع خطوات الدفع");
//       return;
//     }
//
//     setState(() {
//       isSubmitting = true;
//       errorMessage = null;
//     });
//
//     try {
//       final cartItems = await CartService.getCartItems();
//
//       final orderData = {
//         "checkoutFormData": {
//           "firstName": firstName,
//           "lastName": lastName,
//           "email": email,
//           "phone": phone,
//           "streetAddress": selectedAddress!.streetAddress,
//           "city": selectedAddress!.city,
//           "country": selectedAddress!.country,
//           "district": selectedAddress!.district,
//           "paymentMethod": selectedPaymentMethod!.name,
//           "shippingCost": selectedShippingCompany!.price,
//           "storeId": storeId,
//           "CustomerStoreId": customerId,
//         },
//         "orderItems": cartItems.map((item) => ({
//           "id": item['id'],
//           "title": item['title'],
//           "imageUrl": item['imageUrl'] ?? item['image'],
//           "salePrice": item['salePrice'] ?? item['price'],
//           "qty": item['qty'],
//         })).toList(),
//       };
//
//       final response = await ApiService.placeOrder(
//         token: token!,
//         orderData: orderData,
//       );
//
//       if (response['success'] == true) {
//         await CartService.clearCart();
//         if (mounted) {
//           Navigator.pushReplacementNamed(
//             context,
//             ordersScreenRoute,
//             arguments: {
//               'orderNumber': response['order']['orderNumber'],
//             },
//           );
//         }
//       } else {
//         throw Exception(response['message'] ?? 'فشل إرسال الطلب');
//       }
//     } catch (e) {
//       setState(() => errorMessage = "فشل إرسال الطلب: ${e.toString()}");
//     } finally {
//       if (mounted) {
//         setState(() => isSubmitting = false);
//       }
//     }
//   }
//
//   Widget _buildLoadingIndicator() {
//     return  Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(),
//           SizedBox(height: 20),
//           Text("جاري التحميل..."),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading || isSubmitting) {
//       return Scaffold(
//         body: _buildLoadingIndicator(),
//       );
//     }
//
//     if (storeId == null || customerId == null || token == null) {
//       return Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(Icons.error, color: Colors.red, size: 40),
//               const SizedBox(height: 20),
//               Text(
//                 errorMessage ?? 'بيانات المستخدم مفقودة، الرجاء تسجيل الدخول أولاً.',
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
//                 child: const Text('تسجيل الدخول'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("إتمام الطلب"),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             if (errorMessage != null)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   errorMessage!,
//                   style: const TextStyle(color: Colors.red),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             Expanded(
//               child: Stepper(
//                 type: StepperType.vertical,
//                 currentStep: currentStep,
//                 onStepContinue: _goToNextStep,
//                 onStepCancel: _goToPreviousStep,
//                 onStepTapped: (step) => setState(() => currentStep = step),
//                 controlsBuilder: (context, details) {
//                   return Padding(
//                     padding: const EdgeInsets.only(top: 16),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         if (currentStep > 0)
//                           OutlinedButton(
//                             onPressed: details.onStepCancel,
//                             child: const Text("السابق"),
//                           ),
//                         const SizedBox(width: 12),
//                         if (currentStep < 3)
//                           ElevatedButton(
//                             onPressed: details.onStepContinue,
//                             child: const Text("التالي"),
//                           ),
//                       ],
//                     ),
//                   );
//                 },
//                 steps: [
//                   Step(
//                     title: const Text("معلومات العميل"),
//                     content: SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.5,
//                       child: AddContactInfoScreen(
//                         onSave: (fName, lName, mail, ph) {
//                           if (mounted) {
//                             setState(() {
//                               firstName = fName;
//                               lastName = lName;
//                               email = mail;
//                               phone = ph;
//                             });
//                             _goToNextStep();
//                           }
//                         },
//                       ),
//                     ),
//                     isActive: currentStep >= 0,
//                     state: currentStep > 0 ? StepState.complete : StepState.indexed,
//                   ),
//                   Step(
//                     title: const Text("عنوان الشحن"),
//                     content: SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.5,
//                       child: ShippingAddressStep(
//                         customerId: customerId!,
//                         token: token!,
//                         storeId: storeId!,
//                         onAddressSelected: (address) {
//                           if (mounted) {
//                             setState(() => selectedAddress = address.toJson());
//                             _goToNextStep();
//                           }
//                         },
//                       ),
//                     ),
//                     isActive: currentStep >= 1,
//                     state: currentStep > 1 ? StepState.complete : StepState.indexed,
//                   ),
//                   Step(
//                     title: const Text("شركة الشحن"),
//                     content: SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.5,
//                       child: ShippingCompanyStep(
//                         storeId: storeId!,
//                         onCompanySelected: (company) {
//                           if (mounted) {
//                             setState(() => selectedShippingCompany = company.toJson());
//                             _goToNextStep();
//                           }
//                         },
//                       ),
//                     ),
//                     isActive: currentStep >= 2,
//                     state: currentStep > 2 ? StepState.complete : StepState.indexed,
//                   ),
//                   Step(
//                     title: const Text("طريقة الدفع"),
//                     content: SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.5,
//                       child: PaymentMethodStep(
//                         storeId: storeId!,
//                         onPaymentMethodSelected: (method) {
//                           if (mounted) {
//                             setState(() => selectedPaymentMethod = method.toJson());
//                           }
//                         },
//                       ),
//                     ),
//                     isActive: currentStep >= 3,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: currentStep == 3
//           ? Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ElevatedButton(
//           onPressed: _submitOrder,
//           style: ElevatedButton.styleFrom(
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             minimumSize: const Size(double.infinity, 50),
//           ),
//           child: const Text(
//             "إرسال الطلب",
//             style: TextStyle(fontSize: 18),
//           ),
//         ),
//       )
//           : null,
//     );
//   }}