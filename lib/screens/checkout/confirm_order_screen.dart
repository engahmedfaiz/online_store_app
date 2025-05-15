import 'package:flutter/material.dart';
import 'package:shop/models/DeliveringProvider.dart';
import 'package:shop/models/PaymentProvider.dart';
import 'package:shop/models/ShippingAddress.dart';

class ConfirmOrderScreen extends StatelessWidget {
  final ShippingAddress address;
  final DeliveringProvider deliveringProvider;
  final PaymentProvider paymentProvider;

  const ConfirmOrderScreen({
    Key? key,
    required this.address,
    required this.deliveringProvider,
    required this.paymentProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("ملخص الطلب"),
        const SizedBox(height: 20),
        Text("عنوان الشحن: ${address.location}, ${address.city}, ${address.addressName}"),
        Text("شركة الشحن: ${deliveringProvider.name}"),
        Text("طريقة الدفع: ${paymentProvider.name}"),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // إرسال الطلب إلى API هنا
          },
          child: const Text('تأكيد الطلب'),
        ),
      ],
    );
  }
}
