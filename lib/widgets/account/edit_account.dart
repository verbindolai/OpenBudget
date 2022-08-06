import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../bloc/account/account_overview_bloc.dart';
import '../../input_calculator/input_calculator.dart';
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
  final Account account;

  const EditAccount({Key? key, this.parentAccount, required this.account})
      : super(key: key);

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  final formKey = GlobalKey<FormState>();

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
        initialValue: widget.account.name,
        maxLength: 32,
        onSaved: (value) => {
          if (value != null) {widget.account.name = value}
        },
      );

  Widget buildAccountCurrency(context) => ListTile(
      title: const Text("Account currency"),
      onTap: () {
        showCurrencyPicker(
            context: context,
            onSelect: (Currency currency) {
              setState(() {
                widget.account.currency = currency.code;
              });
            });
      },
      trailing: OutlinedButton(
          child: Text(widget.account.currency),
          onPressed: () {
            showCurrencyPicker(
                context: context,
                onSelect: (Currency currency) {
                  setState(() {
                    widget.account.currency = currency.code;
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
              pickerColor: Color(widget.account.color),
              availableColors: colors,
              layoutBuilder: pickerLayoutBuilder,
              itemBuilder: pickerItemBuilder,
              onColorChanged: (color) {
                setState(() {
                  widget.account.color = color.value;
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
                pickerColor: Color(widget.account.color),
                availableColors: colors,
                layoutBuilder: pickerLayoutBuilder,
                itemBuilder: pickerItemBuilder,
                onColorChanged: (color) {
                  setState(() {
                    widget.account.color = color.value;
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
            backgroundColor:
                MaterialStateProperty.all<Color>(Color(widget.account.color))),
        child: const Text(""),
      ));

  Widget buildAccountBalance() => CalculatorTextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter an initial balance';
          }
          return null;
        },
        inputDecoration: const InputDecoration(
          labelText: 'Account Balance',
          border: OutlineInputBorder(),
        ),
        theme: CalculatorThemes.flat,
        initialValue: widget.account.balance,
        onSubmitted: (value) {
          if (value != null) {
            if (widget.account.id != 0) {
              final difference = value - widget.account.balance;
              print(difference);
            }
            widget.account.balance = value;
          }
        },
      );

  //Checkbox
  Widget buildIsPlaceholderAccount() => CheckboxListTile(
        title: const Text('Is Placeholder Account'),
        value: widget.account.placeholder,
        onChanged: (value) {
          if (value != null) {
            setState(() {
              widget.account.placeholder = value;
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
              if (widget.parentAccount != null) {
                widget.account.parentAccount.target = widget.parentAccount;
              }
              bloc.add(SaveAccount(account: widget.account));
              Navigator.pop(context);
            }
          },
          child: const Text("Save")));
}
