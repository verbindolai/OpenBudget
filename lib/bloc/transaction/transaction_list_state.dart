part of 'transaction_list_bloc.dart';

@immutable
abstract class TransactionListState extends Equatable {
  final List<Transaction> transactions;

  const TransactionListState([this.transactions = const []]);

  @override
  List<Object> get props => [transactions];
}

class TransactionListInitial extends TransactionListState {}

class RecentTransactions extends TransactionListState {
  const RecentTransactions(super.transactions);

  @override
  List<Object> get props => [transactions];
}

class AccountTransactions extends TransactionListState {
  final int accountId;
  const AccountTransactions(this.accountId, super.transactions);

  @override
  List<Object> get props => [transactions, accountId];
}
