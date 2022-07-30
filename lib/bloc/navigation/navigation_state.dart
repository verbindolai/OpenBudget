part of 'navigation_bloc.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];
}

class NavigationInitial extends NavigationState {}

class NavigationSelected extends NavigationState {
  final NavigationPage page;

  const NavigationSelected({required this.page});

  @override
  List<Object> get props => [page];
}
