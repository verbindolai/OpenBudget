import 'package:open_budget/models/transactions.dart';
import 'package:open_budget/objectbox.dart';
import 'package:open_budget/objectbox.g.dart';

class TransactionRepository {
  final ObjectBox objectBox;

  TransactionRepository(this.objectBox);

  getTransaction(int id) {
    return objectBox.store.box<Transaction>().get(id);
  }

  List<Transaction> getTransactions() {
    return objectBox.store.box<Transaction>().getAll();
  }

  List<Transaction> getLastTransactionsByDate({int count = 10}) {
    final qBuilder = objectBox.store.box<Transaction>().query()
      ..order(Transaction_.date, flags: Order.descending);
    final query = qBuilder.build()..limit = count;
    return query.find();
  }

  List<Transaction> getTransactionsForAccount(int accountId) {
    return objectBox.store
        .box<Transaction>()
        .getAll()
        .where((t) => t.account.target?.id == accountId)
        .toList();
  }

  save(Transaction transaction) {
    return objectBox.store.box<Transaction>().put(transaction);
  }

  deleteAll() {
    return objectBox.store.box<Transaction>().removeAll();
  }
}
