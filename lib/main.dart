import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/category.dart';
import 'models/transactions.dart';
import 'objectbox.dart';
import 'objectbox.g.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'widgets/transaction/transaction_list.dart';

late Admin admin;

Future<void> main() async {
  // This is required so ObjectBox can get the application directory
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBox.create();

  if (Admin.isAvailable()) {
    print("isAvailable");
    // Keep a reference until no longer needed or manually closed.
    admin = Admin(objectBox.store);
  }

  runApp(const App());
}

int test = 0;

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ObjectBox Demo'),
      ),
      body: Center(
        child: TransactionList(),
      ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        //bottom navigation bar on scaffold
        color: Colors.redAccent,
        shape: const CircularNotchedRectangle(), //shape of notch
        notchMargin:
            5, //notche margin between floating button and bottom appbar
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
              onPressed: () {},
            ),
            IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.chartSimple,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.print,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Home());
  }
}

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({Key? key}) : super(key: key);

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  String text = "";
  int number = 0;

  changeText() {
    setState(() {
      text = "Hello World";
    });
  }

  changeNumber() {
    setState(() {
      number = number + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$test $number'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                test++;
                number = number + 1;
                // changeText();
                final transaction = Transaction(100, DateTime.now(), 'Test');
                transaction.category.target = Category("Test", "Test");

                objectBox.store.box<Transaction>().put(transaction);

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
