import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_budget/bloc/account/account_selection_bloc.dart';
import 'package:open_budget/models/transactions.dart';
import 'package:open_budget/widgets/shared/icon_picker/icon_picker.dart';
import 'package:open_budget/widgets/transaction/edit_transaction.dart';
import '../../bloc/transaction/transaction_list_bloc.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({Key? key}) : super(key: key);

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionListBloc, TransactionListState>(
      builder: (context, state) {
        List<ListTile> transactions = state.transactions.map(
          (transaction) {
            IconWithColor icon =
                iconMap[transaction.category.target?.icon ?? "placeholder"]!;

            return ListTile(
              leading: CircleAvatar(
                  backgroundColor: icon.backgroundColor,
                  child: Icon(icon.iconData, color: icon.iconColor)),
              title: Text(
                transaction.category.target?.name ?? "No Category",
              ),
              subtitle: Text(
                DateFormat.yMMMd().format(transaction.date),
              ),
              trailing: Text(
                NumberFormat.simpleCurrency(
                        name: transaction.account.target?.currency)
                    .format(transaction.amount),
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: transaction.amount > 0
                        ? Colors.greenAccent[700]
                        : Colors.redAccent[400]),
              ),
            );
          },
        ).toList();

        if (state is AccountTransactions) {
          transactions.insert(
            0,
            ListTile(
              title: const Text("Add a new transaction",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onTap: () {
                context
                    .read<AccountSelectionBloc>()
                    .add(LoadAccountSelection());

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTransactionPage(
                      transaction: Transaction(0, DateTime.now()),
                    ),
                  ),
                );
              },
            ),
          );
        }

        return ListView(
          shrinkWrap: true,
          children: transactions,
        );
      },
    );
  }
}
