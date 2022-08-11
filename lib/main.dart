import 'package:flutter/material.dart';
import 'package:open_budget/bloc/account/account_selection_bloc.dart';
import 'package:open_budget/bloc/navigation/navigation_bloc.dart';
import 'package:open_budget/repository/transaction_repository.dart';
import 'package:open_budget/widgets/frame.dart';
import 'bloc/account/account_overview_bloc.dart';
import 'bloc/transaction/transaction_list_bloc.dart';
import 'objectbox.dart';
import 'objectbox.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'repository/account_repository.dart';

late Admin admin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBox.create();

  if (Admin.isAvailable()) {
    admin = Admin(objectBox.store);
  }
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AccountRepository>(
            create: (context) => AccountRepository(objectBox)),
        RepositoryProvider<TransactionRepository>(
          create: (context) => TransactionRepository(objectBox),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                TransactionListBloc(context.read<TransactionRepository>())
                  ..add(const LoadTransactionList()),
          ),
          BlocProvider(
            create: (context) =>
                AccountOverviewBloc(context.read<AccountRepository>())
                  ..add(LoadAccount()),
          ),
          BlocProvider(
              create: (context) => NavigationBloc()
                ..add(
                    const SelectNavigation("Home", page: NavigationPage.home))),
          BlocProvider(
              create: (context) =>
                  AccountSelectionBloc(context.read<AccountRepository>())
                    ..add(LoadAccountSelection())),
        ],
        child: MaterialApp(
            home: const Frame(),
            title: "OpenBudget",
            theme: ThemeData.dark().copyWith(
                bottomAppBarTheme:
                    const BottomAppBarTheme(color: Color(0xFF000814)),
                scaffoldBackgroundColor: const Color(0xFF001d3d),
                floatingActionButtonTheme: const FloatingActionButtonThemeData(
                    backgroundColor: Color(0xFFffc300)),
                colorScheme: const ColorScheme.light()
                    .copyWith(primary: const Color(0xFF000814)))),
      ),
    );
  }
}
