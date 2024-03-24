import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortest_points_path/data/models/result_model.dart';
import 'package:shortest_points_path/data/models/task_list_model.dart';
import 'package:shortest_points_path/presentation/calculation_process_screen/grid_and_block_cubit/grid_and_block_cell_cubit.dart';
import 'package:shortest_points_path/presentation/calculation_process_screen/process_screen_widgets/calculations_persentage_widget.dart';
import 'package:shortest_points_path/presentation/result_and_preview_screens/result_cubit/result_cubit.dart';
import 'package:shortest_points_path/presentation/result_and_preview_screens/result_screen.dart';

class ProcessScreen extends StatefulWidget {
  final List<Data> dataList;
  final String url;

  const ProcessScreen({super.key, required this.dataList, required this.url});

  @override
  State<ProcessScreen> createState() => _ProcessScreenState();
}

class _ProcessScreenState extends State<ProcessScreen> {
  late Data currentData;
  int numberOfData = 0;

  List<List<Coords>> allResultsCoords = [];
  List<Coords> resultListCoords = [];
  List<Coords> allGrid = [];
  List<Coords> blockedCellsInGrid = [];

  late Coords currentCell;
  late Coords targetCell;
  late Coords nextCell;

  double percentage = 0.0;

  void setCurrentDataField(List<Data> dataList) {
    final data = dataList[numberOfData];
    currentData = data;
    currentCell = data.start;
    targetCell = data.end;
    nextCell = currentCell;

    var currentGridState =
        BlocProvider.of<GridAndBlockCellCubit>(context).state;

    if (currentGridState is GridBlockRoutesReady) {
      allGrid = currentGridState.allGrids[numberOfData];
      blockedCellsInGrid = currentGridState.blockedCellsInGrids[numberOfData];
    }
  }

  void makeCalculation() {
    if (currentCell.x < targetCell.x && currentCell.y < targetCell.y) {
      nextCell = Coords(x: currentCell.x + 1, y: currentCell.y + 1);
    } else if (currentCell.x > targetCell.x && currentCell.y > targetCell.y) {
      nextCell = Coords(x: currentCell.x - 1, y: currentCell.y - 1);
    } else if (currentCell.x < targetCell.x && currentCell.y > targetCell.y) {
      nextCell = Coords(x: currentCell.x + 1, y: currentCell.y - 1);
    } else if (currentCell.x > targetCell.x && currentCell.y < targetCell.y) {
      nextCell = Coords(x: currentCell.x - 1, y: currentCell.y + 1);
    } else if (currentCell.x == targetCell.x && currentCell.y < targetCell.y) {
      nextCell = Coords(x: currentCell.x, y: currentCell.y + 1);
    } else if (currentCell.x == targetCell.x && currentCell.y > targetCell.y) {
      nextCell = Coords(x: currentCell.x, y: currentCell.y - 1);
    } else if (currentCell.x < targetCell.x && currentCell.y == targetCell.y) {
      nextCell = Coords(x: currentCell.x + 1, y: currentCell.y);
    } else if (currentCell.x > targetCell.x && currentCell.y == targetCell.y) {
      nextCell = Coords(x: currentCell.x - 1, y: currentCell.y);
    }
  }

  void checkAndAddCell(Coords nextCell) {
    if (!blockedCellsInGrid.contains(nextCell)) {
      currentCell = nextCell;
      resultListCoords.add(currentCell);
    }
    setState(() {});
  }

  void countingProcess() {
    BlocProvider.of<GridAndBlockCellCubit>(context)
        .createAllGridsAndBlockedCells(widget.dataList);
    setCurrentDataField(widget.dataList);
    resultListCoords = [];
    resultListCoords.add(currentCell);
    while (currentCell != targetCell) {
      setState(() {
        makeCalculation();
        checkAndAddCell(nextCell);
      });
    }
    if (!resultListCoords.contains(targetCell)) {
      resultListCoords.add(targetCell);
    }
    allResultsCoords.add(resultListCoords);
    BlocProvider.of<GridAndBlockCellCubit>(context)
        .saveListOfRoutes(allResultsCoords);
    numberOfData++;
  }

  Future<void> showPersentage() async {
    var countOfAllSteps = 0;
    for (var element in allResultsCoords) {
      countOfAllSteps = countOfAllSteps + element.length;
    }
    await Future.doWhile(() async {
      setState(() {
        percentage = percentage + 100 / countOfAllSteps;
      });
      await Future.delayed(const Duration(milliseconds: 300));
      if (percentage >= 100) {
        return false;
      }
      return true;
    });
  }

  Future<void> prepareAndsendResult(
      BuildContext context, List<Data> dataList) async {
    List<ResultsForCheck> result = [];
    if (allResultsCoords.isNotEmpty) {
      for (var i = 0; i < allResultsCoords.length; i++) {
        var stepsList = allResultsCoords[i]
            .map((coords) =>
                Steps(x: coords.x.toString(), y: coords.y.toString()))
            .toList();

        String path = stepsList
            .map((step) => '(${step.x},${step.y})')
            .toString()
            .replaceAll(RegExp(r'\, '), '->');
        String cutPath = path.substring(1, path.length - 1);
        result.add(ResultsForCheck(
          id: dataList[i].id,
          result: Result(steps: stepsList, path: cutPath),
        ));
      }
      await BlocProvider.of<ResultCubit>(context)
          .sendResultToServer(widget.url, result)
          .whenComplete(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ResultScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (numberOfData < widget.dataList.length) {
        countingProcess();
      }
    });

    if (allResultsCoords.length == widget.dataList.length &&
        percentage == 0.0) {
      showPersentage();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Process screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            CalculationsPercentageWidget(
              percentage: percentage,
            ),
            (percentage >= 100)
                ? SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: BlocBuilder<ResultCubit, ResultState>(
                      builder: (context, state) {
                        return (state is ResultLoading)
                            ? ElevatedButton(
                                style:
                                    Theme.of(context).elevatedButtonTheme.style,
                                onPressed: () {
                                  null;
                                },
                                child: const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 2.0,
                                  ),
                                ))
                            : ElevatedButton(
                                style:
                                    Theme.of(context).elevatedButtonTheme.style,
                                onPressed: () {
                                  prepareAndsendResult(
                                      context, widget.dataList);
                                },
                                child: Text(
                                  (state is ResultError)
                                      ? '${state.errorMessage} - Try again!'
                                      : 'Send results to server',
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              );
                      },
                    ),
                  )
                : const SizedBox(
                    width: double.infinity,
                    height: 60,
                  ),
          ],
        ),
      ),
    );
  }
}
