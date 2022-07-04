import 'package:flutter/material.dart';
import 'package:open_budget/widgets/frame.dart';
import 'bloc/transaction/transaction_bloc.dart';
import 'objectbox.dart';
import 'objectbox.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocProvider(
      create: (context) => TransactionBloc()..add(LoadTransaction()),
      child: const MaterialApp(home: Frame()),
    );
  }
}
