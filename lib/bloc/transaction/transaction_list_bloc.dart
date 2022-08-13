import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:open_budget/repository/transaction_repository.dart';

import '../../models/transactions.dart';

part 'transaction_list_event.dart';
part 'transaction_list_state.dart';

class TransactionListBloc
    extends Bloc<TransactionListEvent, TransactionListState> {
  final TransactionRepository _transactionRepository;

  TransactionListBloc(this._transactionRepository)
      : super(TransactionListInitial()) {
    on<LoadTransactionList>((event, emit) {
      if (state is TransactionListInitial) {
        emit(RecentTransactions(_transactionRepository.getTransactions()));
      }
    });
    on<SaveTransaction>((event, emit) {
      _transactionRepository.save(event.transaction);
      if (state is RecentTransactions) {
        emit(RecentTransactions(
            _transactionRepository.getLastTransactionsByDate(count: 5)));
      } else if (state is AccountTransactions) {
        int id = (state as AccountTransactions).accountId;
        emit(AccountTransactions(
            id, _transactionRepository.getTransactionsForAccount(id)));
      }
    });
    on<DisplayAccountTransactions>((event, emit) {
      emit(AccountTransactions(event.accountId,
          _transactionRepository.getTransactionsForAccount(event.accountId)));
    });
    on<DisplayRecentTransactions>((event, emit) {
      emit(RecentTransactions(
          _transactionRepository.getLastTransactionsByDate(count: 5)));
    });
  }
}
