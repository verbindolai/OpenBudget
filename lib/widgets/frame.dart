import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_budget/bloc/navigation/navigation_bloc.dart';
import 'package:open_budget/widgets/account/select_account.dart';
import 'package:open_budget/widgets/transaction/add_transaction_page.dart';
import 'package:open_budget/widgets/transaction/transaction_list.dart';

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
                  return TransactionList();
                case NavigationPage.accounts:
                  return const AccountSelector();
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddTransactionPage()));
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
      color: Colors.blue,
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
