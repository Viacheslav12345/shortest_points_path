part of 'grid_and_block_cell_cubit.dart';

sealed class GridAndBlockCellState extends Equatable {
  const GridAndBlockCellState();

  @override
  List<Object> get props => [];
}

final class GridAndBlockCellInitial extends GridAndBlockCellState {}

final class GridBlockRoutesReady extends GridAndBlockCellState {
  final List<List<Coords>> allGrids;
  final List<List<Coords>> blockedCellsInGrids;
  final List<List<Coords>> listOfRoutes;

  const GridBlockRoutesReady(
      {required this.allGrids,
      required this.blockedCellsInGrids,
      required this.listOfRoutes});

  @override
  List<Object> get props => [allGrids, blockedCellsInGrids, listOfRoutes];
}
