import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortest_points_path/presentation/result_and_preview_screens/preview_screen.dart';
import 'package:shortest_points_path/presentation/result_and_preview_screens/result_cubit/result_cubit.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var resultsCount = 0;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Result list screen'),
        ),
        body: BlocBuilder<ResultCubit, ResultState>(
          builder: (context, state) {
            var listResultsPath = [];
            if (state is ResultLoaded) {
              resultsCount = state.results.length;
              for (var result in state.results) {
                listResultsPath.add(result.result.path);
              }
            }
            return switch (state) {
              ResultInitial() ||
              ResultLoading() =>
                const Center(child: CircularProgressIndicator()),
              ResultLoaded() => ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PreviewScreen(
                                numberOfTask: index,
                                path: listResultsPath[index])),
                      ),
                      child: ListTile(
                        title: Center(child: Text(listResultsPath[index])),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemCount: resultsCount,
                ),
              ResultError() => Center(child: Text(state.errorMessage))
            };
          },
        ));
  }
}
