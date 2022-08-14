import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final IconWithColor placeholder = IconWithColor(
  Icons.question_mark,
  Colors.white,
  Colors.grey,
);

Map<String, IconWithColor> iconMap = {
  "placeholder": placeholder,
  "account_balance_wallet": IconWithColor(
    Icons.account_balance_wallet,
    Colors.white,
    const Color(0xAA6342f5),
  ),
  "fa-ghost": IconWithColor(
    FontAwesomeIcons.ghost,
    Colors.white,
    const Color.fromARGB(170, 18, 214, 236),
  ),
  "fa-piggy-bank": IconWithColor(
    FontAwesomeIcons.piggyBank,
    Colors.white,
    const Color.fromARGB(170, 18, 214, 236),
  ),
  "fa-wallet": IconWithColor(
    FontAwesomeIcons.wallet,
    Colors.white,
    const Color.fromARGB(170, 18, 214, 236),
  ),
  "fa-shopping-cart": IconWithColor(
    FontAwesomeIcons.cartShopping,
    Colors.white,
    const Color.fromARGB(170, 18, 214, 236),
  ),
  "fa-shopping-basket": IconWithColor(
    FontAwesomeIcons.basketShopping,
    Colors.white,
    const Color.fromARGB(170, 18, 214, 236),
  ),
  "fa-heart": IconWithColor(
    FontAwesomeIcons.heart,
    const Color.fromARGB(255, 227, 49, 49),
    Colors.black,
  ),
  "fa-guitar": IconWithColor(
    FontAwesomeIcons.guitar,
    const Color.fromARGB(255, 116, 78, 1),
    Colors.white,
  ),
  "fa-music": IconWithColor(
    FontAwesomeIcons.music,
    const Color.fromARGB(255, 116, 78, 1),
    Colors.white,
  ),
  "fa-masks-theater": IconWithColor(
    FontAwesomeIcons.masksTheater,
    const Color.fromARGB(255, 0, 50, 119),
    Colors.white,
  ),
  "restaurant": IconWithColor(
    Icons.restaurant,
    const Color.fromARGB(255, 0, 50, 119),
    Colors.white,
  ),
  "hospital": IconWithColor(
    Icons.local_hospital_rounded,
    const Color.fromARGB(255, 221, 11, 11),
    Colors.white,
  ),
};

class IconWithColor {
  final IconData iconData;
  final Color iconColor;
  final Color backgroundColor;

  IconWithColor(this.iconData, this.iconColor, this.backgroundColor);
}

class _IconPickerDialog extends StatelessWidget {
  const _IconPickerDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 15,
              spacing: 15,
              children: <Widget>[
                for (var iconMapEntry in iconMap.entries)
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: iconMapEntry.value.backgroundColor,
                    child: IconButton(
                      iconSize: 35,
                      onPressed: () {
                        Navigator.pop(context, iconMapEntry);
                      },
                      icon: Icon(
                        iconMapEntry.value.iconData,
                        color: iconMapEntry.value.iconColor,
                      ),
                    ),
                  )
              ]),
        ),
      ),
    );
  }
}

class IconPicker extends StatefulWidget {
  final IconWithColor? initialIcon;
  final double? iconSize;
  final double? buttonSize;
  final Function(MapEntry<String, IconWithColor>) onChange;

  const IconPicker(
      {Key? key,
      this.iconSize,
      this.buttonSize,
      required this.onChange,
      this.initialIcon})
      : super(key: key);

  @override
  State<IconPicker> createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  IconWithColor icon = placeholder;

  @override
  void initState() {
    super.initState();
    if (widget.initialIcon != null) {
      icon = widget.initialIcon!;
    }
  }

  Future<void> _showIconPickerDialog() async {
    final MapEntry<String, IconWithColor>? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(title: const Text("Icon")),
                body: const _IconPickerDialog())));

    if (result != null) {
      setState(() {
        icon = result.value;
      });
      widget.onChange(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: widget.buttonSize,
      backgroundColor: icon.backgroundColor,
      child: IconButton(
        iconSize: widget.iconSize,
        onPressed: () {
          _showIconPickerDialog();
        },
        icon: Icon(
          icon.iconData,
          color: icon.iconColor,
        ),
      ),
    );
  }
}
