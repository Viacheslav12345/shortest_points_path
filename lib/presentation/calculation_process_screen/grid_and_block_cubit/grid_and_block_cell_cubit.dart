import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortest_points_path/data/models/task_list_model.dart';

part 'grid_and_block_cell_state.dart';

class GridAndBlockCellCubit extends Cubit<GridAndBlockCellState> {
  GridAndBlockCellCubit() : super(GridAndBlockCellInitial());

  void createAllGridsAndBlockedCells(List<Data> dataList) {
    List<List<Coords>> allGrids = [];
    List<List<Coords>> blockedCellsInallGrids = [];

    for (var data in dataList) {
      List<Coords> currentAllGridGrid = [];
      for (var x = 0; x < data.field.length; x++) {
        if (x < 100) {
          for (var y = 0; y < data.field.length; y++) {
            if (y < 100) {
              currentAllGridGrid.add(Coords(x: x, y: y));
            }
          }
        }
      }
      allGrids.add(currentAllGridGrid);

      List<Coords> blockedCellsInGrid = [];
      for (var y = 0; y < data.field.length; y++) {
        if (y < 100) {
          final cells = data.field[y].split('');
          for (var x = 0; x < cells.length; x++) {
            if (x < 100) {
              if (cells[x] == 'X') {
                blockedCellsInGrid.add(currentAllGridGrid.firstWhere(
                  (element) => element.x == x && element.y == y,
                ));
              }
            }
          }
        }
      }
      blockedCellsInallGrids.add(blockedCellsInGrid);
    }

    emit(GridBlockRoutesReady(
        allGrids: allGrids,
        blockedCellsInGrids: blockedCellsInallGrids,
        listOfRoutes: const []));
  }

  void saveListOfRoutes(List<List<Coords>> listOfRoutes) {
    var currentState = state;
    if (currentState is GridBlockRoutesReady) {
      var allGrids = currentState.allGrids;
      var blockedCellsInGrids = currentState.blockedCellsInGrids;
      emit(GridBlockRoutesReady(
          allGrids: allGrids,
          blockedCellsInGrids: blockedCellsInGrids,
          listOfRoutes: listOfRoutes));
    }
  }
}
