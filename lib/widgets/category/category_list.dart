import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_budget/bloc/category/category_bloc.dart';
import 'package:open_budget/models/category.dart';
import 'package:open_budget/widgets/category/edit_category.dart';
import 'package:open_budget/widgets/shared/icon_picker/icon_picker.dart';

class CategoryList extends StatefulWidget {
  final Function(Category category) onCategorySelected;

  const CategoryList({Key? key, required this.onCategorySelected})
      : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoaded) {
          List<ListTile> tiles = state.categories.map((category) {
            IconWithColor iwc = iconMap[category.icon]!;

            return ListTile(
              contentPadding: EdgeInsets.all(4),
              onTap: () {
                widget.onCategorySelected(category);
              },
              leading: CircleAvatar(
                  backgroundColor: iwc.backgroundColor,
                  child: Icon(iwc.iconData, color: iwc.iconColor)),
              title: Text(category.name),
              trailing: IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditCategory(category: category),
                    ),
                  );
                },
              ),
            );
          }).toList();

          tiles.add(ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditCategory(category: Category("", "placeholder")),
                ),
              );
            },
            leading: Icon(
              Icons.add,
              color: Colors.white,
            ),
            title: Text("Add Category"),
          ));

          return Container(
            padding: const EdgeInsets.all(8),
            child: ListView(
              children: tiles,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
