import 'package:flutter/material.dart';

class CustomerFAQScreen extends StatefulWidget {
  const CustomerFAQScreen({Key? key}) : super(key: key);

  @override
  State<CustomerFAQScreen> createState() => _CustomerFAQScreenState();
}

class _CustomerFAQScreenState extends State<CustomerFAQScreen> {
  List<FAQItemModel> allFaqs = [];
  List<FAQItemModel> displayedFaqs = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeFAQs();
    displayedFaqs = List.from(allFaqs);
  }

  void _initializeFAQs() {
    allFaqs = [
      FAQItemModel(
        question: "كيفية إنشاء حساب جديد؟",
        answer: "اضغط على زر 'تسجيل جديد' في الصفحة الرئيسية ثم املأ البيانات المطلوبة.",
        category: "الحساب",
      ),
      FAQItemModel(
        question: "كيفية إعادة تعيين كلمة المرور؟",
        answer: "اضغط على 'نسيت كلمة المرور' في صفحة تسجيل الدخول واتبع التعليمات المرسلة إلى بريدك.",
        category: "الحساب",
      ),
      FAQItemModel(
        question: "كيفية إضافة عنوان توصيل؟",
        answer: "اذهب إلى 'ملفي' → 'عناوين التوصيل' → 'إضافة عنوان جديد'.",
        category: "التوصيل",
      ),
      FAQItemModel(
        question: "ما هي طرق الدفع المتاحة؟",
        answer: "نقبل الدفع ببطاقات الائتمان، التحويل البنكي، ودفع عند الاستلام.",
        category: "الدفع",
      ),
      FAQItemModel(
        question: "كيفية تتبع الطلب؟",
        answer: "اذهب إلى 'طلباتي' واختر الطلب لمشاهدة حالة التوصيل الحالية.",
        category: "التوصيل",
      ),
      FAQItemModel(
        question: "هل يوجد توصيل في عطلة نهاية الأسبوع؟",
        answer: "نعم، التوصيل متاح كل أيام الأسبوع بما فيها العطلات.",
        category: "التوصيل",
      ),
      FAQItemModel(
        question: "كيفية إرجاع منتج؟",
        answer: "اذهب إلى 'طلباتي' → اختر الطلب → 'طلب إرجاع' واتبع التعليمات.",
        category: "الإرجاع",
      ),
      FAQItemModel(
        question: "ما هي سياسة الإرجاع؟",
        answer: "يمكنك إرجاع المنتجات خلال 14 يومًا من الاستلام بشرط أن تكون بحالة جيدة.",
        category: "الإرجاع",
      ),
      FAQItemModel(
        question: "كيفية التواصل مع خدمة العملاء؟",
        answer: "من خلال قسم 'اتصل بنا' أو عبر الواتساب على الرقم 0551234567.",
        category: "الدعم",
      ),
      FAQItemModel(
        question: "ما هي أوقات عمل خدمة العملاء؟",
        answer: "من الأحد إلى الخميس من 8 صباحًا حتى 10 مساءً.",
        category: "الدعم",
      ),
      // يمكنك إضافة 30 سؤالاً إضافياً هنا بنفس الطريقة
      FAQItemModel(
        question: "هل الأسعار تشمل الضريبة؟",
        answer: "نعم، جميع الأسعار المعروضة تشمل ضريبة القيمة المضافة.",
        category: "الدفع",
      ),
      FAQItemModel(
        question: "كيفية استخدام كوبون الخصم؟",
        answer: "أدخل كود الكوبون في صفحة الدفع قبل إكمال الطلب.",
        category: "الدفع",
      ),
      FAQItemModel(
        question: "ما هو الحد الأدنى للطلب؟",
        answer: "لا يوجد حد أدنى للطلبات، ولكن قد تطبق رسوم توصيل على الطلبات الصغيرة.",
        category: "التوصيل",
      ),
      FAQItemModel(
        question: "كيفية تغيير لغة التطبيق؟",
        answer: "اذهب إلى 'الإعدادات' → 'اللغة' واختر اللغة المفضلة.",
        category: "الحساب",
      ),
      FAQItemModel(
        question: "هل يمكنني إلغاء الطلب بعد التوصيل؟",
        answer: "لا يمكن إلغاء الطلب بعد التوصيل، ولكن يمكنك طلب إرجاع خلال 14 يومًا.",
        category: "الإرجاع",
      ),
      FAQItemModel(
        question: "كيفية تقييم المنتج؟",
        answer: "اذهب إلى 'طلباتي' → اختر الطلب → 'تقييم المنتج'.",
        category: "التقييمات",
      ),
      FAQItemModel(
        question: "ما هو وقت معالجة الطلب؟",
        answer: "تتم معالجة معظم الطلبات خلال 24 ساعة من وقت الطلب.",
        category: "التوصيل",
      ),
      FAQItemModel(
        question: "هل يوجد توصيل سريع؟",
        answer: "نعم، خدمة التوصيل السريع متاحة برسوم إضافية.",
        category: "التوصيل",
      ),
      FAQItemModel(
        question: "كيفية حذف حسابي؟",
        answer: "اتصل بخدمة العملاء لطلب حذف الحساب بشكل دائم.",
        category: "الحساب",
      ),
      FAQItemModel(
        question: "كيفية تحديث بيانات الحساب؟",
        answer: "اذهب إلى 'ملفي' → 'تعديل الملف الشخصي'.",
        category: "الحساب",
      ),
      // يمكنك متابعة إضافة الأسئلة حتى تصل إلى 40 سؤالاً
    ];
  }

  void _searchFAQs(String query) {
    setState(() {
      displayedFaqs = allFaqs
          .where((faq) =>
      faq.question.toLowerCase().contains(query.toLowerCase()) ||
          faq.answer.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الأسئلة الشائعة"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "ابحث في الأسئلة...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: _searchFAQs,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedFaqs.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(
                    displayedFaqs[index].question,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        displayedFaqs[index].answer,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FAQItemModel {
  final String question;
  final String answer;
  final String category;

  FAQItemModel({
    required this.question,
    required this.answer,
    required this.category,
  });
}