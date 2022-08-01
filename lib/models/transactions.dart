import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';
import 'account.dart';
import 'category.dart';

@Entity()
class Transaction extends Equatable {
  @Id()
  int id = 0;

  final double amount;
  final DateTime date;
  final String? description;
  final category = ToOne<Category>();

  final account = ToOne<Account>();

  Transaction(this.amount, this.date, [this.description]);

  @override
  String toString() {
    return 'Transaction{id: $id, amount: $amount, date: $date, description: $description, category: ${category.toString()}';
  }

  @override
  List<Object?> get props => [id, amount, date, description, category, account];
}
