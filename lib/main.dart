import 'package:flutter/material.dart';
import 'package:lapor_keuangan/db/hive_helper.dart';
import 'package:lapor_keuangan/screen/landing.dart';
import 'package:lapor_keuangan/theme/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Tambahkan baris ini untuk mencegah layar merah (LocaleDataException)
  await initializeDateFormatting('id_ID', null);

  try {
    await HiveHelper.initHive();
  } catch (e) {
    debugPrint("Error inisialisasi Hive: $e");
  }

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
