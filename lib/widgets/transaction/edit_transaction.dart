import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_budget/bloc/account/account_overview_bloc.dart';
import 'package:open_budget/bloc/account/account_selection_bloc.dart';
import 'package:open_budget/bloc/transaction/transaction_list_bloc.dart';
import 'package:open_budget/models/account.dart';
import 'package:open_budget/repository/account_repository.dart';
import '../../input_calculator/input_calculator.dart';
import '../../models/transactions.dart';

class EditTransactionPage extends StatefulWidget {
  final Transaction transaction;

  const EditTransactionPage({Key? key, required this.transaction})
      : super(key: key);

  @override
  State<EditTransactionPage> createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add'),
        backgroundColor: const Color(0xFF000814),
      ),
      body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              buildDropDown(context),
              buildTransactionAmount(),
              buildTransactionDescription(),
              buildSubmit()
            ],
          )),
    );
  }

  Widget buildTransactionDescription() => Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: TextFormField(
        decoration: const InputDecoration(
          labelText: 'Description',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          return null;
        },
        maxLength: 128,
        onSaved: (value) => {
          if (value != null) {widget.transaction.description = value}
        },
      ));
  Widget buildTransactionAmount() => Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: CalculatorTextFormField(
        initialValue: widget.transaction.amount,
        validator: (value) {
          if (value == "0.0") {
            return 'Please enter an amount';
          }
          return null;
        },
        inputDecoration: const InputDecoration(
          labelText: 'Transaction amount',
          border: OutlineInputBorder(),
        ),
        theme: CalculatorThemes.flat,
        onSubmitted: (value) {
          if (value != null) {
            widget.transaction.amount = value;
          }
        },
      ));

  Widget buildDropDown(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: BlocBuilder<AccountSelectionBloc, AccountSelectionState>(
          builder: (context, state) {
            if (state is AccountSelectionLoaded) {
              return Container(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: DropdownButtonFormField<int>(
                    validator: (value) {
                      if (value == null) {
                        return 'Please select an account';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Account',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: true,
                    value: widget.transaction.account.target?.id,
                    onChanged: (int? value) {
                      context
                          .read<AccountSelectionBloc>()
                          .add(ChooseAccount(accountId: value));
                    },
                    items: state.accounts.map((Account account) {
                      return DropdownMenuItem<int>(
                        value: account.id,
                        child: Text(context
                            .read<AccountRepository>()
                            .getTreeName(account)),
                      );
                    }).toList(),
                  ));
            } else {
              return const Text('Loading...');
            }
          },
        ));
  }

  Widget buildSubmit() => Builder(
      builder: (context) =>
          BlocBuilder<AccountSelectionBloc, AccountSelectionState>(
            builder: (context, state) {
              if (state is AccountSelectionLoaded) {
                return ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (state.selectedAccount != null) {
                          final transactionBloc =
                              context.read<TransactionListBloc>();
                          final accountBloc =
                              context.read<AccountOverviewBloc>();
                          final Account account = state.selectedAccount!;

                          widget.transaction.account.target = account;
                          widget.transaction.date = DateTime.now();
                          transactionBloc
                              .add(SaveTransaction(widget.transaction));

                          account.balance += widget.transaction.amount;

                          accountBloc.add(SaveAccount(account: account));
                        }
                      }

                      Navigator.pop(context);
                    },
                    child: const Text("Save"));
              } else {
                return const Text('Loading...');
              }
            },
          ));
}
