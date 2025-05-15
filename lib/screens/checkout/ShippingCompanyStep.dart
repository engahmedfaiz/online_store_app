import 'package:flutter/material.dart';
import 'package:shop/models/DeliveringProvider.dart';
import 'package:shop/services/DeliveringProviders.dart';

class ShippingCompanyStep extends StatefulWidget {
  final String storeId;
  final Function(DeliveringProvider) onCompanySelected;

  const ShippingCompanyStep({
    Key? key,
    required this.storeId,
    required this.onCompanySelected,
  }) : super(key: key);

  @override
  State<ShippingCompanyStep> createState() => _ShippingCompanyStepState();
}

class _ShippingCompanyStepState extends State<ShippingCompanyStep> {
  late Future<List<DeliveringProvider>> _futureProviders;
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _futureProviders = ShippingService.getShippingCompanies(widget.storeId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DeliveringProvider>>(
      future: _futureProviders,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('خطأ: ${snapshot.error}'));
        }
        final companies = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "اختر شركة الشحن",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...companies.map((company) {
              return RadioListTile<String>(
                value: company.id,
                groupValue: _selectedId,
                onChanged: (id) {
                  setState(() => _selectedId = id);
                  widget.onCompanySelected(company);
                },
                title: Text(company.name),
                secondary: company.logoUrl != null
                    ? Image.network(company.logoUrl!, width: 40, height: 40)
                    : null,
              );
            }).toList(),
          ],
        );
      },
    );
  }
}
