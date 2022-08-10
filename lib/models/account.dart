import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:open_budget/models/transactions.dart';

@Entity()
class Account extends Equatable {
  @Id()
  int id = 0;

  String name;
  double balance;

  final DateTime _createdAt = DateTime.now();

  bool placeholder = false;
  bool excluded = false;
  String icon = "";
  int color = 0xFF000000;
  String currency = "EUR";
  bool favorite = false;

  final parentAccount = ToOne<Account>();

  @Backlink('parentAccount')
  final subAccounts = ToMany<Account>();

  @Backlink('account')
  final transactions = ToMany<Transaction>();

  Account([this.name = "", this.balance = 0.0, this.placeholder = false]);

  get createdAt => _createdAt;

  @override
  String toString() {
    return 'Account{id: $id, name: $name, balance: $balance, placeholder: $placeholder, excluded: $excluded, icon: $icon, color: $color, currency: $currency, favorite: $favorite, parentAccount: ${parentAccount.target?.name}, subAccounts: $subAccounts, transactions: $transactions}';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        balance,
        placeholder,
        excluded,
        icon,
        color,
        currency,
        subAccounts,
        parentAccount,
        favorite,
        createdAt,
      ];
}
