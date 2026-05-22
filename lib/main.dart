import 'package:flutter/material.dart';
import 'package:lapor_keuangan/db/hive_helper.dart';
import 'package:lapor_keuangan/screen/landing.dart';
import 'package:lapor_keuangan/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveHelper.initHive();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LaporKeuangan',
      theme: AppTheme.lightTheme,
      home: const LandingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
