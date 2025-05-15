
import 'package:flutter/material.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/services/auth_service.dart';
import 'package:shop/services/cart_service.dart';
import 'package:shop/screens/checkout/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  final String storeId;

  const CartScreen({super.key,required this.storeId});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;

  bool isCheckingOut = false;
  double totalAmount = 0;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    try {
      final items = await CartService.getCartItems();
      final total = await _calculateTotal(items);

      if (mounted) {
        setState(() {
          cartItems = items;
          totalAmount = total;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        _showSnackBar("Failed to load cart items: ${e.toString()}");
      }
    }
  }

  Future<double> _calculateTotal(List<Map<String, dynamic>> items) async {
    double total = 0;
    for (var item in items) {
      final price = (item['salePrice'] ?? item['price'] ?? item['productPrice']) as double;
      final qty = (item['qty'] ?? 1) as int;
      total += price * qty;
    }
    return total;
  }

  Future<void> _updateQuantity(String productId, int newQty) async {
    try {
      await CartService.updateQuantity(productId, newQty);
      await _loadCartItems();
    } catch (e) {
      _showSnackBar("Failed to update quantity: ${e.toString()}");
    }
  }

  Future<void> _clearCart() async {
    try {
      await CartService.clearCart();
      await _loadCartItems();
      _showSnackBar("Cart cleared successfully");
    } catch (e) {
      _showSnackBar("Failed to clear cart: ${e.toString()}");
    }
  }

  Future<void> _proceedToCheckout(BuildContext context) async {
    // التحقق من تسجيل الدخول
    final isLoggedIn = await AuthService.isLoggedIn();

    if (isLoggedIn) {
      _navigateToCheckout(context);
    } else {
      _navigateToLogin(context);
    }
  }
  void _navigateToCheckout(BuildContext context) {
    _showSnackBar("جاري تحويلك إلى صفحة الدفع");
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(
        builder: (_) => CheckoutScreen(),
      ));
    });
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.pushNamed(
      context,
      logInScreenRoute,
      arguments: {
        'storeId': widget.storeId,
        'onSuccess': (token) async {
          await AuthService.saveToken(token);
          _navigateToCheckout(context);
        },
      },
    );
  }
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear Cart"),
        content: const Text("Are you sure you want to remove all items from your cart?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
              _clearCart();
            },
            child: const Text("Clear All", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text("Loading..."),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: _buildLoadingIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Cart"),
        centerTitle: true,
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _showClearCartDialog,
            ),
        ],
      ),
      body: _buildCartContent(),
      bottomNavigationBar: cartItems.isNotEmpty ? _buildCheckoutBar() : null,
    );
  }

  Widget _buildCartContent() {
    if (cartItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              "Your cart is empty",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Browse our store and add your favorite items",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Browse Products"),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadCartItems,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cartItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _buildCartItem(cartItems[index]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    final qty = (item['qty'] ?? 1) as int;
    final price = (item['salePrice'] ?? item['price'] ?? item['productPrice']) as double;
    final total = price * qty;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item['imageUrl'] ?? '',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Price: \$${price.toStringAsFixed(2)}",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Total: \$${total.toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, size: 18, color: qty > 1 ? Colors.red : Colors.grey),
                        onPressed: () => _updateQuantity(item['id'], qty - 1),
                      ),
                      Text(qty.toString()),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18, color: Colors.green),
                        onPressed: () => _updateQuantity(item['id'], qty + 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                  onPressed: () => _updateQuantity(item['id'], 0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total (${cartItems.length} items)"),
              Text(
                "\$${totalAmount.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: isCheckingOut ? null : () => _proceedToCheckout(context),
              child: isCheckingOut
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Text("Proceed to Checkout"),
            ),
          ),
        ],
      ),
    );
  }
}