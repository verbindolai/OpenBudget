import 'package:flutter/material.dart';

import '../icon_picker/icon_picker.dart';

class EditCategory extends StatefulWidget {
  const EditCategory({Key? key}) : super(key: key);

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  Future<void> _showIconPickerDialog() async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(title: Text("Icon")), body: IconPicker())));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text("Pick"),
      onPressed: () {
        _showIconPickerDialog();
      },
    );
  }
}
