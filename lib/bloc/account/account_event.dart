part of 'account_bloc.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object?> get props => [];
}

class LoadAccount extends AccountEvent {}

class AddAccount extends AccountEvent {
  final Account account;

  const AddAccount({required this.account});

  @override
  List<Object> get props => [account];
}

class AddSubAccount extends AccountEvent {
  final int accountId;
  final Account subAccount;

  const AddSubAccount(this.accountId, this.subAccount);

  @override
  List<Object> get props => [subAccount, accountId];
}

class SelectAccount extends AccountEvent {
  final Account account;

  const SelectAccount({required this.account});

  @override
  List<Object> get props => [account];
}

class UpdateAccount extends AccountEvent {
  final Account account;

  const UpdateAccount({required this.account});

  @override
  List<Object> get props => [account];
}
