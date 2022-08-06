import 'package:open_budget/objectbox.dart';
import 'package:stack/stack.dart';

import '../models/account.dart';

class AccountRepository {
  final ObjectBox objectBox;

  AccountRepository(this.objectBox);

  getAccount(int id) {
    return objectBox.store.box<Account>().get(id);
  }

  List<Account> getAccounts() {
    return objectBox.store.box<Account>().getAll();
  }

  save(Account account) {
    return objectBox.store.box<Account>().put(account);
  }

  delete(int accountId) {
    objectBox.store.box<Account>().remove(accountId);
  }

  int deleteAccountTree(Account account) {
    List<Account> accounts = accountTreeToListIterative(account);
    return objectBox.store
        .box<Account>()
        .removeMany(accounts.map((a) => a.id).toList());
  }

  getAllMainAccounts() {
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

  accountTreeToListIterative(Account account) {
    final Stack<Account> stack = Stack<Account>();
    stack.push(account);
    final List<Account> list = [];
    while (stack.isNotEmpty) {
      final Account current = stack.pop();
      list.add(current);
      for (final subAccount in current.subAccounts) {
        stack.push(subAccount);
      }
    }
    return list;
  }
}
