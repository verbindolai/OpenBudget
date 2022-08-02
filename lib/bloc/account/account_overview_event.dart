part of 'account_overview_bloc.dart';

abstract class AccountOverviewEvent extends Equatable {
  const AccountOverviewEvent();

  @override
  List<Object?> get props => [];
}

class LoadAccount extends AccountOverviewEvent {}

class SaveAccount extends AccountOverviewEvent {
  final Account account;

  const SaveAccount({required this.account});

  @override
  List<Object> get props => [account];
}

class AddSubAccount extends AccountOverviewEvent {
  final int accountId;
  final Account subAccount;

  const AddSubAccount(this.accountId, this.subAccount);

  @override
  List<Object> get props => [subAccount, accountId];
}

class SelectAccount extends AccountOverviewEvent {
  final Account? account;

  const SelectAccount({required this.account});

  @override
  List<Object?> get props => [account];
}

class UpdateAccount extends AccountOverviewEvent {
  final Account account;

  const UpdateAccount({required this.account});

  @override
  List<Object> get props => [account];
}
