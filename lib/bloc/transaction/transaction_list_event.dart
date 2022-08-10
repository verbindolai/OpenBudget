part of 'transaction_list_bloc.dart';

@immutable
abstract class TransactionListEvent extends Equatable {
  const TransactionListEvent();
  @override
  List<Object?> get props => [];
}

class LoadTransactionList extends TransactionListEvent {
  const LoadTransactionList();

  @override
  List<Object> get props => [];
}

class SaveTransaction extends TransactionListEvent {
  final Transaction transaction;

  const SaveTransaction(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class DisplayAccountTransactions extends TransactionListEvent {
  final int accountId;
  const DisplayAccountTransactions(this.accountId);

  @override
  List<Object?> get props => [accountId];
}

class DisplayRecentTransactions extends TransactionListEvent {
  @override
  List<Object> get props => [];
}
