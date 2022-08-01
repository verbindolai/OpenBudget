part of 'account_selection_bloc.dart';

abstract class AccountSelectionState extends Equatable {
  const AccountSelectionState();

  @override
  List<Object?> get props => [];
}

class AccountSelectionInitial extends AccountSelectionState {}

class AccountSelectionLoaded extends AccountSelectionState {
  final List<Account> accounts;
  final Account? selectedAccount;

  const AccountSelectionLoaded(
      {required this.accounts, required this.selectedAccount});

  @override
  List<Object?> get props => [accounts, selectedAccount];
}
