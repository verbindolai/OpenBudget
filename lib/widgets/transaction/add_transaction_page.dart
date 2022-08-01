import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_budget/bloc/account/account_overview_bloc.dart';
import 'package:open_budget/bloc/account/account_selection_bloc.dart';
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
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildDropDown(context),
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
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
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

  Widget buildDropDown(BuildContext context) {
    return BlocBuilder<AccountSelectionBloc, AccountSelectionState>(
      builder: (context, state) {
        if (state is AccountSelectionLoaded) {
          return Container(
              constraints: const BoxConstraints(maxWidth: 200),
              child: DropdownButton<int>(
                isExpanded: true,
                value: state.selectedAccount?.id,
                onChanged: (int? value) {
                  context
                      .read<AccountSelectionBloc>()
                      .add(ChooseAccount(accountId: value));
                },
                items: state.accounts.map((Account account) {
                  return DropdownMenuItem<int>(
                    value: account.id,
                    child: Text(account.getTreeName()),
                  );
                }).toList(),
              ));
        } else {
          return const Text('Loading...');
        }
      },
    );
  }
}
