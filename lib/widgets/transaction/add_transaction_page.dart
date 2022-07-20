import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_budget/bloc/account/account_bloc.dart';
import 'package:open_budget/models/account.dart';
import '../../bloc/transaction/transaction_bloc.dart';
import '../../models/category.dart';
import '../../models/transactions.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({Key? key}) : super(key: key);

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                final transaction = Transaction(100, DateTime.now(), 'Test');
                transaction.category.target = Category("Test", "Test");
                context
                    .read<TransactionBloc>()
                    .add(AddTransaction(transaction));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
