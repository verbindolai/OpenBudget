import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_budget/models/transactions.dart';
import '../../bloc/transaction/transaction_bloc.dart';

class TransactionList extends StatefulWidget {
  final List<Transaction> transactions;

  TransactionList({Key? key, required this.transactions}) : super(key: key);

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return ListView(
            children: widget.transactions.map((transaction) {
          return ListTile(
            title: Text("Transaction ${transaction.id}"),
            subtitle: Text(transaction.amount.toString()),
            trailing: Text(transaction.account.target!.name),
          );
        }).toList());
      },
    );
  }
}
