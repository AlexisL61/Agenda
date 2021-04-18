import 'dart:convert';

import 'package:http/http.dart' as http;

class AgendaData {
  static List<Resource> edtData = [];
  static final String edtUrl = "https://edtapi.maner.fr/v2/1/1186/json";

  static void getData() async {
    http.Response response = await http.get(edtUrl);
    List<dynamic> jsonData = json.decode(response.body);
    for (var i = 0; i < jsonData.length; i++) {
      Resource thisResource = Resource();
      thisResource.title = jsonData[i]["title"];
      thisResource.enseignant = jsonData[i]["enseignant"];
      thisResource.description = jsonData[i]["description"];
      thisResource.start = DateTime.parse(jsonData[i]["start"]).add(Duration(hours: 2));
      thisResource.end = DateTime.parse(jsonData[i]["end"]).add(Duration(hours: 2));
      thisResource.difference = (thisResource.end.millisecondsSinceEpoch - thisResource.start.millisecondsSinceEpoch)/1000/60;
      thisResource.location = jsonData[i]["location"];
      edtData.add(thisResource);
    }
  }
}

class Resource {
  String title;
  String enseignant;
  String description;
  DateTime start;
  DateTime end;
  double difference;
  String location;
}
