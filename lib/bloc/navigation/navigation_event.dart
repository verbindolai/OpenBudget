part of 'navigation_bloc.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class SelectNavigation extends NavigationEvent {
  final NavigationPage page;
  final String title;

  const SelectNavigation(this.title, {required this.page});

  @override
  List<Object> get props => [page];
}
