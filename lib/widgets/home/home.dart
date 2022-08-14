import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
                leading: Image.asset(
                  'assets/ic_launcher_foreground.png',
                  width: 58,
                  height: 58,
                  fit: BoxFit.cover,
                ),
                title: Text("Total $key",
                    style: TextStyle(fontWeight: FontWeight.w400)),
                trailing: Text(
                  NumberFormat.simpleCurrency(name: key).format(value),
                  style: TextStyle(
                      color: Colors.greenAccent[700],
                      fontWeight: FontWeight.w500),
                )));

            //if not last item, add divider
            if (state.balance.keys.toList().last != key) {
              totals.add(const Divider());
            }
          });

          return Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 24),
                    child: Center(
                        child: Image.asset(
                      'assets/ic_launcher.png',
                      width: 180,
                      height: 180,
                      fit: BoxFit.cover,
                    )),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text(
                            "Total",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),
                          Spacer()
                        ],
                      ),
                      const SizedBox(height: 4),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        color: const Color(0xFF003566),
                        child: Column(
                          children: totals,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text(
                            "Recent transactions",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),
                          Spacer(),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Card(
                        color: const Color(0xFF003566),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: const TransactionList(),
                      ),
                    ],
                  ),
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
