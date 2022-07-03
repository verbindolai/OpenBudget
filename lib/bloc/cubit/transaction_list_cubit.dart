import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:open_budget/models/transactions.dart';

class TransactionListCubit extends Cubit<List<Transaction>> {
  TransactionListCubit() : super([]);

  void addTransaction(Transaction transaction) {
    emit(state..add(transaction));
  }
}
