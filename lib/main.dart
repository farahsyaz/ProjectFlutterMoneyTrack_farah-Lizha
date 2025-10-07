import 'package:flutter/material.dart';
// import 'package:lapor_keuangan/screen/home.dart';
import 'package:lapor_keuangan/db/hive_helper.dart';
import 'package:lapor_keuangan/screen/login.dart';
// import 'package:lapor_keuangan/screen/regis.dart';

void main() async {
  // Tambahkan async pada fungsi main
  WidgetsFlutterBinding.ensureInitialized(); // Inisialisasi widget binding
  await HiveHelper.initHive(); // Inisialisasi Hive
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Flutter Hello World',
      // Application theme data, you can set the colors for the application as
      // you want
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // A widget which will be started on application startup
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
