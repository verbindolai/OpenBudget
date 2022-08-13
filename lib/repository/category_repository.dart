import 'package:open_budget/models/category.dart';
import 'package:open_budget/objectbox.dart';

class CategoryRepository {
  final ObjectBox objectBox;

  CategoryRepository(this.objectBox);

  getCategory(int id) {
    return objectBox.store.box<Category>().get(id);
  }

  List<Category> getCategories() {
    return objectBox.store.box<Category>().getAll();
  }

  save(Category category) {
    return objectBox.store.box<Category>().put(category);
  }

  delete(int categoryId) {
    objectBox.store.box<Category>().remove(categoryId);
  }

  deleteAll() {
    return objectBox.store.box<Category>().removeAll();
  }
}
