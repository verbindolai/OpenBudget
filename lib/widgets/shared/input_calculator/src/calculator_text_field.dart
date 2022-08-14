import 'package:flutter/material.dart';

import 'base_text_field.dart';
import 'themes.dart';

class CalculatorTextField extends StatefulWidget with BaseTextField {
  CalculatorTextField({
    Key? key,
    this.title,
    this.initialValue = 0.0,
    this.boxDecoration,
    this.appBarBackgroundColor,
    this.numberWindowBackgroundColor = Colors.white,
    this.numberWindowTextColor = Colors.black,
    this.operatorButtonColor = Colors.amber,
    this.operatorTextButtonColor = Colors.white,
    this.normalButtonColor = Colors.white,
    this.normalTextButtonColor = Colors.grey,
    this.doneButtonColor = Colors.blue,
    this.doneTextButtonColor = Colors.white,
    this.onSubmitted,
    this.inputDecoration = const InputDecoration(),
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.valueFormat,
    this.allowNegativeResult = true,
    this.theme = CalculatorThemes.curve,
  }) : super(key: key);

  @override
  final String? title;
  @override
  final double initialValue;
  @override
  final BoxDecoration? boxDecoration;
  final Color numberWindowBackgroundColor;
  final Color numberWindowTextColor;
  @override
  final Color? appBarBackgroundColor;
  @override
  final Color operatorButtonColor;
  @override
  final Color operatorTextButtonColor;
  @override
  final Color normalButtonColor;
  @override
  final Color normalTextButtonColor;
  @override
  final Color doneButtonColor;
  @override
  final Color doneTextButtonColor;
  final ValueChanged<double?>? onSubmitted;
  final InputDecoration inputDecoration;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final ValueFormat<double?>? valueFormat;
  @override
  final bool allowNegativeResult;
  @override
  final CalculatorThemes theme;

  @override
  _CalculatorTextFieldState createState() => _CalculatorTextFieldState();
}

class _CalculatorTextFieldState extends State<CalculatorTextField> {
  final inputController = TextEditingController();

  @override
  void initState() {
    super.initState();

    setValue(widget.initialValue);
  }

  void setValue(double? value) {
    inputController.text =
        widget.valueFormat != null ? widget.valueFormat!(value) : '$value';
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: inputController,
      readOnly: true,
      style: widget.style,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      decoration: widget.inputDecoration,
      onTap: () async {
        final result = await widget.showInputCalculator(context);
        setState(() {
          setValue(result);

          if (widget.onSubmitted != null) widget.onSubmitted!(result);
        });
      },
    );
  }
}
