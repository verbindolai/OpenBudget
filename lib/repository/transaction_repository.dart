import 'package:open_budget/models/transactions.dart';
import 'package:open_budget/objectbox.dart';

class TransactionRepository {
  final ObjectBox objectBox;

  TransactionRepository(this.objectBox);

  getTransaction(int id) {
    return objectBox.store.box<Transaction>().get(id);
  }

  List<Transaction> getTransactions() {
    return objectBox.store.box<Transaction>().getAll();
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
