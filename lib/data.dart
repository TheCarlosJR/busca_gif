
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:busca_gif_aula/globals.dart';


Future<Map> getGifs(String? searchStr) async {
  if (searchStr == null) {
    return getTrends();
  }
  else if (searchStr.isEmpty) {
    return getTrends();
  }
  else {
    return getSearch(searchStr);
  }
}


// https://api.giphy.com/v1/gifs/trending?api_key=X6RDKFN0SEXZWMpljGI4sekLDzQE1ABg&limit=25&rating=g
Future<Map> getTrends() async {
  Uri uriAPITrend = Uri.https(
      apiURL1, apiURL2 + apiURLTrend,
      {
        apiURLKeyname:apiURLKey,
        "limit":apiPageCount.toString(),
        "offset":apiOffset.toString(),
        "rating":"g",
      });

  http.Response response = await http.get(uriAPITrend);
  return (json.decode(response.body));
}


// https://api.giphy.com/v1/gifs/random?api_key=X6RDKFN0SEXZWMpljGI4sekLDzQE1ABg&tag=&rating=g
Future<Map> getRandom(String? searchStr) async {
  searchStr ?? "";
  Uri uriAPIRand = Uri.https(
      apiURL1, apiURL2 + apiURLRand,
      {
        apiURLKeyname:apiURLKey,
        "tag":searchStr,
        "limit":apiPageCount.toString(), //n sabemos se funfa
        "offset":apiOffset.toString(), //n sabemos se funfa
        "rating":"g",
      });

  http.Response response = await http.get(uriAPIRand);
  return (json.decode(response.body));
}


// https://api.giphy.com/v1/gifs/search?api_key=X6RDKFN0SEXZWMpljGI4sekLDzQE1ABg&q=TESTE&limit=25&offset=0&rating=g&lang=pt
Future<Map> getSearch(String searchStr) async {
  Uri uriAPISearch = Uri.https(
      apiURL1, apiURL2 + apiURLSearch,
      {
        apiURLKeyname:apiURLKey,
        "q":searchStr,
        "limit":apiPageCount.toString(),
        "offset":apiOffset.toString(),
        "rating":"g",
        "lang":searchLang,
      });

  http.Response response = await http.get(uriAPISearch);
  return (json.decode(response.body));
}