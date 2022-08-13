import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_budget/models/category.dart';
import 'package:open_budget/repository/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;

  CategoryBloc(this._categoryRepository) : super(CategoryInitial()) {
    on<LoadCategories>((event, emit) {
      emit(CategoryLoaded(categories: _categoryRepository.getCategories()));
    });
    on<SaveCategory>((event, emit) {
      _categoryRepository.save(event.category);
      emit(CategoryLoaded(categories: _categoryRepository.getCategories()));
    });
  }
}
