import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/constants.dart';
import '../../models/Order.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Order order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الطلب',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: kPrimaryColor,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildOrderStatusHeader(),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildInfoCard(
                      title: 'معلومات الطلب',
                      children: [
                        _buildDetailItem(
                          icon: Icons.confirmation_number,
                          label: 'رقم الطلب',
                          value: order.id,
                        ),
                        _buildDetailItem(
                          icon: Icons.calendar_today,
                          label: 'التاريخ',
                          value: DateFormat('dd/MM/yyyy - hh:mm a').format(order.date),
                        ),
                        _buildDetailItem(
                          icon: Icons.payment,
                          label: 'طريقة الدفع',
                          value: order.paymentMethod,
                        ),
                        _buildDetailItem(
                          icon: Icons.attach_money,
                          label: 'الإجمالي',
                          value: '${order.total.toStringAsFixed(2)} ر.س',
                          isTotal: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoCard(
                      title: 'معلومات الشحن',
                      children: [
                        _buildDetailItem(
                          icon: Icons.location_on,
                          label: 'العنوان',
                          value: order.shippingAddress,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _buildBackButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: _getStatusColor(order.orderStatus).withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getStatusIcon(order.orderStatus),
            color: _getStatusColor(order.orderStatus),
          ),
          const SizedBox(width: 10),
          Text(
            _getStatusLabel(order.orderStatus),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _getStatusColor(order.orderStatus),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            const Divider(height: 25),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    bool isTotal = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: kSecondaryColor),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                    color: isTotal ? kPrimaryColor : kTextColor,
                  ),
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.arrow_back, size: 20),
        label: const Text('العودة إلى الطلبات'),
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  // دوال مساعدة لعرض الحالة
  Color _getStatusColor(String status) {
    switch (status.trim().toUpperCase()) {
      case 'PROCESSING':
        return kProcessingColor;
      case 'SHIPPED':
        return kShippedColor;
      case 'DELIVERED':
        return kDeliveredColor;
      case 'CANCELED':
        return kCanceledColor;
      default:
        return kSecondaryColor;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.trim().toUpperCase()) {
      case 'PROCESSING':
        return Icons.hourglass_top;
      case 'SHIPPED':
        return Icons.local_shipping;
      case 'DELIVERED':
        return Icons.check_circle;
      case 'CANCELED':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.trim().toUpperCase()) {
      case 'PROCESSING':
        return 'قيد المعالجة';
      case 'SHIPPED':
        return 'قيد الشحن';
      case 'DELIVERED':
        return 'مكتمل';
      case 'CANCELED':
        return 'ملغى';
      default:
        return status;
    }
  }
}