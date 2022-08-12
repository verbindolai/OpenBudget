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

  //Returns a callback function
  popAccountSelection(BuildContext context, Account? account) {
    return () async {
      final bloc = context.read<AccountOverviewBloc>();
      var acc = _selectedAccount;
      if (acc != null) {
        bloc.add(SelectAccount(account: acc.parentAccount.target));
      }
      return true;
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: popAccountSelection(context, _selectedAccount),
        child: Scaffold(
          body: BlocBuilder<AccountOverviewBloc, AccountOverviewState>(
            builder: (context, state) {
              if (state is AccountLoaded) {
                _selectedAccount = null;
                return buildAllAccountsView(state.accounts);
              } else if (state is AccountSelected) {
                _selectedAccount = state.account;
                context
                    .read<TransactionListBloc>()
                    .add(DisplayAccountTransactions(_selectedAccount!.id));
                return buildSelectedAccountView(state.balance);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }

  Widget buildAllAccountsView(List<Account> accounts) {
    return Scaffold(
        body: AccountList(accounts: accounts),
        floatingActionButton: AddAccountButton(account: _selectedAccount));
  }

  Widget buildSelectedAccountView(double balance) {
    return Scaffold(
        appBar: AppBar(
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: "${_selectedAccount!.name}, ",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                TextSpan(
                    text: NumberFormat.simpleCurrency(
                            name: _selectedAccount!.currency)
                        .format(context
                            .read<AccountRepository>()
                            .getTotalBalance(_selectedAccount!)),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent[700])),
              ],
            ),
          ),
        ),
        body: AccountTabs(account: _selectedAccount!),
        floatingActionButton: AddAccountButton(account: _selectedAccount));
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
                color: Color(0xFF000814),
                child: TabBar(
                  indicatorColor: Color(0xFFFFC300),
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
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                        color: const Color(0xFF003566),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: const TransactionList()),
                  ),
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
        padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 80.0),
        children: accounts
            .map((account) => Column(children: [
                  const SizedBox(height: 5.0),
                  Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: InkWell(
                        onTap: (() {
                          final bloc = context.read<AccountOverviewBloc>();
                          bloc.add(SelectAccount(account: account));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AccountOverview()));
                        }),
                        child: AccountTile(
                          account: account,
                        ),
                      ))
                ]))
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
        height: 100,
        child: Row(children: [
          buildAccountColorBox(),
          Expanded(
              child: Container(
                  decoration: const BoxDecoration(
                      color: Color(0xFF003566),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0))),
                  padding: const EdgeInsets.all(10),
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(Icons.account_balance_wallet),
                        buildAccountInformation(context),
                        buildButtonContainer(context)
                      ])))
        ]));
  }

  Widget buildAccountColorBox() {
    return Container(
      width: 12,
      decoration: BoxDecoration(
          color: Color(account.color),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(4), topLeft: Radius.circular(4))),
    );
  }

  Widget buildAccountInformation(BuildContext context) {
    return Expanded(
      child: Container(
          margin: const EdgeInsets.only(left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                account.name,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(
                  text: NumberFormat.simpleCurrency(name: account.currency)
                      .format(context
                          .read<AccountRepository>()
                          .getTotalBalance(account)),
                  style: TextStyle(color: Colors.greenAccent[700]),
                ),
                TextSpan(
                    text: account.subAccounts.isNotEmpty
                        ? ', ${account.subAccounts.length} sub account${account.subAccounts.length > 1 ? 's' : ''}'
                        : '',
                    style: const TextStyle(color: Colors.grey)),
              ])),
            ],
          )),
    );
  }

  Widget buildButtonContainer(BuildContext context) {
    Widget buildEditButton() {
      return Card(
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
                  builder: (context) => EditAccount(account: account)));
        },
      ));
    }

    Widget buildDeleteButton() {
      return Card(
        child: ListTile(
          tileColor: Colors.red[600],
          title: const Center(
            child: Icon(Icons.delete, color: Colors.white),
          ),
          onTap: () async {
            if (await confirm(
              context,
              title: const Text('Confirm'),
              content: const Text('Would you like to delete this Account?'),
              textOK: const Text('Yes'),
              textCancel: const Text('No'),
            )) {
              final bloc = context.read<AccountOverviewBloc>();
              bloc.add(DeleteAccount(account: account));
              Navigator.pop(context);
            }
          },
        ),
      );
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () {},
          child: Icon(account.favorite ? Icons.star : Icons.star_border,
              color: Colors.grey),
        ),
        GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  backgroundColor: const Color(0xFF000814),
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => Wrap(children: [
                        Column(
                          children: [buildEditButton(), buildDeleteButton()],
                        )
                      ]));
            },
            child: const Icon(Icons.more_vert, color: Colors.grey))
      ],
    );
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
