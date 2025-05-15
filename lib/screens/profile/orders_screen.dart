import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/constants.dart';
import 'package:shop/services/auth_service.dart';
import 'package:shop/services/order_service.dart';
import 'package:shop/screens/profile/OrderDetailsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/Order.dart';

class OrdersScreen extends StatefulWidget {
  final String? orderNumber;

  const OrdersScreen({super.key, this.orderNumber});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> _orders = [];
  bool _isLoading = true;
  String _selectedFilter = 'الكل';

  final List<String> _filters = [
    'الكل',
    'قيد المعالجة',
    'قيد الشحن',
    'مكتمل',
    'ملغى'
  ];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadCustomerStoreId();
    await _loadOrders();
  }

  Future<void> _loadCustomerStoreId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Implementation remains same
  }

  Future<void> _loadOrders() async {
    final _customerStoreId = await AuthService.fetchCustomerStoreId();

    if (_customerStoreId!.isEmpty) {
      _showErrorSnackbar('لم يتم العثور على معرف العميل');
      setState(() => _isLoading = false);
      return;
    }

    try {
      final orders = await OrderService.getUserOrders();
      setState(() {
        _orders = orders;
        _isLoading = false;
      });

      if (widget.orderNumber != null) {
        final newOrder = orders.firstWhere(
              (o) => o.id.toString() == widget.orderNumber,
          orElse: () => Order.empty(),
        );
        if (!newOrder.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _navigateToOrderDetails(newOrder);
          });
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackbar('فشل تحميل الطلبات: ${e.toString()}');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  List<Order> _getFilteredOrders() {
    if (_selectedFilter == 'الكل') return _orders;
    return _orders
        .where((order) => _getStatusLabel(order.orderStatus) == _selectedFilter)
        .toList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('طلباتي',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 2,
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_rounded, color: Colors.white),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingIndicator()
          : _orders.isEmpty
          ? _buildEmptyState()
          : _buildOrdersList(),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              strokeWidth: 3),
          const SizedBox(height: 20),
          Text('جاري تحميل الطلبات...',
              style: TextStyle(color: kTextLightColor, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_rounded,
              size: 100, color: kSecondaryColor.withOpacity(0.5)),
          const SizedBox(height: 20),
          Text('لا توجد طلبات سابقة',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kTextColor)),
          const SizedBox(height: 10),
          Text('يمكنك البدء بالتسوق وإنشاء طلبات جديدة',
              style: TextStyle(color: kTextLightColor)),
        ],
      ),
    );
  }

  Widget _buildOrdersList() {
    return RefreshIndicator(
      backgroundColor: kBackgroundColor,
      color: kPrimaryColor,
      onRefresh: _loadOrders,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _getFilteredOrders().length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final order = _getFilteredOrders()[index];
          return _buildOrderCard(order);
        },
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [Colors.white, kBackgroundColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => _navigateToOrderDetails(order),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'الطلب #${order.id}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: _buildStatusChip(order.orderStatus),
                    ),
                  ],
                ),
                const Divider(height: 30, thickness: 1),
                _buildOrderDetailRow(
                  icon: Icons.calendar_today_rounded,
                  label: DateFormat('dd/MM/yyyy - hh:mm a').format(order.date),
                ),
                const SizedBox(height: 12),
                _buildOrderDetailRow(
                  icon: Icons.attach_money_rounded,
                  label: 'الإجمالي: ${order.total.toStringAsFixed(2)} ر.س',
                  isTotal: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildStatusChip(String status) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 120),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(status),
            size: 16,
            color: _getStatusColor(status),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              _getStatusLabel(status),
              style: TextStyle(
                color: _getStatusColor(status),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildOrderDetailRow({
    required IconData icon,
    required String label,
    bool isTotal = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: kSecondaryColor),
        const SizedBox(width: 12),
        Text(label,
            style: TextStyle(
                fontSize: 14,
                color: isTotal ? kPrimaryColor : kTextColor,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.trim()) {
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
    switch (status.trim()) {
      case 'PROCESSING':
        return Icons.hourglass_top_rounded;
      case 'SHIPPED':
        return Icons.local_shipping_rounded;
      case 'DELIVERED':
        return Icons.check_circle_rounded;
      case 'CANCELED':
        return Icons.cancel_rounded;
      default:
        return Icons.info_rounded;
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
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('تصفية الطلبات',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor)),
            ),
            ..._filters.map((filter) => RadioListTile<String>(
              title: Row(
                children: [
                  Icon(_getFilterIcon(filter), size: 20),
                  const SizedBox(width: 12),
                  Text(filter),
                ],
              ),
              value: filter,
              groupValue: _selectedFilter,
              activeColor: kPrimaryColor,
              onChanged: (value) {
                setState(() => _selectedFilter = value!);
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  IconData _getFilterIcon(String filter) {
    switch (filter) {
      case 'قيد المعالجة':
        return Icons.hourglass_top_rounded;
      case 'قيد الشحن':
        return Icons.local_shipping_rounded;
      case 'مكتمل':
        return Icons.check_circle_rounded;
      case 'ملغى':
        return Icons.cancel_rounded;
      default:
        return Icons.all_inbox_rounded;
    }
  }

  void _navigateToOrderDetails(Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(order: order),
      ),
    );
  }
}