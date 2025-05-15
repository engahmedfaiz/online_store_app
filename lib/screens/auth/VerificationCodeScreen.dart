
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shop/services/auth_service.dart';
import 'package:shop/screens/auth/complete_profile_screen.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String email;
  final String storeId;
  final Function(String) onSuccess;

  const VerificationCodeScreen({
    Key? key,
    required this.email,
    required this.storeId,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    if (_isDisposed || !mounted) return;

    setState(() => _isLoading = true);

    try {
      final response = await AuthService.verifyCode(
        widget.email,
        _codeController.text,
      );

      if (_isDisposed || !mounted) return;

      if (response.containsKey('step') && response['step'] == 'complete-profile') {
        _navigateToCompleteProfile(widget.email);
      } else if (response.containsKey('token')) {
        widget.onSuccess(response['token']);
        _navigateToCheckout();
      } else {
        _showError(response['message'] ?? 'رمز التحقق غير صحيح');
      }
    } on TimeoutException {
      _showError('انتهى وقت الانتظار');
    } catch (e) {
      _showError('حدث خطأ غير متوقع');
    } finally {
      if (!_isDisposed && mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _navigateToCompleteProfile(String email) {
    if (_isDisposed || !mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => CompleteProfileScreen(
          email: email,
          onSuccess: (token) {
            widget.onSuccess(token);
            _navigateToCheckout();
          },
        ),
      ),
    );
  }

  void _navigateToCheckout() {
    if (_isDisposed || !mounted) return;
    Navigator.pushReplacementNamed(context, 'checkout');
  }

  void _showError(String message) {
    if (_isDisposed || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تحقق من الرمز")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("تم إرسال رمز التحقق إلى ${widget.email}"),
            const SizedBox(height: 20),
            TextFormField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'رمز التحقق',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyCode,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text("تحقق"),
            ),
          ],
        ),
      ),
    );
  }
}
