import 'dart:convert';
import 'dart:io';
import "package:http/http.dart" as http;
import 'dart:convert' as convert;
// Retrieved with help from a Medium article.

APIHelper apiHelper = APIHelper("http://localhost:3000/", {});

APIHelper tbaHelper = APIHelper("https://www.thebluealliance.com/api/v3/", {
  "X-TBA-Auth-Key":
      "uO7ynUIsR12kdFA7mY0Ggm8UiQAWCZ1m51ooCugpqlQoSywM2AC935R5yhv9l6LW"
});

String authToken = "cpchicken:c268bdc2-540d-4857-96bf-a7ed2d877fd5";
final bytes = convert.utf8.encode(authToken);
String encodedAuthToken = convert.base64.encode(bytes);

APIHelper firstAPIHelper = APIHelper("https://frc-api.firstinspires.org/v3.0/", 
   {"Authorization": "Basic $encodedAuthToken"});

class APIHelper {
  String baseUrl = "";
  Map<String, String>? headerInfo = {};
  APIHelper(
    this.baseUrl,
    this.headerInfo,
  );

  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      Uri uri = Uri.parse("$baseUrl$url");
      final response = await http.get(uri, headers: this.headerInfo);
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
      final response = await http.post((Uri.parse("$baseUrl$url")),
          headers: headers, body: json.encode(contents));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw Exception("No internet connection!");
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    //print("I got response: ${response.body}");
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        var message = responseJson;
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
