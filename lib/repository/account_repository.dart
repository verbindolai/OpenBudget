import 'package:open_budget/objectbox.dart';
import 'package:open_budget/objectbox.g.dart';

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

  Future<int> save(Account account) async {
    return objectBox.store.box<Account>().put(account);
  }

  Future<void> deleteAccount(Account account) async {
    objectBox.store.box<Account>().remove(account.id);
  }

  Future<List<Account>> getAllMainAccounts() async {
    // QueryBuilder<Account> builder = objectBox.store.box<Account>().query();
    // builder.link(Account_.parentAccount, Account_.parentAccount.isNull());
    // return builder.build().find();
    return objectBox.store
        .box<Account>()
        .getAll()
        .where((element) => element.parentAccount.target == null)
        .toList();
  }

  // QueryBuilder<Account> builder =
  //     objectBox.store.box<Account>().query();
  // builder.link(Account_.parentAccount,
  //     Account_.id.equals(account.id));
  // builder.build().find().forEach((subAccount) {
  //   print(subAccount.name);
  // });

}
