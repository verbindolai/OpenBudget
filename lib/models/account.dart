import 'package:objectbox/objectbox.dart';

@Entity()
class BankAccount {
  @Id()
  int id = 0;

  final String name;
  double balance;

  final DateTime _createdAt = DateTime.now();

  bool placeholder = false;
  bool excluded = false;

  String? icon;

  final parentAccount = ToOne<BankAccount>();

  @Backlink('parentAccount')
  final subAccounts = ToMany<BankAccount>();

  BankAccount(this.name, [this.balance = 0.0]);

  get createdAt => _createdAt;
}
