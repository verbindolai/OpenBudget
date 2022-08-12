import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_budget/widgets/account/account_overview.dart';
import 'package:open_budget/widgets/category/edit_category.dart';
import 'package:open_budget/widgets/icon_picker/icon_picker.dart';
import 'package:open_budget/widgets/transaction/transaction_list.dart';

import '../../bloc/account/account_overview_bloc.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountOverviewBloc, AccountOverviewState>(
      builder: (context, state) {
        if (state is AccountLoaded) {
          List<Widget> totals = [];

          state.balance.forEach((key, value) {
            totals.add(ListTile(
                title: Text("Total $key"),
                trailing: Text(
                  NumberFormat.simpleCurrency(name: key).format(value),
                  style: TextStyle(color: Colors.greenAccent[700]),
                )));
          });

          return Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: const Color(0xFF003566),
                      child: Column(
                        children: totals,
                      ),
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    height: 300,
                    child: Card(
                      color: const Color(0xFF003566),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: const TransactionList(),
                    ),
                  ),
                  EditCategory()
                ],
              ),
            ),
          );
        }

        return Card(
          child: Container(),
        );
      },
    );
  }
}
