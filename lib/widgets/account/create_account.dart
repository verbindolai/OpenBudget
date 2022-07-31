import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/account/account_bloc.dart';
import '../../models/account.dart';

class CreateAccount extends StatefulWidget {
  final Account? parentAccount;

  const CreateAccount({Key? key, this.parentAccount}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final formKey = GlobalKey<FormState>();

  String _name = '';
  double _initialBalance = 0.0;
  bool _isPlaceholderAccount = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.green,
      ),
      body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              buildAccountName(),
              buildAccountBalance(),
              buildIsPlaceholderAccount(),
              buildSubmit()
            ],
          )),
    );
  }

  Widget buildAccountName() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Account Name',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter an account name';
          }
          return null;
        },
        maxLength: 32,
        onSaved: (value) => {
          if (value != null) {_name = value}
        },
      );

  Widget buildAccountBalance() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Account Balance',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter an initial balance';
          }
          return null;
        },
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLength: 32,
        onSaved: (value) => {
          if (value != null) {_initialBalance = double.parse(value)}
        },
      );

  //Checkbox
  Widget buildIsPlaceholderAccount() => CheckboxListTile(
        title: const Text('Is Placeholder Account'),
        value: _isPlaceholderAccount,
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _isPlaceholderAccount = value;
            });
          }
        },
      );

  Widget buildSubmit() => Builder(
      builder: (context) => ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
          ),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              final bloc = context.read<AccountBloc>();
              final subAccount =
                  Account(_name, _initialBalance, _isPlaceholderAccount);
              subAccount.parentAccount.target = widget.parentAccount;
              bloc.add(AddAccount(account: subAccount));
              Navigator.pop(context);
            }
          },
          child: const Text("Create")));
}
