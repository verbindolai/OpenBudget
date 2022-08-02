import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../bloc/account/account_overview_bloc.dart';
import '../../models/account.dart';

const List<Color> colors = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
  Colors.black,
];

class EditAccount extends StatefulWidget {
  final Account? parentAccount;

  const EditAccount({Key? key, this.parentAccount}) : super(key: key);

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  final formKey = GlobalKey<FormState>();

  String _name = '';
  double _initialBalance = 0.0;
  bool _isPlaceholderAccount = false;
  String _currency = "EUR";
  int _color = 0xFF000000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: Colors.green,
      ),
      body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              buildAccountName(),
              buildAccountBalance(),
              buildAccountCurrency(context),
              buildAccountColor(),
              buildIsPlaceholderAccount(),
              buildSubmit()
            ],
          )),
    );
  }

  Widget pickerLayoutBuilder(
      BuildContext context, List<Color> colors, PickerItem child) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return SizedBox(
      width: 300,
      height: orientation == Orientation.portrait ? 360 : 240,
      child: GridView.count(
        crossAxisCount: orientation == Orientation.portrait ? 5 : 5,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        children: [for (Color color in colors) child(color)],
      ),
    );
  }

  Widget pickerItemBuilder(
      Color color, bool isCurrentColor, void Function() changeColor) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: color,
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.8),
              offset: const Offset(1, 2),
              blurRadius: 3)
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: changeColor,
          borderRadius: BorderRadius.circular(30),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: isCurrentColor ? 1 : 0,
            child: Icon(
              Icons.done,
              size: 24,
              color: useWhiteForeground(color) ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
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

  Widget buildAccountCurrency(context) => ListTile(
      title: const Text("Account currency"),
      onTap: () {
        showCurrencyPicker(
            context: context,
            onSelect: (Currency currency) {
              setState(() {
                _currency = currency.code;
              });
            });
      },
      trailing: OutlinedButton(
          child: Text(_currency),
          onPressed: () {
            showCurrencyPicker(
                context: context,
                onSelect: (Currency currency) {
                  setState(() {
                    _currency = currency.code;
                  });
                });
          }));

  Widget buildAccountColor() => ListTile(
      title: const Text("Account color"),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Select a color'),
            content: BlockPicker(
              pickerColor: Color(_color),
              availableColors: colors,
              layoutBuilder: pickerLayoutBuilder,
              itemBuilder: pickerItemBuilder,
              onColorChanged: (color) {
                setState(() {
                  _color = color.value;
                });
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
      trailing: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Select a color'),
              content: BlockPicker(
                pickerColor: Color(_color),
                availableColors: colors,
                layoutBuilder: pickerLayoutBuilder,
                itemBuilder: pickerItemBuilder,
                onColorChanged: (color) {
                  setState(() {
                    _color = color.value;
                  });
                },
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color(_color))),
        child: const Text(""),
      ));

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
              final bloc = context.read<AccountOverviewBloc>();
              final subAccount =
                  Account(_name, _initialBalance, _isPlaceholderAccount);
              subAccount.color = _color;
              subAccount.currency = _currency;
              subAccount.parentAccount.target = widget.parentAccount;
              bloc.add(SaveAccount(account: subAccount));
              Navigator.pop(context);
            }
          },
          child: const Text("Save")));
}
