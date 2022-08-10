import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_budget/bloc/account/account_overview_bloc.dart';
import "package:intl/intl.dart";
import 'package:open_budget/bloc/transaction/transaction_list_bloc.dart';
import 'package:open_budget/repository/account_repository.dart';
import 'package:open_budget/widgets/transaction/transaction_list.dart';
import '../../models/account.dart';
import 'edit_account.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

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
                body: AccountList(accounts: state.accounts),
                floatingActionButton:
                    AddAccountButton(account: _selectedAccount));
          } else if (state is AccountSelected) {
            _selectedAccount = state.account;
            context
                .read<TransactionListBloc>()
                .add(DisplayAccountTransactions(state.account!.id));
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Accounts"),
                ),
                body: AccountTabs(account: state.account!),
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

class AccountTabs extends StatelessWidget {
  final Account account;

  const AccountTabs({
    Key? key,
    required this.account,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              constraints: const BoxConstraints(maxHeight: 150.0),
              child: const Material(
                color: Colors.blue,
                child: TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.account_balance_wallet)),
                    Tab(icon: Icon(Icons.attach_money)),
                    Tab(icon: Icon(Icons.pie_chart)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  AccountList(
                    accounts: account.subAccounts,
                  ),
                  const TransactionList(),
                  const Icon(Icons.directions_bike),
                ],
              ),
            ),
          ],
        ));
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
    return SizedBox(
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
                      const Icon(Icons.account_balance_wallet),
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
                                          .format(context
                                              .read<AccountRepository>()
                                              .getTotalBalance(account)),
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
                          GestureDetector(
                            onTap: () {},
                            child: Icon(
                                account.favorite
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.grey),
                          ),
                          GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) => Wrap(children: [
                                          Column(
                                            children: [
                                              Card(
                                                  child: ListTile(
                                                tileColor: Colors.grey[300],
                                                title: Center(
                                                    child: Icon(
                                                  Icons.edit,
                                                  color: Colors.grey[900],
                                                )),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditAccount(
                                                                  account:
                                                                      account)));
                                                },
                                              )),
                                              Card(
                                                child: ListTile(
                                                  tileColor: Colors.red[600],
                                                  title: const Center(
                                                    child: Icon(Icons.delete,
                                                        color: Colors.white),
                                                  ),
                                                  onTap: () async {
                                                    if (await confirm(
                                                      context,
                                                      title:
                                                          const Text('Confirm'),
                                                      content: const Text(
                                                          'Would you like to delete this Account?'),
                                                      textOK: const Text('Yes'),
                                                      textCancel:
                                                          const Text('No'),
                                                    )) {
                                                      final bloc = context.read<
                                                          AccountOverviewBloc>();
                                                      bloc.add(DeleteAccount(
                                                          account: account));
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                ),
                                              )
                                            ],
                                          )
                                        ]));
                              },
                              child: const Icon(Icons.more_vert,
                                  color: Colors.grey))
                        ],
                      ),
                    ],
                  )))
        ]));
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
                builder: (context) => EditAccount(
                      parentAccount: account,
                      account: Account(),
                    )));
      }),
      child: const Icon(Icons.account_balance_wallet),
    );
  }
}
