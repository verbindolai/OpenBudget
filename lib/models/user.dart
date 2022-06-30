import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  // Annotate with @Id() if name isn't "id" (case insensitive).
  int id = 0;
  String? name;

  User(String? name) {
    this.name = name;
  }
}
