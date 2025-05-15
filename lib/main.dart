
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/route/router.dart' as router;
import 'package:shop/services/sub_and_categery_api.dart';
import 'package:shop/theme/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shop/theme/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Hive
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  await Hive.initFlutter();
  await Hive.openBox<String>('favorites');
  // افتح صندوق للسلة
  await Hive.openBox('cartBox');
  ApiService.initialize('67fa545f6971a95b3e78f49b');

  await Hive.initFlutter(dir.path);

  // فتح الـ Boxes
  await Hive.openBox<String>('favorites');
  await Hive.openBox('settingsBox');

  // تهيئة API
  ApiService.initialize('67fa545f6971a95b3e78f49b');

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    final String storeId ="67fa545f6971a95b3e78f49b";
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      await themeProvider.loadCustomization(storeId);
      await themeProvider.loadThemeMode();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop Template by The Flutter Way',
      theme: AppTheme.lightTheme(context), // الوضع النهاري
      darkTheme: AppTheme.darkTheme(context), // الوضع الليلي
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      onGenerateRoute: router.generateRoute,
      initialRoute: entryPointScreenRoute,
    );
  }
}
