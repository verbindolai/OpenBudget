part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadCategories extends CategoryEvent {
  const LoadCategories();
}

class SaveCategory extends CategoryEvent {
  final Category category;
  const SaveCategory({required this.category});
  @override
  List<Object> get props => [category];
}
