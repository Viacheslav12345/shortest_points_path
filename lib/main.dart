import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shortest_points_path/data/services/local_storage_service.dart';
import 'package:shortest_points_path/presentation/calculation_process_screen/grid_and_block_cubit/grid_and_block_cell_cubit.dart';
import 'package:shortest_points_path/presentation/result_and_preview_screens/result_cubit/result_cubit.dart';
import 'package:shortest_points_path/presentation/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GridAndBlockCellCubit(),
        ),
        BlocProvider(
          create: (context) => ResultCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Shortest Points Path',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blue,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20)),
          iconButtonTheme: IconButtonThemeData(
              style: ButtonStyle(
            iconColor: MaterialStateProperty.all(Colors.white),
          )),
          progressIndicatorTheme:
              const ProgressIndicatorThemeData(color: Colors.blue),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(color: Colors.blueAccent.shade700)))),
          ),
          textTheme: const TextTheme(
              titleMedium: TextStyle(fontSize: 18),
              titleLarge: TextStyle(fontSize: 20)),
          useMaterial3: true,
        ),
        home: HomeScreen(
          localStorageService:
              LocalStorageService(sharedPreferences: sharedPreferences),
        ),
      ),
    );
  }
}
