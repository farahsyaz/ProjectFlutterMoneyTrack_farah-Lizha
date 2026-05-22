import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 1)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String? type; // 'income' | 'expense'

  @HiveField(1)
  double? amount;

  @HiveField(2)
  String? category;

  @HiveField(3)
  String? description;

  @HiveField(4)
  String? date;

  TransactionModel({
    this.type,
    this.amount,
    this.category,
    this.description,
    this.date,
  });
}
