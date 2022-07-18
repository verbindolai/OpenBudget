import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/account.dart';
import '../../repository/account_repository.dart';
part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository _accountRepository;

  AccountBloc(this._accountRepository) : super(AccountInitial()) {
    on<LoadAccount>((event, emit) async {
      if (state is AccountInitial) {
        emit(AccountLoaded(
            accounts: await _accountRepository.getAccounts(),
            selectedAccount: null));
      }
    });
    on<AddAccount>((event, emit) async {
      if (state is AccountLoaded) {
        _accountRepository.createAccount(event.account);
        emit(AccountLoaded(
            accounts: (state as AccountLoaded).accounts..add(event.account),
            selectedAccount: (state as AccountLoaded).selectedAccount));
      }
    });
    on<SelectAccount>((event, emit) {
      if (state is AccountLoaded) {
        emit(AccountLoaded(
            accounts: (state as AccountLoaded).accounts,
            selectedAccount: event.account));
      }
    });
  }
}
