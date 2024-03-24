part of 'result_cubit.dart';

@immutable
sealed class ResultState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ResultInitial extends ResultState {
  @override
  List<Object?> get props => [];
}

final class ResultLoading extends ResultState {
  @override
  List<Object?> get props => [];
}

final class ResultLoaded extends ResultState {
  final List<ResultsForCheck> results;
  final CheckFromServer checkfromServer;

  ResultLoaded({required this.results, required this.checkfromServer});
  @override
  List<Object?> get props => [results, checkfromServer];
}

final class ResultError extends ResultState {
  final String errorMessage;

  ResultError({required this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}
