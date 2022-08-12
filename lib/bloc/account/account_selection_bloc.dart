import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/account.dart';
import '../../repository/account_repository.dart';

part 'account_selection_event.dart';
part 'account_selection_state.dart';

class AccountSelectionBloc
    extends Bloc<AccountSelectionEvent, AccountSelectionState> {
  final AccountRepository _accountRepository;

  AccountSelectionBloc(this._accountRepository)
      : super(AccountSelectionInitial()) {
    on<LoadAccountSelection>((event, emit) {
      final accounts = _accountRepository.getAccounts();
      accounts.sort((a, b) {
        return _accountRepository
            .getTreeName(a)
            .compareTo(_accountRepository.getTreeName(b));
      });

      emit(AccountSelectionLoaded(
          accounts: accounts,
          selectedAccount: accounts.isNotEmpty ? accounts[0] : null));
    });
    on<ChooseAccount>((event, emit) {
      if (state is AccountSelectionLoaded) {
        final List<Account> accounts = _accountRepository.getAccounts();
        accounts.sort((a, b) {
          return _accountRepository
              .getTreeName(a)
              .compareTo(_accountRepository.getTreeName(b));
        });
        final Account account =
            accounts.firstWhere((element) => element.id == event.accountId);
        emit(AccountSelectionLoaded(
            accounts: accounts, selectedAccount: account));
      }
    });
  }
}
