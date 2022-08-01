part of 'account_selection_bloc.dart';

abstract class AccountSelectionEvent extends Equatable {
  const AccountSelectionEvent();

  @override
  List<Object?> get props => [];
}

class LoadAccountSelection extends AccountSelectionEvent {}

class ChooseAccount extends AccountSelectionEvent {
  final int? accountId;

  const ChooseAccount({required this.accountId});

  @override
  List<Object?> get props => [accountId];
}
