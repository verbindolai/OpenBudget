part of 'account_overview_bloc.dart';

abstract class AccountOverviewState extends Equatable {
  const AccountOverviewState();

  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountOverviewState {}

class AccountLoaded extends AccountOverviewState {
  final List<Account> accounts;

  const AccountLoaded({required this.accounts});

  @override
  List<Object?> get props => [accounts];
}

class AccountSelected extends AccountOverviewState {
  final Account? account;

  const AccountSelected({required this.account});

  @override
  List<Object?> get props => [account];
}
