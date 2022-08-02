import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/account.dart';
import '../../repository/account_repository.dart';
part 'account_overview_event.dart';
part 'account_overview_state.dart';

class AccountOverviewBloc
    extends Bloc<AccountOverviewEvent, AccountOverviewState> {
  final AccountRepository _accountRepository;

  AccountOverviewBloc(this._accountRepository) : super(AccountInitial()) {
    on<LoadAccount>((event, emit) async {
      if (state is AccountInitial || state is AccountSelected) {
        emit(AccountLoaded(
            accounts: await _accountRepository.getAllMainAccounts()));
      }
    });
    on<SaveAccount>((event, emit) async {
      _accountRepository.save(event.account);
      if (state is AccountLoaded) {
        emit(AccountLoaded(
            accounts: await _accountRepository.getAllMainAccounts()));
      }
      if (state is AccountSelected) {
        final acc = await _accountRepository
            .getAccount((state as AccountSelected).account!.id);
        if (acc != null) {
          emit(AccountSelected(account: acc));
        }
      }
    });

    on<SelectAccount>((event, emit) async {
      if (state is AccountLoaded || state is AccountSelected) {
        if (event.account != null) {
          emit(AccountSelected(account: event.account));
        } else {
          emit(AccountLoaded(
              accounts: await _accountRepository.getAllMainAccounts()));
        }
      }
    });
    on<DeleteAccount>((event, emit) async {
      _accountRepository.delete(event.id);
      if (state is AccountLoaded) {
        emit(AccountLoaded(
            accounts: await _accountRepository.getAllMainAccounts()));
      }
      if (state is AccountSelected) {
        final acc = await _accountRepository
            .getAccount((state as AccountSelected).account!.id);
        if (acc != null) {
          emit(AccountSelected(account: acc));
        }
      }
    });
  }
}
