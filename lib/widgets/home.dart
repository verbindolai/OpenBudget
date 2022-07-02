import 'package:flutter/material.dart';

const String _title = 'Open Budget';

class Frame extends StatelessWidget {
  final Widget body;

  const Frame({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_title),
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => Test()))
        },
        tooltip: '',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
