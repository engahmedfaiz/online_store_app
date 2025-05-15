// import 'package:flutter/material.dart';
// import 'package:shop/services/PaymentProviders.dart';
// import '../../models/PaymentProvider.dart';
//
// class PaymentMethodStep extends StatefulWidget {
//   final String storeId;
//   final Function(PaymentProvider) onPaymentMethodSelected;
//
//   const PaymentMethodStep({
//     Key? key,
//     required this.storeId,
//     required this.onPaymentMethodSelected,
//   }) : super(key: key);
//
//   @override
//   State<PaymentMethodStep> createState() => _PaymentMethodStepState();
// }
//
// class _PaymentMethodStepState extends State<PaymentMethodStep> {
//   late Future<List<PaymentProvider>> _futureMethods;
//   String? _selectedId;
//
//   @override
//   void initState() {
//     super.initState();
//     _futureMethods = PaymentService.getPaymentMethods(widget.storeId);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<PaymentProvider>>(
//       future: _futureMethods,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState != ConnectionState.done) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (snapshot.hasError) {
//           return Center(child: Text('خطأ: ${snapshot.error}'));
//         }
//
//         final methods = snapshot.data ?? [];
//
//         if (methods.isEmpty) {
//           return const Center(child: Text("لا توجد طرق دفع متاحة."));
//         }
//
//         return ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: methods.length,
//           itemBuilder: (context, index) {
//             final method = methods[index];
//             return RadioListTile<String>(
//               value: method.id,
//               groupValue: _selectedId,
//               onChanged: method.isActive
//                   ? (id) {
//                 setState(() => _selectedId = id);
//                 widget.onPaymentMethodSelected(method);
//               }
//                   : null,
//               title: Text(method.name),
//               secondary: method.isActive
//                   ? SizedBox(
//                 width: 32,
//                 height: 32,
//                 child: Image.network(
//                   method.imageUrl ?? '',
//                   errorBuilder: (context, error, stackTrace) =>
//                   const Icon(Icons.image_not_supported),
//                 ),
//               )
//                   : const Icon(Icons.lock, color: Colors.grey),
//             );
//           },
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shop/services/PaymentProviders.dart';
import '../../models/PaymentProvider.dart';

class PaymentMethodStep extends StatefulWidget {
  final String storeId;
  final Function(PaymentProvider) onPaymentMethodSelected;
  final PaymentProvider? initiallySelected;

  const PaymentMethodStep({
    Key? key,
    required this.storeId,
    required this.onPaymentMethodSelected,
    this.initiallySelected,
  }) : super(key: key);

  @override
  State<PaymentMethodStep> createState() => _PaymentMethodStepState();
}

class _PaymentMethodStepState extends State<PaymentMethodStep> {
  late Future<List<PaymentProvider>> _futureMethods;
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _futureMethods = PaymentService.getPaymentMethods(widget.storeId);
    _selectedId = widget.initiallySelected?.id;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PaymentProvider>>(
      future: _futureMethods,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'فشل في تحميل طرق الدفع',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${snapshot.error}',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => setState(() {
                    _futureMethods = PaymentService.getPaymentMethods(widget.storeId);
                  }),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        final methods = snapshot.data ?? [];

        if (methods.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.payment, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'لا توجد طرق دفع متاحة حالياً',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'الرجاء المحاولة لاحقاً',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: methods.map((method) {
              final isSelected = _selectedId == method.id;
              final isActive = method.isActive;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade200,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                elevation: 0,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: method.imageUrl != null
                        ? Image.network(
                      method.imageUrl!,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.credit_card,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                        : Icon(
                      Icons.credit_card,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  title: Text(
                    method.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isActive ? null : Colors.grey,
                    ),
                  ),
                  subtitle: method.name != null
                      ? Text(
                    method.name!,
                    style: TextStyle(
                      color: isActive ? Colors.grey : Colors.grey.shade400,
                    ),
                  )
                      : null,
                  trailing: Radio<String>(
                    value: method.id,
                    groupValue: _selectedId,
                    onChanged: isActive
                        ? (id) {
                      setState(() => _selectedId = id);
                      widget.onPaymentMethodSelected(method);
                    }
                        : null,
                  ),
                  onTap: isActive
                      ? () {
                    setState(() => _selectedId = method.id);
                    widget.onPaymentMethodSelected(method);
                  }
                      : null,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}