import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'package:championat_asia_firstver/screens/match_screen/MatchDetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:championat_asia_firstver/screens/home_screen/MatchesItemWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_calendar/flutter_calendar.dart';

class MatchScreenArguments {
  final String language;

  MatchScreenArguments(this.language);
}

class MatchScreen extends StatefulWidget { // ignore: must_be_immutable

  @override
  State<StatefulWidget> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen>{
  // ignore: non_constant_identifier_names
  bool loading = true;
  List data;
  List stages;
  String language = '';
  String url = 'https://championat.asia/api/statistics/match-center?language=';
  // ignore: non_constant_identifier_names
  String AppTitle = 'Match-Center(LIVE)';
  DateTime dataPicker;
  List<ExpansionTile> _listOfExpansions = new List();
  BuildContext widgetContext;

  Future<Null> makeRequest(curData) async {
    String url = 'https://championat.asia/api/statistics/match-center?language=' ;
    var response = await http
        .get(Uri.encodeFull(url + language + '&date=' + '${curData.toString().substring(0, 10)}'), headers: {"Accept": "application/json"});

    setState(() {
      print(response.statusCode);
      var extractdata = json.decode(response.body);
      data = extractdata["data"]["hot"];
      stages = extractdata["data"]["stages"];
      for(int i = 0; i < stages.length; i++){
        List temp1 = stages[i]["data"];
        ExpansionTile temp = ExpansionTile(
          title: Text(stages[i]["title"]),
          children: temp1
              .map((item) =>InkWell(
            child: MatchesItemWidget1(post: item),
            onTap: () {
              MatchDetails.logoName = item["homeTeam"].toString() + " - " + item["awayTeam"].toString();
              MatchDetails.type = item["type"].toString();
              MatchDetails.id = item["id"].toString();
              Navigator.pushNamed(widgetContext, '/MatchDetails');
            },
          ))
              .toList(),
        );
        _listOfExpansions.add(temp);
      }
      loading = false;
    });
  }

  Future<Null> reloadRequest() async {
    String url = 'https://championat.asia/api/statistics/match-center?language=' ;
    var response = await http
        .get(Uri.encodeFull(url + language + '&date=' + dataPicker.toString().substring(0, 10)), headers: {"Accept": "application/json"});

    setState(() {
      _listOfExpansions.clear();
      var extractdata = json.decode(response.body);
      data = extractdata["data"]["hot"];
      stages = extractdata["data"]["stages"];
      for(int i = 0; i < stages.length; i++){
        List temp1 = stages[i]["data"];
        ExpansionTile temp = ExpansionTile(
          title: Text(stages[i]["title"]),
          children: temp1
              .map((item) => InkWell(
            child: MatchesItemWidget1(post: item),
            onTap: () {
              MatchDetails.logoName = item["homeTeam"].toString() + " - " + item["awayTeam"].toString();
              MatchDetails.type = item["type"].toString();
              MatchDetails.id = item["id"].toString();
              Navigator.pushNamed(widgetContext, '/MatchDetails');
            },
          ))
              .toList(),
        );
        _listOfExpansions.add(temp);
      }
      loading = false;
    });
  }

  Future<Null> makeFirstRequest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'my_lang_key';
      setState(() {
        language = prefs.getString(key) ?? '';
      });
    } catch(e){
      print(e);
    }

    if(language.contains("ru")){
      AppTitle = "Матч-Центр(LIVE)";
    } else if(language.contains("uz")){
      AppTitle = "Матч-Центр(LIVE)";
    } else if(language.contains("oz")){
      AppTitle = "Match-Center(LIVE)";
    }

    try {

      var response = await http
          .get(Uri.encodeFull(url + language +'&date='+ dataPicker.toString().substring(0, 10)), headers: {"Accept": "application/json"});
      setState(() {
        var extractdata = json.decode(response.body);
        data = extractdata["data"]["hot"];
        stages = extractdata["data"]["stages"];

        for(int i = 0; i < stages.length; i++){
          List temp1 = stages[i]["data"];
          List<InkWell> matches = new List();
          for(int j = 0; j < temp1.length; j++){
            matches.add(InkWell(
              child: MatchesItemWidget1(post: temp1[j]),
              onTap: () {
                MatchDetails.logoName = temp1[j]["homeTeam"].toString() + " - " + temp1[j]["awayTeam"].toString();
                MatchDetails.type = temp1[j]["type"].toString();
                MatchDetails.id = temp1[j]["id"].toString();
                Navigator.pushNamed(widgetContext, '/MatchDetails');
              },
            ));
          }
          ExpansionTile temp = ExpansionTile(
            title: Text(stages[i]["title"]),
            children: matches.toList(),
          );
          _listOfExpansions.add(temp);
        }
        loading = false;
      });
    } catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    dataPicker = DateTime.now();
    this.makeFirstRequest();
  }
  //loading ? Center(child: CircularProgressIndicator()) :
  @override
  Widget build(BuildContext context) {
    setState(() {
      widgetContext = context;
    });

    return Scaffold(
        body: RefreshIndicator(
            onRefresh: reloadRequest,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Calendar(
                  onDateSelected: (data){
                    setState(() {
                      loading = true;
                      _listOfExpansions.clear();
                    });
                    makeRequest(data);
                    //print("${data.toString().substring(0, 10)}");
                  },
                  onSelectedRangeChange: (range) {
                    setState(() {
                      loading = true;
                      _listOfExpansions.clear();
                    });
                    makeRequest(range);
                    //print("Range is ${range.item1}, ${range.item2}");
                  },
                  isExpandable: true,
                ),
                Divider(
                  height: 20.0,
                ),
                loading ? Center(child: CircularProgressIndicator()) : ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: data == null ? 0 : data.length,
                    itemBuilder: (BuildContext context, i) {
                      return InkWell(
                        child: MatchesItemWidget(post: data[i]),
                        onTap: () {
                          MatchDetails.logoName = data[i]["homeTeam"].toString() + " - " + data[i]["awayTeam"].toString();
                          MatchDetails.type = data[i]["type"].toString();
                          MatchDetails.id = data[i]["id"].toString();
                          Navigator.pushNamed(context, '/MatchDetails');
                        },
                      );
                    }
                ),
                Divider(
                  height: 20.0,
                ),
                loading ? Container() : ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: data == null ? 0 : _listOfExpansions.length,
                    itemBuilder: (BuildContext context, i) {
                      /*if(i == data.length - 5){
                    current_page ++;
                    this.makeRequest(current_page);
                  }*/
                      return _listOfExpansions[i];
                    }
                )

              ],
            )
        )
    );
  }

}

