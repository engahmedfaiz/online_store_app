import 'package:flutter/material.dart';
import 'package:shop/models/StoreModel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../services/api_service.dart';

class HelpScreen extends StatelessWidget {
  final String storeId;

  const HelpScreen({super.key, required this.storeId});

  Future<Store?> _loadStoreData() async {
    try {
      return await ApiService.fetchStore(storeId: storeId);
    } catch (e) {
      print("حدث خطأ أثناء تحميل بيانات المتجر: $e");
      return null;
    }
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'تعذر فتح الرابط: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الحصول على المساعدة"),
        centerTitle: true,
      ),
      body: FutureBuilder<Store?>(
        future: _loadStoreData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 50, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    "تعذر تحميل معلومات المتجر",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("العودة"),
                  ),
                ],
              ),
            );
          }

          final store = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildContactCard(
                  context,
                  title: "معلومات الاتصال",
                  children: [
                    _buildContactItem(
                      icon: Icons.store,
                      text: store.businessName,
                    ),
                    _buildContactItem(
                      icon: Icons.person,
                      text: store.contactPerson,
                    ),
                    _buildContactItem(
                      icon: Icons.phone,
                      text: store.phone,
                      isClickable: true,
                      onTap: () => _launchUrl("tel:${store.phone}"),
                    ),
                    _buildContactItem(
                      icon: Icons.message, // لا يوجد Icons.whatsapp، استبدلناه
                      text: store.whatsappPhone,
                      isClickable: true,
                      onTap: () =>
                          _launchUrl("https://wa.me/${store.whatsappPhone}"),
                    ),
                    _buildContactItem(
                      icon: Icons.location_on,
                      text: store.physicalAddress,
                      isClickable: true,
                      onTap: () => _launchUrl(
                          "https://maps.google.com/?q=${store.physicalAddress}"),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                if (store.socialLinks != null && store.socialLinks!.isNotEmpty)
                  _buildSocialMediaSection(context, store.socialLinks!),

                const SizedBox(height: 24),

                _buildFAQSection(context),

                const SizedBox(height: 24),

                _buildContactForm(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContactCard(BuildContext context,
      {required String title, required List<Widget> children}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline6?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String text,
    bool isClickable = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: isClickable ? onTap : null,
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text.isNotEmpty ? text : 'غير متوفر',
                style: TextStyle(
                  fontSize: 16,
                  color: isClickable ? Colors.blue : Colors.black,
                  decoration: isClickable
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaSection(
      BuildContext context, Map<String, String> socialLinks) {
    final platforms = {
      'facebook': {'icon': Icons.facebook, 'name': 'فيسبوك'},
      'twitter': {'icon': Icons.alternate_email, 'name': 'تويتر'}, // لا يوجد Icons.twitter
      'instagram': {'icon': Icons.camera_alt, 'name': 'إنستجرام'},
      'linkedin': {'icon': Icons.link, 'name': 'لينكدإن'},
      'youtube': {'icon': Icons.play_circle_fill, 'name': 'يوتيوب'},
    };

    return _buildContactCard(
      context,
      title: "وسائل التواصل الاجتماعي",
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: socialLinks.entries.map((entry) {
            final platform = platforms[entry.key.toLowerCase()] ??
                {'icon': Icons.link, 'name': entry.key};
            return ActionChip(
              avatar: Icon(platform['icon'] as IconData?),
              label: Text(platform['name'] as String),
              onPressed: () => _launchUrl(entry.value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFAQSection(BuildContext context) {
    final faqs = [
      {
        'question': 'كيف يمكنني تتبع طلبي؟',
        'answer': 'يمكنك تتبع طلبياتك من قسم "طلباتي" في ملفك الشخصي.'
      },
      {
        'question': 'ما هي سياسة الإرجاع؟',
        'answer': 'يمكنك إرجاع المنتجات خلال 14 يومًا من الاستلام بشرط أن تكون بحالتها الأصلية.'
      },
      {
        'question': 'كيف أتصل بخدمة العملاء؟',
        'answer': 'يمكنك الاتصال بخدمة العملاء على الرقم الموجود أعلى الصفحة أو عبر نموذج الاتصال.'
      },
    ];

    return _buildContactCard(
      context,
      title: "الأسئلة الشائعة",
      children: [
        ...faqs.map((faq) => ExpansionTile(
          title: Text(faq['question']!),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(faq['answer']!),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildContactForm(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final messageController = TextEditingController();

    return _buildContactCard(
      context,
      title: "تواصل معنا",
      children: [
        Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'الاسم الكامل',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                value!.isEmpty ? 'الرجاء إدخال الاسم' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) =>
                value!.isEmpty ? 'الرجاء إدخال البريد الإلكتروني' : null,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: messageController,
                decoration: const InputDecoration(
                  labelText: 'رسالتك',
                  prefixIcon: Icon(Icons.message),
                ),
                validator: (value) =>
                value!.isEmpty ? 'الرجاء إدخال الرسالة' : null,
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم إرسال رسالتك بنجاح'),
                      ),
                    );
                  }
                },
                child: const Text('إرسال الرسالة'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
