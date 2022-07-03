import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';
import 'category.dart';

@Entity()
class Transaction {
  @Id()
  int id = 0;

  final double amount;
  final DateTime date;
  final String? description;
  final category = ToOne<Category>();

  Transaction(this.amount, this.date, [this.description]);

  @override
  String toString() {
    return 'Transaction{id: $id, amount: $amount, date: $date, description: $description, category: ${category.toString()}';
  }
}
