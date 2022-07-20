import 'package:equatable/equatable.dart';
import 'package:objectbox/objectbox.dart';

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

  final parentAccount = ToOne<Account>();

  @Backlink('parentAccount')
  final subAccounts = ToMany<Account>();

  Account(this.name, [this.balance = 0.0]);

  get createdAt => _createdAt;

  getTreeName() {
    if (parentAccount.target != null) {
      return parentAccount.target?.getTreeName() + ':' + name;
    } else {
      return name;
    }
  }

  getTotalBalance() {
    double total = balance;
    for (var subAccount in subAccounts) {
      total += subAccount.getTotalBalance();
    }
    return total;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        balance,
        placeholder,
        excluded,
        icon,
        subAccounts,
        parentAccount
      ];
}
