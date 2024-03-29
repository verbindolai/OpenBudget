import 'package:objectbox/objectbox.dart';

import 'group.dart';

@Entity()
class Category {
  @Id()
  int id = 0;

  String name;
  String icon;
  final group = ToOne<Group>();

  Category(this.name, this.icon);

  @override
  String toString() {
    return "Category{id: $id, name: $name}";
  }
}
