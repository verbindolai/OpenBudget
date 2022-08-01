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
    on<LoadAccountSelection>((event, emit) async {
      final accounts = await _accountRepository.getAccounts();
      accounts.sort((a, b) {
        return a.getTreeName().compareTo(b.getTreeName());
      });

      emit(AccountSelectionLoaded(
          accounts: accounts,
          selectedAccount: accounts.isNotEmpty ? accounts[0] : null));
    });
    on<ChooseAccount>((event, emit) async {
      if (state is AccountSelectionLoaded) {
        final List<Account> accounts = await _accountRepository.getAccounts();
        accounts.sort((a, b) {
          return a.getTreeName().compareTo(b.getTreeName());
        });
        final Account? account =
            accounts.firstWhere((element) => element.id == event.accountId);
        if (account != null) {
          emit(AccountSelectionLoaded(
              accounts: accounts, selectedAccount: account));
        }
      }
    });
  }
}
