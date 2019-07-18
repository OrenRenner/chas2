import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:championat_asia_firstver/screens/home_screen/ItemNews.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:championat_asia_firstver/screens/home_screen/NewsDetails.dart';

class NewsScreenArguments {
  final String language;

  NewsScreenArguments(this.language);
}

class NewsScreen extends StatefulWidget { // ignore: must_be_immutable


  @override
  State<StatefulWidget> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen>{
  // ignore: non_constant_identifier_names
  static int current_page = 1;
  List data;
  String language = '';
  String url = 'https://championat.asia/api/news?language=';
  String AppTitle = 'News';

  Future<Null> makeRequest(pageNum) async {
    String url = 'https://championat.asia/api/news?language=' ;
    var response = await http
        .get(Uri.encodeFull(url + language + '&page=' + '${pageNum.toString()}'), headers: {"Accept": "application/json"});

    setState(() {
      print(response.statusCode);
      var extractdata = json.decode(response.body);
      if(data == null){
        data = extractdata["data"]["list"];
      } else {
        data.addAll(extractdata["data"]["list"]);
      }
    });
  }

  Future<Null> reloadRequest() async {
    String url = 'https://championat.asia/api/news?language=' ;
    var response = await http
        .get(Uri.encodeFull(url + language + '&page=1'), headers: {"Accept": "application/json"});

    setState(() {
      print(response.statusCode);
      var extractdata = json.decode(response.body);
      data = extractdata["data"]["list"];
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
      AppTitle = "Новости";
    } else if(language.contains("uz")){
      AppTitle = "Янгиликлар";
    } else if(language.contains("oz")){
      AppTitle = "Yangiliklar";
    }

    try {

      var response = await http
          .get(Uri.encodeFull(url + language +'&page=1'), headers: {"Accept": "application/json"});
      setState(() {
        print(response.statusCode);
        var extractdata = json.decode(response.body);
        if(data == null){
          data = extractdata["data"]["list"];
        } else {
          data.addAll(extractdata["data"]["list"]);
        }
      });
    } catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    current_page = 1;
    this.makeFirstRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppTitle),
        ),
        body: RefreshIndicator(
            onRefresh: reloadRequest,
            child: ListView.builder(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, i) {
              if(i == data.length - 5){
                current_page ++;
                this.makeRequest(current_page);
              }
              return GestureDetector(
                child: InkWell(
                  child: PostWidget(post: data[i]),
                ),
                onTap: () {
                  // Navigate to the second screen using a named route
                  NewsDetailsScreen.idl = data[i]["id"].toString();
                  Navigator.pushNamed(
                    context,
                    NewsDetailsScreen.routeName,
                    arguments: NewsDetailsScreenArguments(
                        data[i]["id"].toString()
                    ),
                  );
                },
              );
            }
            )
        )
    );
  }

}

