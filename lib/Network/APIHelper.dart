import 'dart:convert';
import 'dart:io';
import "package:http/http.dart" as http;
// Retrieved with help from a Medium article.

APIHelper apiHelper = APIHelper();

class APIHelper {
  final String _baseUrl = "http://localhost:3000/";

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      Uri uri = Uri.parse("$_baseUrl$url");
      final response = await http.get(uri);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw Exception("No internet connection!");
    }
    return responseJson;
  }

  Future<dynamic> post(String url, Object contents) async {
    var responseJson;
    try {
      Map<String, String> headers = {"content-type": "application/json"};
      final response = await http.post((Uri.parse("$_baseUrl$url")),
          headers: headers, body: json.encode(contents));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw Exception("No internet connection!");
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    print("I got response: ${response.body}");
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        var message = responseJson["message"];
        return message;
      case 400:
        throw Exception(response.body.toString());
      case 401:
      case 403:
        throw Exception(response.body.toString());

      case 404:
        throw NotFoundException(response.body.toString());
      case 500:
      default:
        throw Exception(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}, error: ${response.body}');
    }
  }
}

class NotFoundException implements Exception {
  String cause = "Not found.";
  NotFoundException(this.cause);
  @override
  String toString() {
    return this.cause;
  }
}
