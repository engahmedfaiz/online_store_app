import 'package:flutter/material.dart';
import 'package:shop/models/sub_category_model.dart';
import 'package:shop/services/api_service.dart';

class DiscoverWithImageScreen extends StatefulWidget {
  final String storeId;
  final String categoryId;
  final String title;

  const DiscoverWithImageScreen({
    Key? key,
    required this.storeId,
    required this.categoryId,
    required this.title,
  }) : super(key: key);

  @override
  State<DiscoverWithImageScreen> createState() => _DiscoverWithImageScreenState();
}

class _DiscoverWithImageScreenState extends State<DiscoverWithImageScreen> {
  late Future<List<SubCategoryModel>> subCategoriesFuture;

  @override
  void initState() {
    super.initState();
    subCategoriesFuture = ApiService.getSubCategories(
      storeId: widget.storeId,
      categoryId: widget.categoryId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<SubCategoryModel>>(
        future: subCategoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            final subCategories = snapshot.data!;
            return ListView.builder(
              itemCount: subCategories.length,
              itemBuilder: (context, index) {
                final subCategory = subCategories[index];
                return ListTile(
                  leading: subCategory.imageUrl.isNotEmpty
                      ? Image.network(subCategory.imageUrl, width: 50)
                      : Icon(Icons.image),
                  title: Text(subCategory.title),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/productScreen', // تأكد من أنه معرف في routes
                      arguments: {
                        'subcategoryId': subCategory.id,
                        'subcategoryTitle': subCategory.title,
                        'storeId': widget.storeId, // تمرير storeId هنا
                      },
                    );
                  },
                );
              },
            );
          }

          return const Center(child: Text('لا توجد فئات فرعية'));
        },
      ),
    );
  }
}
