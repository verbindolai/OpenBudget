import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_budget/bloc/category/category_bloc.dart';
import 'package:open_budget/models/category.dart';

import '../icon_picker/icon_picker.dart';

class EditCategory extends StatefulWidget {
  final Category category;

  const EditCategory({Key? key, required this.category}) : super(key: key);

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
        // backgroundColor: const Color(0xFF000814),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ListTile(
              leading: buildCategoryIcon(),
              title: buildCategoryName(),
            ),
            buildSubmit()
          ],
        ),
      ),
    );
  }

  Widget buildCategoryName() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: TextFormField(
        decoration: const InputDecoration(
          labelText: 'Name',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          return null;
        },
        maxLength: 128,
        onSaved: (value) => {
          if (value != null) {widget.category.name = value}
        },
      ),
    );
  }

  Widget buildCategoryIcon() {
    return IconPicker(
      iconSize: 35,
      buttonSize: 30,
      onChange: (iconMapEntry) => {widget.category.icon = iconMapEntry.key},
    );
  }

  Widget buildSubmit() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: ElevatedButton(
        child: const Text('Save'),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState?.save();

            final categoryBloc = context.read<CategoryBloc>();
            categoryBloc.add(SaveCategory(category: widget.category));
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
