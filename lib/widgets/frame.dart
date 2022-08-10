import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_budget/bloc/account/account_overview_bloc.dart';
import 'package:open_budget/bloc/account/account_selection_bloc.dart';
import 'package:open_budget/bloc/navigation/navigation_bloc.dart';
import 'package:open_budget/widgets/account/account_overview.dart';
import 'package:open_budget/widgets/transaction/edit_transaction.dart';
import 'package:open_budget/widgets/transaction/transaction_list.dart';

import '../bloc/transaction/transaction_list_bloc.dart';
import '../models/transactions.dart';

class Frame extends StatelessWidget {
  const Frame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        if (state is NavigationSelected) {
          return Scaffold(
            appBar: AppBar(
              title: Text(state.title),
            ),
            body: Builder(builder: ((context) {
              switch (state.page) {
                case NavigationPage.home:
                  return const TransactionList();
                case NavigationPage.accounts:
                  return const AccountOverview();
                case NavigationPage.reports:
                  return Container();
                case NavigationPage.settings:
                  return Container();
                default:
                  return Container();
              }
            })),
            floatingActionButton: FloatingActionButton(
              //Floating action button on Scaffold
              onPressed: () {
                context
                    .read<AccountSelectionBloc>()
                    .add(LoadAccountSelection());

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditTransactionPage(
                              transaction: Transaction(0, DateTime.now()),
                            )));
                //code to execute on button press
              },
              child: const Icon(Icons.add_rounded), //icon inside button
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: const BottomNavBar(),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      //bottom navigation bar on scaffold
      shape: const CircularNotchedRectangle(), //shape of notch
      notchMargin: 5, //notche margin between floating button and bottom appbar
      child: Row(
        //children inside bottom appbar
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.house,
              color: Colors.white,
            ),
            onPressed: () {
              BlocProvider.of<NavigationBloc>(context).add(
                  const SelectNavigation("Home", page: NavigationPage.home));
              BlocProvider.of<TransactionListBloc>(context)
                  .add(DisplayRecentTransactions());
            },
          ),
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.wallet,
              color: Colors.white,
            ),
            onPressed: () {
              BlocProvider.of<NavigationBloc>(context).add(
                  const SelectNavigation("Accounts",
                      page: NavigationPage.accounts));
            },
          ),
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.chartSimple,
              color: Colors.white,
            ),
            onPressed: () {
              BlocProvider.of<NavigationBloc>(context).add(
                  const SelectNavigation("Reports",
                      page: NavigationPage.reports));
            },
          ),
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.gear,
              color: Colors.white,
            ),
            onPressed: () {
              BlocProvider.of<NavigationBloc>(context).add(
                  const SelectNavigation("Settings",
                      page: NavigationPage.settings));
            },
          ),
        ],
      ),
    );
  }
}
