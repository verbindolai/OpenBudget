import 'package:open_budget/objectbox.g.dart';

import 'category.dart';

@Entity()
class Group {
  @Id()
  int id = 0;

  String name;

  Group(this.name);

  @Backlink('group')
  final categories = ToMany<Category>();
}
