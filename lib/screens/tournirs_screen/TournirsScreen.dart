import 'package:championat_asia_firstver/screens/tournirs_screen/TournirsOverview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class TournirsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TournirsScreenState();
}

class _TournirsScreenState extends State<TournirsScreen>{
  String language;
  String url = "https://championat.asia/api/tournaments/?language=";
  List data;
  List<Tab> _tabs;
  List<Container> _tabViews;
  bool loading = true;


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

      var response = await http
          .get(Uri.encodeFull(url + language), headers: {"Accept": "application/json"});
      setState(() {
        var extractdata = json.decode(response.body);
        data = extractdata["data"];
        _tabs = new List();
        for(int i = 0; i < data.length; i++){
          _tabs.add(
            Tab(
              child: Container(
                alignment: Alignment.center,
                child: Text(data[i]["title"],
                    style: TextStyle(fontStyle: FontStyle.normal, fontSize: 17, fontWeight: FontWeight.bold,)),
              ),
            )
          );
        }

        _tabViews = new List();
        for(int i = 0; i < data.length; i++){
          List children = data[i]["children"];
          _tabViews.add(
            Container(
              child: ListView.builder(
                itemCount: children.length,
                itemBuilder: (BuildContext context, index){

                  if(children[index]["template"].toString().contains("false")){
                    List<Container> templatesView = new List();
                    List templates = children[index]["templates"];
                    for(int j = 0; j < templates.length; j++){
                      templatesView.add(
                        Container(
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                                    child: Text(templates[j]["title"],
                                            style: TextStyle(fontStyle: FontStyle.normal, fontSize: 20, fontWeight: FontWeight.w400,)),

                                ),
                                onTap: () {
                                  print("id=" + children[index]["id"].toString());
                                  print("template=" + templates[j]["id"].toString());
                                  TournirsOverview.type = children[index]["type"].toString();
                                  TournirsOverview.id = "id=" + children[index]["id"].toString();
                                  TournirsOverview.template = "template=" + templates[j]["id"].toString();
                                  Navigator.pushNamed(context, '/TournirsOverview');
                                }
                              ),

                              Divider(
                                height: 5.0,
                              )
                            ],
                          ),
                        )
                      );
                    }

                    return Column(
                        children: <Widget>[
                          ExpansionTile(
                          title: Container(
                                    width: MediaQuery.of(context).size.width,
                                    //padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                                    child: Row(
                                      children: <Widget>[
                                        Image.network(children[index]["imageUrl"]),
                                        Container(width: 10,),
                                        Text(children[index]["title"],
                                            style: TextStyle(fontStyle: FontStyle.normal, fontSize: 20, fontWeight: FontWeight.w400,)),
                                      ],
                                    )
                                ),
                            children: templatesView.toList(),
                          ),

                          Divider(
                            height: 5.0,
                          )
                        ],
                      );
                  } else {
                    return Column(
                      children: <Widget>[
                        InkWell(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                              child: Row(
                                children: <Widget>[
                                  Image.network(children[index]["imageUrl"]),
                                  Container(width: 10,),
                                  Text(children[index]["title"],
                                      style: TextStyle(fontStyle: FontStyle.normal, fontSize: 20, fontWeight: FontWeight.w400,)),
                                ],
                              )
                          ),
                          onTap: () {
                            print("id=" + children[index]["id"].toString());
                            print("template=" + children[index]["template"].toString());
                            TournirsOverview.type = children[index]["type"].toString();
                            TournirsOverview.id = "id=" + children[index]["id"].toString();
                            TournirsOverview.template = "template=" + children[index]["template"].toString();
                            Navigator.pushNamed(context, '/TournirsOverview');
                          }
                        ),

                        Divider(
                          height: 5.0,
                        )
                      ],
                    );
                  }
                }
              ),
            )
          );
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
    makeFirstRequest();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Center(child: CircularProgressIndicator()) :
    DefaultTabController(
      length: data == null ? 0 : data.length,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            isScrollable: true,
            tabs: _tabs.toList(),
          ),
        ),
        body: TabBarView(
          children: _tabViews.toList(),
        ),
      ),
    );
  }
}

