import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: constant_identifier_names
const CACHED_URL = 'CACHED_URL';

class LocalStorageService {
  SharedPreferences sharedPreferences;
  LocalStorageService({required this.sharedPreferences});

  String getUrlFromCache() {
    var url = sharedPreferences.getString(CACHED_URL) ?? '';
    log('Url recieved from Cache: $url');
    return url;
  }

  Future<void> setUrlToCache(String url) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString(CACHED_URL, url);
    log('Url writtеn to Cache: $url');
    return Future<void>.value();
  }
}
