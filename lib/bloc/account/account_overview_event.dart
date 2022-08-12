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

class SelectAccount extends AccountOverviewEvent {
  final Account? account;

  const SelectAccount({required this.account});

  @override
  List<Object?> get props => [account];
}

class DeleteAccount extends AccountOverviewEvent {
  final Account account;

  const DeleteAccount({required this.account});

  @override
  List<Object> get props => [account];
}
