import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationInitial()) {
    on<SelectNavigation>((event, emit) {
      emit(NavigationSelected(event.title, page: event.page));
    });
  }
}

enum NavigationPage { accounts, home, settings, reports }
