import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shortest_points_path/data/models/task_list_model.dart';
import 'package:shortest_points_path/data/services/api_service.dart';
import 'package:shortest_points_path/data/services/local_storage_service.dart';
import 'package:shortest_points_path/presentation/calculation_process_screen/process_screen.dart';

class HomeScreen extends StatefulWidget {
  final LocalStorageService localStorageService;
  const HomeScreen({super.key, required this.localStorageService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// ignore: constant_identifier_names
const CACHED_URL = 'CACHED_URL';

class _HomeScreenState extends State<HomeScreen> {
  String urlFromCache = '';

  TextEditingController urlController = TextEditingController();

  void _saveUrlToCashe(String url) async {
    await widget.localStorageService.setUrlToCache(url);
  }

  String _getUrlFromCashe() {
    return widget.localStorageService.getUrlFromCache();
  }

  Future<TaskList?> _getTaskList(String cashedUrl) async {
    return await ApiService().getTasks(cashedUrl);
  }

  @override
  void initState() {
    urlFromCache = _getUrlFromCashe();
    urlController = TextEditingController(text: urlFromCache);
    super.initState();
  }

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Set valid API base URL in order to continue',
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Icon(Icons.compare_arrows),
                    const SizedBox(
                      width: 25,
                    ),
                    Flexible(
                        child: SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          bool validURL = Uri.parse(value!).isAbsolute;
                          if (!validURL) {
                            return 'Check that the url is correct';
                          }
                          return null;
                        },
                        controller: urlController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'\D+'))
                        ],
                      ),
                    )),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style,
                onPressed: () {
                  urlFromCache = urlController.text;
                  _saveUrlToCashe(urlController.text);
                  if (urlFromCache.isNotEmpty) {
                    _getTaskList(urlFromCache).then((taskList) {
                      (taskList == null || taskList.error)
                          ? Fluttertoast.showToast(
                              msg: taskList?.message ?? 'Error! Check URL!',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.blue,
                              textColor: Colors.black,
                              fontSize: 16.0,
                            )
                          : (taskList.data != null)
                              ? {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProcessScreen(
                                            dataList: taskList.data!,
                                            url: urlFromCache)),
                                  ),
                                }
                              : null;
                    });
                  }
                },
                child: const Text(
                  'Start counting process',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
