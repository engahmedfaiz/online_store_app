// import 'package:flutter/material.dart';
// import 'package:shop/models/PaymentProvider.dart';
// class SelectPaymentMethodScreen extends StatelessWidget {
//   final Function(PaymentProvider) onPaymentSelected;
//   final List<PaymentProvider> paymentProviders;
//
//   SelectPaymentMethodScreen({
//     required this.onPaymentSelected,
//     required this.paymentProviders,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         for (var provider in paymentProviders)
//           if (provider.isActive) // عرض المزودات النشطة فقط
//             ListTile(
//               title: Text(provider.name),
//               onTap: () => onPaymentSelected(provider),
//             ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shop/models/PaymentProvider.dart';

class SelectPaymentMethodScreen extends StatelessWidget {
  final Function(PaymentProvider) onPaymentSelected;
  final List<PaymentProvider> paymentProviders;
  final PaymentProvider? selectedProvider;

  const SelectPaymentMethodScreen({
    Key? key,
    required this.onPaymentSelected,
    required this.paymentProviders,
    this.selectedProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activeProviders = paymentProviders.where((p) => p.isActive).toList();

    if (activeProviders.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد طرق دفع متاحة حالياً',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),
          ...activeProviders.map((provider) {
            final isSelected = selectedProvider?.id == provider.id;
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: isSelected
                    ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
                    : BorderSide.none,
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: provider.imageUrl != null
                    ? Image.network(
                  provider.imageUrl!,
                  width: 40,
                  height: 40,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.payment,
                    color: Theme.of(context).primaryColor,
                  ),
                )
                    : Icon(
                  Icons.payment,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  provider.name,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: provider.name != null ? Text(provider.name!) : null,
                trailing: isSelected
                    ? Icon(
                  Icons.check_circle,
                  color: Theme.of(context).primaryColor,
                )
                    : null,
                onTap: () => onPaymentSelected(provider),
              ),
            );
          }).toList(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}