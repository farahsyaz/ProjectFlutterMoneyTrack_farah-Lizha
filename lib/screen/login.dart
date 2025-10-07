import 'package:flutter/material.dart';
import 'package:lapor_keuangan/db/hive_helper.dart';
import 'package:lapor_keuangan/screen/home.dart';
import 'package:lapor_keuangan/screen/regis.dart'; // Ganti dengan halaman utama setelah login

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Fungsi untuk login
  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Username dan password harus diisi!")));
      return;
    }

    final users = HiveHelper.getUsers(); // Ambil daftar pengguna dari Hive
    bool isValid = false;

    // Periksa apakah username dan password cocok dengan data yang ada di Hive
    for (var user in users) {
      if (user['username'] == username && user['password'] == password) {
        isValid = true;
        break;
      }
    }

    if (isValid) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login berhasil!")));
      // Jika login berhasil, navigasi ke halaman utama
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Myhome()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Username atau password salah!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text("Login"),
            ),
            TextButton(
              onPressed: () {
                // Navigasi ke halaman daftar pengguna jika belum punya akun
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text("Belum punya akun? Daftar di sini."),
            ),
          ],
        ),
      ),
    );
  }
}
