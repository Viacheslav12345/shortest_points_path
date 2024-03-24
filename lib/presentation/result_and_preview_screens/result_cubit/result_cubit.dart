import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortest_points_path/data/models/check_from_server.dart';
import 'package:shortest_points_path/data/models/result_model.dart';
import 'package:shortest_points_path/data/services/api_service.dart';

part 'result_state.dart';

class ResultCubit extends Cubit<ResultState> {
  ResultCubit() : super(ResultInitial());

  Future<void> sendResultToServer(
      String url, List<ResultsForCheck> result) async {
    emit(ResultLoading());
    var checkFromServer = await ApiService().sendResultToServer(url, result);
    (!checkFromServer.error)
        ? emit(ResultLoaded(results: result, checkfromServer: checkFromServer))
        : emit(ResultError(errorMessage: checkFromServer.message));
  }
}
