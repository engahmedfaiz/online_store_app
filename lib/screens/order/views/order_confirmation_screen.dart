
import 'package:flutter/material.dart';
import 'package:shop/screens/checkout/AddReviewScreen.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderConfirmationScreen({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    print("بيانات الطلب قبل الإرسال:");
    print(orderData);
    final String orderNumber = orderData['orderNumber'] ?? '';
    final String name = '${orderData['firstName'] ?? ''} ${orderData['lastName'] ?? ''}';
    final String phone = orderData['phone'] ?? '';
    final String address =
        '${orderData['streetAddress'] ?? ''}, ${orderData['district'] ?? ''}, ${orderData['city'] ?? ''}, ${orderData['country'] ?? ''}';
    final String paymentMethod = orderData['paymentMethod'] ?? '';
    final double shippingCost = (orderData['shippingCost'] ?? 0).toDouble();

    final List<dynamic> items = orderData['orderItems'] ?? [];
    final double total = items.fold(0.0, (sum, item) {
      return sum + (item['price'] ?? 0) * (item['quantity'] ?? 1);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("تأكيد الطلب"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
              const SizedBox(height: 24),
              const Text(
                "تم استلام طلبك بنجاح",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                "رقم الطلب: $orderNumber",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              _buildInfoRow("الاسم:", name),
              _buildInfoRow("رقم الهاتف:", phone),
              _buildInfoRow("العنوان:", address),
              _buildInfoRow("طريقة الدفع:", paymentMethod),
              _buildInfoRow("تكلفة الشحن:", "$shippingCost ريال"),
              _buildInfoRow("إجمالي المنتجات:", "$total ريال"),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddReviewScreen(
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text("قيّم المتجر"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: Text(value, textAlign: TextAlign.start)),
        ],
      ),
    );
  }
}
