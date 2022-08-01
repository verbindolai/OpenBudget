import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_budget/bloc/account/account_overview_bloc.dart';
import "package:intl/intl.dart";
import '../../models/account.dart';
import 'create_account.dart';

class AccountOverview extends StatefulWidget {
  const AccountOverview({Key? key}) : super(key: key);

  @override
  State<AccountOverview> createState() => _AccountOverviewState();
}

class _AccountOverviewState extends State<AccountOverview> {
  Account? _selectedAccount;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      body: BlocBuilder<AccountOverviewBloc, AccountOverviewState>(
        builder: (context, state) {
          if (state is AccountLoaded) {
            _selectedAccount = null;
            return Scaffold(
                body: AccountList(
                  accounts: state.accounts,
                ),
                floatingActionButton:
                    AddAccountButton(account: _selectedAccount));
          } else if (state is AccountSelected) {
            _selectedAccount = state.account;
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Accounts"),
                ),
                body: AccountList(
                  accounts: state.account!.subAccounts,
                ),
                floatingActionButton:
                    AddAccountButton(account: _selectedAccount));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    ), onWillPop: () async {
      final bloc = context.read<AccountOverviewBloc>();
      var acc = _selectedAccount;
      if (acc != null) {
        bloc.add(SelectAccount(account: acc.parentAccount.target));
      }
      return true;
    });
  }
}

class AccountList extends StatelessWidget {
  final List<Account> accounts;

  const AccountList({
    Key? key,
    required this.accounts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: accounts
            .map((account) => Card(
                    child: InkWell(
                  onTap: (() {
                    final bloc = context.read<AccountOverviewBloc>();
                    bloc.add(SelectAccount(account: account));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AccountOverview()));
                  }),
                  child: AccountTile(
                    account: account,
                  ),
                )))
            .toList());
  }
}

class AccountTile extends StatelessWidget {
  final Account account;

  const AccountTile({
    Key? key,
    required this.account,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        child: Row(children: [
          Container(
            height: double.infinity,
            width: 7,
            color: Color(account.color),
          ),
          Expanded(
              child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.account_balance_wallet),
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(account.name),
                                RichText(
                                    text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: NumberFormat.simpleCurrency(
                                              name: account.currency)
                                          .format(account.getTotalBalance()),
                                      style: TextStyle(
                                          color: Colors.greenAccent[700])),
                                  TextSpan(
                                      text: account.subAccounts.isNotEmpty
                                          ? ', ${account.subAccounts.length} sub account${account.subAccounts.length > 1 ? 's' : ''}'
                                          : '',
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                ])),
                              ],
                            )),
                      ),
                      Column(
                        children: [
                          Icon(Icons.star_border, color: Colors.grey),
                          Icon(Icons.more_vert, color: Colors.grey)
                        ],
                      ),
                    ],
                  )))
        ]));
    //   return ListTile(
    //       leading: const Icon(Icons.account_balance_wallet),
    //       trailing: IconButton(icon: const Icon(Icons.add), onPressed: () {}),
    //       subtitle: RichText(
    //           text: TextSpan(children: <TextSpan>[
    //         TextSpan(
    //             text: '${numberFormatter.format(account.getTotalBalance())} €',
    //             style: TextStyle(color: Colors.greenAccent[700])),
    //         TextSpan(
    //             text: account.subAccounts.isNotEmpty
    //                 ? ', ${account.subAccounts.length} sub account${account.subAccounts.length > 1 ? 's' : ''}'
    //                 : '',
    //             style: const TextStyle(color: Colors.grey)),
    //       ])),
    //       title: Text(account.name));
    // }
  }
}

class AddAccountButton extends StatelessWidget {
  final Account? account;

  const AddAccountButton({Key? key, required this.account}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      onPressed: (() {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateAccount(parentAccount: account)));
      }),
      child: const Icon(Icons.account_balance_wallet),
    );
  }
}
