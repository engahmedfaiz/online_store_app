import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/product_model.dart';

import 'components/wallet_balance_card.dart';
import 'components/wallet_history_card.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                sliver: SliverToBoxAdapter(
                  child: WalletBalanceCard(
                    balance: 384.90,
                    onTabChargeBalance: () {},
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(top: defaultPadding / 2),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    "Wallet history",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ),
              // SliverList(
              //   delegate: SliverChildBuilderDelegate(
              //         (context, index) => Padding(
              //       padding: const EdgeInsets.only(top: defaultPadding),
              //       child: WalletHistoryCard(
              //         isReturn: index == 1,
              //         date: "JUN 12, 2020",
              //         amount: 129,
              //         products: [
              //           ProductModel(
              //             id: "1",
              //             title: "Mountain Warehouse for Women",
              //             sku: "SKU001",
              //             imageUrl: productDemoImg1,
              //             storeId: "store001",
              //             descripti: "Demo product",
              //             wholesaleQty: 10,
              //             categoryId: "cat001",
              //             subCategoryId: "subcat001",
              //             productPrice: 540,
              //             salePrice: 420,
              //             wholesalePrice: 500,
              //             productStock: 50,
              //             productImages: [productDemoImg1],
              //             isActive: true,
              //             isOnSale: true,
              //             isWholesale: false,
              //           ),
              //           ProductModel(
              //             id: "2",
              //             title: "Mountain Beta Warehouse",
              //             sku: "SKU002",
              //             imageUrl: productDemoImg4,
              //             storeId: "store002",
              //             descripti: "Demo product",
              //             wholesaleQty: 8,
              //             categoryId: "cat002",
              //             subCategoryId: "subcat002",
              //             productPrice: 800,
              //             salePrice: 800,
              //             wholesalePrice: 780,
              //             productStock: 30,
              //             productImages: [productDemoImg4],
              //             isActive: true,
              //             isOnSale: false,
              //             isWholesale: false,
              //           ),
              //         ],
              //       ),
              //     ),
              //     childCount: 4,
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
