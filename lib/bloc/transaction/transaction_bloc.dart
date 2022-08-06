import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:open_budget/objectbox.dart';

import '../../models/transactions.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial()) {
    on<LoadTransaction>((event, emit) {
      if (state is TransactionInitial) {
        emit(TransactionLoaded(objectBox.store.box<Transaction>().getAll()));
      }
    });
    on<AddTransaction>((event, emit) {
      if (state is TransactionLoaded) {
        objectBox.store.box<Transaction>().put(event.transaction);
        emit(TransactionLoaded(objectBox.store.box<Transaction>().getAll()));
      }
    });
  }
}
