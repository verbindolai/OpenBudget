import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:open_budget/objectbox.dart';
import 'package:open_budget/repository/transaction_repository.dart';

import '../../models/transactions.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _transactionRepository;

  TransactionBloc(this._transactionRepository) : super(TransactionInitial()) {
    on<LoadTransaction>((event, emit) {
      if (state is TransactionInitial) {
        emit(TransactionLoaded(_transactionRepository.getTransactions()));
      }
    });
    on<SaveTransaction>((event, emit) {
      if (state is TransactionLoaded) {
        _transactionRepository.save(event.transaction);
        emit(TransactionLoaded(_transactionRepository.getTransactions()));
      }
    });
  }
}
