part of 'account_bloc.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {}

class AccountLoaded extends AccountState {
  final List<Account> accounts;
  final Account? selectedAccount;

  const AccountLoaded({required this.accounts, required this.selectedAccount});

  @override
  List<Object?> get props => [accounts, selectedAccount];
}
