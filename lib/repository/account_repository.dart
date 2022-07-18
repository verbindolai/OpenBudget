import 'package:open_budget/objectbox.dart';

import '../models/account.dart';

class AccountRepository {
  final ObjectBox objectBox;

  AccountRepository(this.objectBox);

  Future<Account?> getAccount(int id) async {
    return objectBox.store.box<Account>().get(id);
  }

  Future<List<Account>> getAccounts() async {
    return objectBox.store.box<Account>().getAll();
  }

  Future<int> createAccount(Account account) async {
    return objectBox.store.box<Account>().put(account);
  }

  Future<void> updateAccount(Account account) async {
    objectBox.store.box<Account>().put(account);
  }

  Future<void> deleteAccount(Account account) async {
    objectBox.store.box<Account>().remove(account.id);
  }

  // QueryBuilder<Account> builder =
  //     objectBox.store.box<Account>().query();
  // builder.link(Account_.parentAccount,
  //     Account_.id.equals(account.id));
  // builder.build().find().forEach((subAccount) {
  //   print(subAccount.name);
  // });

}
