import 'package:objectbox/objectbox.dart';

@Entity()
class Category {
  @Id()
  int id = 0;

  String name;
  String icon;

  Category(this.name, this.icon);

  @override
  String toString() {
    // TODO: implement toString
    return "Category{id: $id, name: $name, icon: $icon}";
  }
}
