// import 'package:flutter/material.dart';
//
// class AddContactInfoScreen extends StatefulWidget {
//   final Function(String firstName, String lastName, String email, String phone) onSave;
//
//   const AddContactInfoScreen({super.key, required this.onSave});
//
//   @override
//   State<AddContactInfoScreen> createState() => _AddContactInfoScreenState();
// }
//
// class _AddContactInfoScreenState extends State<AddContactInfoScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//
//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }
//
//   void _submit() {
//     if (_formKey.currentState!.validate()) {
//       widget.onSave(
//         _firstNameController.text.trim(),
//         _lastNameController.text.trim(),
//         _emailController.text.trim(),
//         _phoneController.text.trim(),
//       );
//       Navigator.pop(context);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("معلومات التواصل")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _firstNameController,
//                 decoration: const InputDecoration(labelText: "الاسم الأول"),
//                 validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _lastNameController,
//                 decoration: const InputDecoration(labelText: "الاسم الأخير"),
//                 validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _emailController,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: const InputDecoration(labelText: "البريد الإلكتروني"),
//                 validator: (val) => val == null || !val.contains('@') ? 'بريد غير صالح' : null,
//               ),
//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _phoneController,
//                 keyboardType: TextInputType.phone,
//                 decoration: const InputDecoration(labelText: "رقم الهاتف"),
//                 validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: _submit,
//                 child: const Text("حفظ والمتابعة"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class AddContactInfoScreen extends StatefulWidget {
  final Function(String firstName, String lastName, String email, String phone) onSave;

  const AddContactInfoScreen({super.key, required this.onSave});

  @override
  State<AddContactInfoScreen> createState() => _AddContactInfoScreenState();
}

class _AddContactInfoScreenState extends State<AddContactInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    _firstNameController;
    _lastNameController;
    _emailController;
    _phoneController;
    super.initState();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
        _emailController.text.trim(),
        _phoneController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: "الاسم الأول",
                border: OutlineInputBorder(),
              ),
              validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: "الاسم الأخير",
                border: OutlineInputBorder(),
              ),
              validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "البريد الإلكتروني",
                border: OutlineInputBorder(),
              ),
              validator: (val) => val == null || !val.contains('@') ? 'بريد غير صالح' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "رقم الهاتف",
                border: OutlineInputBorder(),
              ),
              validator: (val) => val == null || val.isEmpty ? 'مطلوب' : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _submit,
                child: const Text("حفظ والمتابعة"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}