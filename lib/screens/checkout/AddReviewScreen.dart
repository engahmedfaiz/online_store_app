import 'package:flutter/material.dart';
import 'package:shop/services/auth_service.dart';
import '../../services/review_service.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({super.key});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  int _rating = 5;
  String _comment = '';
  bool _isSubmitting = false;

  Future<void> _submitReview() async {
    final customerStoreId = await AuthService.fetchCustomerStoreId();
    final storeId = await AuthService.getStoreId();

    print("storeId: $storeId");
    print("customerStoreId: $customerStoreId");

    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => _isSubmitting = true);
    try {
      final success = await ReviewService.createReview(
        _rating,
        _comment,
        storeId: storeId,
        customerStoreId: customerStoreId,
      );

      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تم إرسال التقييم بنجاح")),
        );
      }
    } catch (e) {
      setState(() => _isSubmitting = false);

      String errorMessage = e.toString();
      if (errorMessage.contains("لقد قمت بتقييم هذا المتجر من قبل")) {
        errorMessage = "لا يمكنك تقييم هذا المتجر مرتين.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إضافة تقييم")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text("اختر عدد النجوم", style: TextStyle(fontSize: 18)),
              DropdownButtonFormField<int>(
                value: _rating,
                items: List.generate(5, (index) {
                  final ratingValue = index + 1;
                  return DropdownMenuItem(
                    value: ratingValue,
                    child: Text("$ratingValue نجمة"),
                  );
                }),
                onChanged: (value) {
                  setState(() {
                    _rating = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'تعليقك',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'اكتب تعليقًا' : null,
                onSaved: (value) => _comment = value ?? '',
              ),
              const SizedBox(height: 20),
              _isSubmitting
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _submitReview,
                child: const Text("إرسال التقييم"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
