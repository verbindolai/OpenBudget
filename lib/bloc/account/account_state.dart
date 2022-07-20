part of 'account_bloc.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {}

class AccountLoaded extends AccountState {
  final List<Account> accounts;

  const AccountLoaded({required this.accounts});

  @override
  List<Object?> get props => [accounts];
}

class AccountSelected extends AccountState {
  final Account account;

  const AccountSelected({required this.account});

  @override
  List<Object> get props => [account];
}
