import 'package:hive_flutter/hive_flutter.dart';
import 'package:lapor_keuangan/model/user_model.dart';

import 'package:lapor_keuangan/model/transaction_model.dart';

class HiveHelper {
  static const String _userBox = 'users';
  static const String _transactionBox = 'transactions';

  static Future<void> initHive() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TransactionModelAdapter());
    }

    // Open boxes
    await Hive.openBox<UserModel>(_userBox);
    await Hive.openBox<TransactionModel>(_transactionBox);
  }

  // ── USER ──────────────────────────────────────────
  static Future<void> saveUser(UserModel user) async {
    final box = Hive.box<UserModel>(_userBox);
    await box.add(user);
  }

  static UserModel? getUser(String email, String password) {
    final box = Hive.box<UserModel>(_userBox);
    try {
      return box.values.firstWhere(
        (u) => u.email == email && u.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  static bool userExists(String email) {
    final box = Hive.box<UserModel>(_userBox);
    return box.values.any((u) => u.email == email);
  }

  // ── TRANSACTIONS ──────────────────────────────────
  static Future<void> saveTransaction(TransactionModel t) async {
    final box = Hive.box<TransactionModel>(_transactionBox);
    await box.add(t);
  }

  static List<TransactionModel> getTransactions() {
    final box = Hive.box<TransactionModel>(_transactionBox);
    return box.values.toList().reversed.toList();
  }

  static Future<void> deleteTransaction(int index) async {
    final box = Hive.box<TransactionModel>(_transactionBox);
    await box.deleteAt(index);
  }
}
