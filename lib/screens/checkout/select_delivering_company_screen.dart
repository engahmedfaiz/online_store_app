import 'package:flutter/material.dart';
import 'package:shop/models/DeliveringProvider.dart';
class SelectDeliveringCompanyScreen extends StatelessWidget {
  final Function(DeliveringProvider) onProviderSelected;
  final List<DeliveringProvider> deliveringProviders;

  SelectDeliveringCompanyScreen({
    required this.onProviderSelected,
    required this.deliveringProviders,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var provider in deliveringProviders)
          if (provider.isActive)
            ListTile(
              title: Text(provider.name),
              subtitle: Text(
                'المدة: ${provider.duration ?? "غير محددة"}, السعر: ${provider.price != null ? provider.price.toString() : "غير محدد"}',
                textDirection: TextDirection.rtl,
              ),
              onTap: () => onProviderSelected(provider),
            ),
      ],
    );
  }
}
