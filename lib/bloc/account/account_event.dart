part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class LoadAccount extends AccountEvent {}

class AddAccount extends AccountEvent {
  final BankAccount account;

  const AddAccount({required this.account});

  @override
  List<Object> get props => [account];
}

class SelectAccount extends AccountEvent {
  final BankAccount account;

  const SelectAccount({required this.account});

  @override
  List<Object> get props => [account];
}
