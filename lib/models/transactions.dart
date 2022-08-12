import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';
import 'account.dart';
import 'category.dart';

@Entity()
class Transaction extends Equatable {
  @Id()
  int id = 0;

  double amount;
  DateTime date;
  String? description;
  final category = ToOne<Category>();

  final account = ToOne<Account>();

  Transaction(this.amount, this.date, [this.description]);

  @override
  String toString() {
    return 'Transaction{id: $id, amount: $amount, date: $date, description: $description, category: ${category.toString()}, account: ${account.target?.name}}';
  }

  @override
  List<Object?> get props => [id, amount, date, description, category, account];
}
