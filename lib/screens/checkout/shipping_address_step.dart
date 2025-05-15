// import 'package:flutter/material.dart';
// import 'package:shop/models/ShippingAddress.dart';
// import 'package:shop/screens/checkout/AddNewAddressScreen.dart';
// import 'package:shop/services/AddressService.dart';
//
// class ShippingAddressStep extends StatefulWidget {
//   final String customerId;
//   final String storeId;
//   final String token;
//   final Function(ShippingAddress) onAddressSelected;
//
//   const ShippingAddressStep({
//     Key? key,
//     required this.customerId,
//     required this.storeId,
//     required this.token,
//     required this.onAddressSelected,
//   }) : super(key: key);
//
//   @override
//   State<ShippingAddressStep> createState() => _ShippingAddressStepState();
// }
//
// class _ShippingAddressStepState extends State<ShippingAddressStep> {
//   List<ShippingAddress> addresses = [];
//   String? selectedAddressId;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchAddresses();
//   }
//
//   Future<void> _fetchAddresses() async {
//     try {
//       final data = await AddressService.fetchAddresses(
//         customerId: widget.customerId,
//         storeId: widget.storeId,
//         token: widget.token,
//       );
//       setState(() {
//         addresses = data.cast<ShippingAddress>();
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() => isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("فشل في جلب العناوين")),
//       );
//     }
//   }
//
//   void _onSelect(ShippingAddress address) {
//     setState(() => selectedAddressId = address.id);
//     widget.onAddressSelected(address);
//   }
//
//   void _navigateToAddNewAddress() async {
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => AddNewAddressScreen(
//
//         ),
//       ),
//     );
//
//     if (result == true) {
//       // إذا تم إضافة عنوان جديد، قم بتحديث القائمة
//       _fetchAddresses();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) return const Center(child: CircularProgressIndicator());
//
//     return Column(
//       children: [
//         ...addresses.map((address) {
//           return ListTile(
//             title: Text(address.addressName),
//             subtitle: Text("${address.city}, ${address.district}"),
//             leading: Radio<String>(
//               value: address.id ?? '',
//               groupValue: selectedAddressId,
//               onChanged: (_) => _onSelect(address),
//             ),
//           );
//         }).toList(),
//         const SizedBox(height: 16),
//         ElevatedButton.icon(
//           onPressed: _navigateToAddNewAddress,
//           icon: const Icon(Icons.add_location_alt),
//           label: const Text("إضافة عنوان جديد"),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blueAccent,
//             foregroundColor: Colors.white,
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shop/models/ShippingAddress.dart';
import 'package:shop/screens/checkout/AddNewAddressScreen.dart';
import 'package:shop/services/AddressService.dart';

class ShippingAddressStep extends StatefulWidget {
  final String customerId;
  final String storeId;
  final String token;
  final Function(ShippingAddress) onAddressSelected;

  const ShippingAddressStep({
    Key? key,
    required this.customerId,
    required this.storeId,
    required this.token,
    required this.onAddressSelected,
  }) : super(key: key);

  @override
  State<ShippingAddressStep> createState() => _ShippingAddressStepState();
}

class _ShippingAddressStepState extends State<ShippingAddressStep> {
  List<ShippingAddress> addresses = [];
  String? selectedAddressId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  Future<void> _fetchAddresses() async {
    try {
      final data = await AddressService.fetchAddresses(
        customerId: widget.customerId,
        storeId: widget.storeId,
        token: widget.token,
      );
      setState(() {
        addresses = data.cast<ShippingAddress>();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("فشل في جلب العناوين")),
      );
    }
  }

  void _onSelect(ShippingAddress address) {
    setState(() => selectedAddressId = address.id);
    widget.onAddressSelected(address);
  }

  void _navigateToAddNewAddress() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNewAddressScreen(),
      ),
    );

    if (result == true) {
      await _fetchAddresses();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];
                return ListTile(
                  title: Text(address.addressName),
                  subtitle: Text("${address.city}, ${address.district}"),
                  leading: Radio<String>(
                    value: address.id ?? '',
                    groupValue: selectedAddressId,
                    onChanged: (_) => _onSelect(address),
                  ),
                  tileColor: selectedAddressId == address.id
                      ? Colors.blue.withOpacity(0.1)
                      : null,
                );
              },
              separatorBuilder: (context, index) => const Divider(height: 1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: _navigateToAddNewAddress,
              icon: const Icon(Icons.add_location_alt),
              label: const Text("إضافة عنوان جديد"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
        ],
      ),
    );
  }
}