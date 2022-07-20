import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_budget/bloc/account/account_bloc.dart';

import '../../models/account.dart';

class AccountSelector extends StatefulWidget {
  const AccountSelector({Key? key}) : super(key: key);

  @override
  State<AccountSelector> createState() => _AccountSelectorState();
}

class _AccountSelectorState extends State<AccountSelector> {
  Account? _selectedAccount;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Select Account'),
            ),
            body: BlocBuilder<AccountBloc, AccountState>(
              builder: (context, state) {
                if (state is AccountLoaded) {
                  return ListView(
                    children: state.accounts
                        .map((account) => Card(
                                child: InkWell(
                              onTap: (() {
                                final bloc = context.read<AccountBloc>();
                                bloc.add(SelectAccount(account: account));
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AccountSelector()));
                              }),
                              child: ListTile(
                                  leading: Icon(Icons.account_balance_wallet),
                                  trailing: IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        final bloc =
                                            context.read<AccountBloc>();

                                        final subAccount =
                                            Account(account.name + "-sub", 0);
                                        subAccount.parentAccount.target =
                                            account;
                                        bloc.add(
                                            AddAccount(account: subAccount));
                                      }),
                                  subtitle: RichText(
                                      text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: '${account.getTotalBalance()} €',
                                        style: TextStyle(
                                            color: Colors.greenAccent[700])),
                                    TextSpan(
                                        text: account.subAccounts.isNotEmpty
                                            ? ', ${account.subAccounts.length} sub account${account.subAccounts.length > 1 ? 's' : ''}'
                                            : '',
                                        style: TextStyle(color: Colors.grey)),
                                  ])),
                                  title: Text(account.name)),
                            )))
                        .toList(),
                  );
                } else if (state is AccountSelected) {
                  _selectedAccount = state.account;
                  return ListView(
                    children: state.account.subAccounts
                        .map((account) => Card(
                                child: InkWell(
                              onTap: (() {
                                final bloc = context.read<AccountBloc>();
                                bloc.add(SelectAccount(account: account));

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AccountSelector()));
                              }),
                              child: ListTile(
                                  leading: Icon(Icons.account_balance_wallet),
                                  trailing: IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        final bloc =
                                            context.read<AccountBloc>();

                                        final subAccount =
                                            Account(account.name + "-sub", 0);
                                        subAccount.parentAccount.target =
                                            account;
                                        bloc.add(
                                            AddAccount(account: subAccount));
                                      }),
                                  subtitle: RichText(
                                      text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: '${account.getTotalBalance()} €',
                                        style: TextStyle(
                                            color: Colors.greenAccent[700])),
                                    TextSpan(
                                        text: account.subAccounts.isNotEmpty
                                            ? ', ${account.subAccounts.length} sub account${account.subAccounts.length > 1 ? 's' : ''}'
                                            : '',
                                        style: TextStyle(color: Colors.grey)),
                                  ])),
                                  title: Text(account.name)),
                            )))
                        .toList(),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )),
        onWillPop: () async {
          print("pop");
          final bloc = context.read<AccountBloc>();

          var acc = _selectedAccount;

          if (acc != null) {
            if (acc.parentAccount.target != null) {
              bloc.add(
                  SelectAccount(account: acc.parentAccount.target as Account));
            } else {
              bloc.add(LoadAccount());
            }
          }

          return true;
        });
  }
}
