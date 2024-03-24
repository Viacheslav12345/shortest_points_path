import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortest_points_path/data/const.dart';
import 'package:shortest_points_path/data/models/task_list_model.dart';

import 'package:shortest_points_path/presentation/calculation_process_screen/grid_and_block_cubit/grid_and_block_cell_cubit.dart';

class PreviewScreen extends StatelessWidget {
  final int numberOfTask;
  final String path;
  const PreviewScreen({
    super.key,
    required this.numberOfTask,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    List<Coords> listAllCells = [];
    List<Coords> listBlockCells = [];
    List<Coords> listRouteCells = [];
    var countOfGrid = 1;
    var stateGrid = BlocProvider.of<GridAndBlockCellCubit>(context).state;
    if (stateGrid is GridBlockRoutesReady) {
      listAllCells = stateGrid.allGrids[numberOfTask];
      listBlockCells = stateGrid.blockedCellsInGrids[numberOfTask];
      listRouteCells = stateGrid.listOfRoutes[numberOfTask];
      countOfGrid =
          (listAllCells.map((coord) => coord.x).toList()).reduce(max) + 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: listAllCells.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: countOfGrid,
              ),
              itemBuilder: (BuildContext context, int index) {
                var color = Constants.colorEmptyCell;
                if (listBlockCells.contains(listAllCells[index])) {
                  color = Constants.colorBlockCell;
                } else if (listAllCells[index] == listRouteCells.first) {
                  color = Constants.colorStartCell;
                } else if (listAllCells[index] == listRouteCells.last) {
                  color = Constants.colorEndCell;
                } else if (listRouteCells.contains(listAllCells[index])) {
                  color = Constants.colorRouteCell;
                }
                return Container(
                  decoration: BoxDecoration(
                    color: color,
                    border: Border.all(
                        color: listBlockCells.contains(listAllCells[index])
                            ? Constants.colorEmptyCell
                            : Constants.colorBlockCell),
                  ),
                  child: Center(
                    child: Text(
                      '(${listAllCells[index].x},${listAllCells[index].y})',
                      style: TextStyle(
                          color: listBlockCells.contains(listAllCells[index])
                              ? Constants.colorEmptyCell
                              : Constants.colorBlockCell),
                    ),
                  ),
                );
              },
            ),
          ),
          Text(
            path,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
