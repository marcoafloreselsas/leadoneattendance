import 'package:http/http.dart' as http;
import 'package:leadoneattendance/models/fiverecords.dart';

class RemoteService {
  Future<List<Record>?> getPosts() async {
    var client = http.Client();

    var uri = Uri.parse('https://ccd9-45-65-152-57.ngrok.io/get/fiverecords/1');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return postFromJson(json);
    }
    return null;
  }
}