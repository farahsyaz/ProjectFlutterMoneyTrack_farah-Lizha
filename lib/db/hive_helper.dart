import 'package:hive_flutter/hive_flutter.dart';

class HiveHelper {
  static const String _transactionsBoxName = "transactions";
  static const String _usersBoxName = "users"; // Box baru untuk pengguna

  // Inisialisasi Hive dan membuka box
  static Future<void> initHive() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(_transactionsBoxName); // Box untuk transaksi
    await Hive.openBox<Map>(_usersBoxName); // Box untuk pengguna
  }

  // Mendapatkan Box untuk transaksi
  static Box<Map> getTransactionsBox() => Hive.box<Map>(_transactionsBoxName);

  // Mendapatkan Box untuk pengguna
  static Box<Map> getUsersBox() => Hive.box<Map>(_usersBoxName);

  // Fungsi untuk menambahkan transaksi
  static Future<void> addTransaction(
      String name, int amount, String type) async {
    final box = getTransactionsBox();
    await box.add({'name': name, 'amount': amount, 'type': type});
  }

  // Fungsi untuk mendapatkan daftar transaksi
  static List<Map<String, dynamic>> getTransactions() {
    final box = getTransactionsBox();
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  // Fungsi untuk menghapus transaksi
  static Future<void> deleteTransaction(int index) async {
    final box = getTransactionsBox();
    await box.deleteAt(index);
  }

  // Fungsi untuk mengupdate transaksi
  static Future<void> updateTransaction(
      int index, String name, int amount, String type) async {
    final box = getTransactionsBox();

    var transaction = box.getAt(index);
    if (transaction != null) {
      transaction['name'] = name;
      transaction['amount'] = amount;
      transaction['type'] = type;
      await box.putAt(index, transaction);
    }
  }

  // Fungsi untuk menambahkan pengguna
  static Future<void> addUser(String username, String password) async {
    final box = getUsersBox();
    await box.add({'username': username, 'password': password});
  }

  // Fungsi untuk mendapatkan daftar pengguna
  static List<Map<String, dynamic>> getUsers() {
    final box = getUsersBox();
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  // Fungsi untuk menghapus pengguna
  static Future<void> deleteUser(int index) async {
    final box = getUsersBox();
    await box.deleteAt(index);
  }

  // Fungsi untuk memverifikasi login pengguna
  static bool verifyLogin(String username, String password) {
    final box = getUsersBox();
    final users = box.values
        .map((e) => Map<String, dynamic>.from(e))
        .where((user) =>
            user['username'] == username && user['password'] == password)
        .toList();
    return users.isNotEmpty; // Mengembalikan true jika ada kecocokan
  }
}
