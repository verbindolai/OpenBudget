import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/account.dart';
import 'package:open_budget/objectbox.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(AccountInitial()) {
    on<LoadAccount>((event, emit) {
      if (state is AccountLoaded) {
        emit(AccountLoaded(
            accounts: objectBox.store.box<BankAccount>().getAll(),
            selectedAccount: (state as AccountLoaded).selectedAccount));
      }
    });
    on<AddAccount>((event, emit) {
      if (state is AccountLoaded) {
        objectBox.store.box<BankAccount>().put(event.account);
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
