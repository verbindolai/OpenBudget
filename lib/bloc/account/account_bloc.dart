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
      if (state is AccountInitial || state is AccountSelected) {
        emit(AccountLoaded(
            accounts: await _accountRepository.getAllMainAccounts()));
      }
    });
    on<AddAccount>((event, emit) async {
      _accountRepository.createAccount(event.account);

      if (state is AccountLoaded) {
        emit(AccountLoaded(
            accounts: await _accountRepository.getAllMainAccounts()));
      }
      if (state is AccountSelected) {
        final acc = await _accountRepository
            .getAccount((state as AccountSelected).account.id);
        if (acc != null) {
          emit(AccountSelected(account: acc));
        }
      }
    });
    on<AddSubAccount>((event, emit) async {
      if (state is AccountLoaded) {
        final List<Account> accounts = (state as AccountLoaded).accounts;
        await _accountRepository.createAccount(event.subAccount);

        accounts
            .firstWhere((element) => element.id == event.accountId)
            .subAccounts
            .add(event.subAccount);

        emit(AccountLoaded(accounts: [...accounts]));
      }
    });
    on<SelectAccount>((event, emit) {
      if (state is AccountLoaded || state is AccountSelected) {
        emit(AccountSelected(account: event.account));
      }
    });
    on<UpdateAccount>((event, emit) async {
      if (state is AccountLoaded) {
        _accountRepository.updateAccount(event.account);
        emit(AccountLoaded(accounts: (state as AccountLoaded).accounts));
      }
    });
  }
}
