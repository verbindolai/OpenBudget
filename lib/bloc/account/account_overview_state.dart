part of 'account_overview_bloc.dart';

abstract class AccountOverviewState extends Equatable {
  const AccountOverviewState();

  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountOverviewState {}

class AccountLoaded extends AccountOverviewState {
  final List<Account> accounts;
  final Map<String, double> balance;

  const AccountLoaded({required this.accounts, required this.balance});

  @override
  List<Object?> get props => [accounts, balance];
}

class AccountSelected extends AccountOverviewState {
  final Account? account;
  final double balance;

  const AccountSelected({required this.account, required this.balance});

  @override
  List<Object?> get props => [account, balance];
}
