part of 'transaction_bloc.dart';

@immutable
abstract class TransactionEvent {}

class LoadTransaction extends TransactionEvent {}

class AddTransaction extends TransactionEvent {
  final Transaction transaction;

  AddTransaction(this.transaction);
}
