import 'package:objectbox/objectbox.dart';

@Entity()
class BankAccount {
  @Id()
  int id = 0;

  String name;
  double balance;

  final parentAccount = ToOne<BankAccount>();

  @Backlink('parentAccount')
  final subAccounts = ToMany<BankAccount>();

  BankAccount(this.name, [this.balance = 0.0]);
}
