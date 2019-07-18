import 'dart:convert';
import 'package:query_params/query_params.dart';
import 'package:championat_asia_firstver/screens/home_screen/ItemNews.dart';
import 'package:championat_asia_firstver/screens/home_screen/NewsDetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Search extends StatefulWidget{
  static String searchingTAG;
  @override
  State<StatefulWidget> createState() {
    return _SearchState();
  }
}

class _SearchState extends State<Search>{
  final searchController = TextEditingController();
  String language;
  int currentPage;
  String url = "https://championat.asia/api/search?";
  List data;
  String searchTAG;

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

    try {
      URLQueryParams queryParams = new URLQueryParams();
      queryParams.append('language', language);
      queryParams.append('page', "1");
      queryParams.append('q', searchTAG);
      print(queryParams.toString());
      var response = await http
          .get(url + queryParams.toString(), headers: {"Accept": "application/json"});
      setState(() {
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

  Future<Null> makeRequest(pageNum) async {
    URLQueryParams queryParams = new URLQueryParams();
    queryParams.append('language', language);
    queryParams.append('page', pageNum.toString());
    String s = "\"" + searchController.text + "\"";
    queryParams.append('q', s);
    print(queryParams.toString());
    /*+ 'language=' + language + '&page=' + '${pageNum.toString()}' + 'q=' + searchTAG*/
    var response = await http
        .get(url + queryParams.toString(), headers: {"Accept": "application/json"});

    setState(() {
      var extractdata = json.decode(response.body);
      if(data == null){
        data = extractdata["data"]["list"];
      } else {
        data.addAll(extractdata["data"]["list"]);
      }
    });
  }

  Future<Null> reloadRequest() async {
    URLQueryParams queryParams = new URLQueryParams();
    queryParams.append('language', language);
    queryParams.append('page', "1");
    String s = "\"" + searchController.text + "\"";
    queryParams.append('q', s);
    print(queryParams.toString());
/* + 'language=' + language + '&page=1' + 'q=' + searchTAG*/
    var response = await http
        .get(url + queryParams.toString(), headers: {"Accept": "application/json"});

    setState(() {
      var extractdata = json.decode(response.body);
      data = extractdata["data"]["list"];
    });
  }


  @override
  void initState() {
    super.initState();
    setState(() {
      searchTAG = Search.searchingTAG;
      if(searchTAG.length < 3)
        searchController.text = "";
      else searchController.text = searchTAG.substring(1, searchTAG.length - 1);
      currentPage = 1;
    });
    makeFirstRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32.0)
          ),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: reloadRequest/*() {
                print(searchTAG);
                setState(() {
                  searchTAG = searchController.text;
                });
                reloadRequest();
              }*/
              )
        ],
      ),

      body: data != null && data.length != 0 ? ListView.builder(
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, i) {
            if(i == data.length - 5){
              currentPage ++;
              this.makeRequest(currentPage);
            }
            return GestureDetector(
              child: InkWell(
                child: PostWidget(post: data[i]["data"]),
              ),
              onTap: () {
                // Navigate to the second screen using a named route
                NewsDetailsScreen.idl = data[i]["data"]["id"].toString();
                Navigator.pushNamed(
                  context,
                  NewsDetailsScreen.routeName,
                  arguments: NewsDetailsScreenArguments(
                      data[i]["data"]["id"].toString()
                  ),
                );
              },
            );
          }
      ) : Container(),
    );
  }
}