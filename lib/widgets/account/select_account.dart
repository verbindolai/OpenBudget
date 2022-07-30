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
                  return AccountList(
                    accounts: state.accounts,
                  );
                } else if (state is AccountSelected) {
                  _selectedAccount = state.account;
                  return AccountList(
                    accounts: state.account.subAccounts,
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )),
        onWillPop: () async {
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
                  final bloc = context.read<AccountBloc>();
                  bloc.add(SelectAccount(account: account));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AccountSelector()));
                }),
                child: AccountTile(
                  account: account,
                ),
              )))
          .toList(),
    );
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
    return ListTile(
        leading: Icon(Icons.account_balance_wallet),
        trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              final bloc = context.read<AccountBloc>();

              final subAccount = Account(account.name + "-sub", 0);
              subAccount.parentAccount.target = account;
              bloc.add(AddAccount(account: subAccount));
            }),
        subtitle: RichText(
            text: TextSpan(children: <TextSpan>[
          TextSpan(
              text: '${account.getTotalBalance()} €',
              style: TextStyle(color: Colors.greenAccent[700])),
          TextSpan(
              text: account.subAccounts.isNotEmpty
                  ? ', ${account.subAccounts.length} sub account${account.subAccounts.length > 1 ? 's' : ''}'
                  : '',
              style: TextStyle(color: Colors.grey)),
        ])),
        title: Text(account.name));
  }
}
