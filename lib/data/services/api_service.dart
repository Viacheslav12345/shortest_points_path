import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shortest_points_path/data/models/check_from_server.dart';
import 'package:shortest_points_path/data/models/result_model.dart';
import 'package:shortest_points_path/data/models/task_list_model.dart';

class ApiService {
  Future<TaskList?> getTasks(String url) async {
    var uri = Uri.parse(url);

    log('request: ${uri.toString()}');

    try {
      var response =
          await http.get(uri, headers: {'accept': 'application/json'});

      if (response.statusCode == 200 ||
          response.statusCode == 429 ||
          response.statusCode == 500) {
        return TaskList.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error response');
      }
    } on Exception catch (e) {
      log(e.toString());
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<CheckFromServer> sendResultToServer(
      String url, List<ResultsForCheck> result) async {
    final uri = Uri.parse(url);

    log('request: ${uri.toString()}');

    http.Request req = http.Request('POST', Uri.parse(url))
      ..body = json.encode(result.map((res) => res.toJson()).toList())
      ..headers.addAll(
          {"accept": "application/json", "Content-Type": "application/json"});

    var streamedResponse = await req.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200 ||
        response.statusCode == 429 ||
        response.statusCode == 500) {
      return CheckFromServer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error response');
    }
  }
}
