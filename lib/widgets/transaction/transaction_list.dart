import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/bloc/transaction_bloc.dart';
import '../../models/transactions.dart';
import '../../objectbox.dart';

class TransactionList extends StatefulWidget {
  TransactionList({Key? key}) : super(key: key);

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionInitial) {
          return Center(
            child: const CircularProgressIndicator(),
          );
        } else if (state is TransactionLoaded) {
          return ListView(
              children: state.transactions.map((transaction) {
            return ListTile(
              title: Text("Transaction ${transaction.id}"),
              subtitle: Text(transaction.amount.toString()),
              trailing: Text(transaction.date.toString()),
            );
          }).toList());
        } else {
          return Center(
            child: const Text('Unknown state'),
          );
        }
      },
    );
  }
}
