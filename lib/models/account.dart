import 'package:objectbox/objectbox.dart';

@Entity()
class Account {
  @Id()
  int id = 0;

  String name;
  double balance;

  final DateTime _createdAt = DateTime.now();

  bool placeholder = false;
  bool excluded = false;

  String? icon;

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
}
