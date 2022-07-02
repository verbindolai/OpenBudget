import 'package:objectbox/objectbox.dart';
import 'category.dart';

@Entity()
class Transaction {
  @Id()
  int id = 0;

  double amount;
  DateTime date;
  String? description;
  final category = ToOne<Category>();

  Transaction(this.amount, this.date, [this.description]);

  @override
  String toString() {
    return 'Transaction{id: $id, amount: $amount, date: $date, description: $description, category: ${category.toString()}';
  }
}
