import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_budget/bloc/account/account_bloc.dart';

class AccountSelector extends StatefulWidget {
  const AccountSelector({Key? key}) : super(key: key);

  @override
  State<AccountSelector> createState() => _AccountSelectorState();
}

class _AccountSelectorState extends State<AccountSelector> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Select Account'),
        ),
        body: BlocBuilder<AccountBloc, AccountState>(
          builder: (context, state) {
            if (state is AccountInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is AccountLoaded) {
              return ListView(
                children: state.accounts
                    .map((account) => Card(
                          child: ElevatedButton(
                              child: Text((account.getTreeName())),
                              onPressed: () {
                                // context
                                //     .read<AccountBloc>()
                                //     .add(SelectAccount(account: account));

                                Navigator.pop(context);
                              }),
                        ))
                    .toList(),
              );
            } else {
              return const Center(
                child: Text('Unknown state'),
              );
            }
          },
        ));
  }
}
