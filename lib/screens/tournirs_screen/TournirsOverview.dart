import 'dart:convert';
import 'package:championat_asia_firstver/screens/tournirs_screen/LigaTable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TournirsOverview extends StatefulWidget{
  static String type;
  static String id;
  static String template;

  @override
  State<StatefulWidget> createState() {
    return _TournirsOverviewState();
  }
}

class _TournirsOverviewState extends State<TournirsOverview> {
  String language;
  String url = "https://championat.asia/api/tournaments/" + TournirsOverview.type + "?" + TournirsOverview.id + "&" + TournirsOverview.template;
  var data;
  String appBarname;
  bool loading = true;
  List tournaments;

  Future<Null> makeFirstRequest() async{
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'my_lang_key';
      setState(() {
        language = prefs.getString(key) ?? '';
      });
    } catch(e){
      print(e);
    }

    try{
      var response = await http
          .get(Uri.encodeFull(url + "&language=" + language), headers: {"Accept": "application/json"});

      setState(() {
        var extractdata = json.decode(response.body);
        data = extractdata["data"];
        appBarname = data["activeStage"]["name"];
        tournaments = data["tournaments"];

        loading = false;
      });
    }catch(e){
      print(e);
    }
  }


  @override
  void initState() {
    super.initState();
    makeFirstRequest();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Scaffold(body: Center(child: CircularProgressIndicator()),) :
    DefaultTabController(
      length: data == null ? 0 : 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(data["activeStage"]["name"]),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list), text: "LigaTable",),
              Tab(icon: Icon(Icons.schedule), text: "Schedule",),
              Tab(icon: Icon(Icons.people), text: "Players",),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LigaTable(
              type: data["type"],
              tournaments: data["tournaments"],
            ),
            Center(child: Icon(Icons.videocam),),
            Center(child: Icon(Icons.dashboard),),
          ],
        ),
      ),
    );
  }
}