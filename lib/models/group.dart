import 'package:objectbox/objectbox.dart';

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
