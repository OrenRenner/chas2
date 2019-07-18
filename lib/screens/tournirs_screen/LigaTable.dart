import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LigaTable extends StatefulWidget{
  final String type;
  final List tournaments;

  const LigaTable({Key key, @required this.type, @required this.tournaments}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LigaTableState();
  }
}

class _LigaTableState extends State<LigaTable>{
  final String url = "https://championat.asia/api/tournaments/table-";
  //+widget.type+"?tournament=";
  String table;
  String tournamentID;
  List tournaments;
  String tournamentName;
  var data;
  List tableList;
  //List<InkWell> tournamentLabels;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    /*setState(() {
      tournamentLabels = new List();
      for(int i = 0; i < tournaments.length; i++){
        tournamentLabels.add(
          InkWell(
            child: Text(tournaments[i]["title"].toString()),
            onTap: (){this.makeRequest(i);},
          )
        );
      }
    });*/
    makeFirstRequest();
  }

  @override
  Widget build(BuildContext context) {
    return loading ?
    Center(
        child: CircularProgressIndicator()
    )
    :
    RefreshIndicator(
      onRefresh: makeFirstRequest,
      child: ListView(
        children: <Widget>[
          Container(
            width: 0.3*MediaQuery.of(context).size.width,
            child: ExpansionTile(
              title: Text(tournamentName),
              children: tournaments
                  .map(
                      (item) => Container(
                        padding: EdgeInsets.all(10),
                        child: InkWell(
                          child: Text(
                            item["title"].toString(),
                            style: TextStyle(fontSize: 17),
                          ),
                          onTap: (){this.makeRequest(item);},
                        ),
                      )).toList(),
            ),
          ),

          Container(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[400],
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 10),
                  width: 0.44 * MediaQuery.of(context).size.width,
                  child: Text("Teams",
                    style: TextStyle(fontSize: 18),),
                ),

                Container(
                  width: 0.08 * MediaQuery.of(context).size.width,
                  child: Text("М",
                    style: TextStyle(fontSize: 17),),
                ),
                Container(
                  width: 0.08 * MediaQuery.of(context).size.width,
                  child: Text("В",
                    style: TextStyle(fontSize: 17),),
                ),
                Container(
                  width: 0.08 * MediaQuery.of(context).size.width,
                  child: Text("Н",
                    style: TextStyle(fontSize: 17),),
                ),
                Container(
                  width: 0.08 * MediaQuery.of(context).size.width,
                  child: Text("П",
                    style: TextStyle(fontSize: 17),),
                ),
                Container(
                  width: 0.08 * MediaQuery.of(context).size.width,
                  child: Text("Г",
                    style: TextStyle(fontSize: 17),),
                ),
                Container(
                  width: 0.08 * MediaQuery.of(context).size.width,
                  child: Text("Пг",
                    style: TextStyle(fontSize: 17),),
                ),
                Container(
                  width: 0.08 * MediaQuery.of(context).size.width,
                  child: Text("О",
                    style: TextStyle(fontSize: 17),),
                ),
              ],
            ),
          ),

          ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: tableList.length,
              itemBuilder: (BuildContext context, i){
                return Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      width: MediaQuery.of(context).size.width,
                      //color: Colors.grey[400],
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 5),
                            width: 0.44 * MediaQuery.of(context).size.width,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 0.06 * MediaQuery.of(context).size.width,
                                  child: Text(tableList[i]["rank"].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18,),),
                                ),
                                Image.network(tableList[i]["logoUrl"].toString(), height: 22, width: 22,),
                                Container(width: 5,),
                                Text(tableList[i]["name"].toString(),
                                  style: TextStyle(fontSize: 17),)
                              ],
                            ),
                          ),

                          Container(
                            width: 0.08 * MediaQuery.of(context).size.width,
                            child: Text(tableList[i]["games"].toString(),
                              style: TextStyle(fontSize: 17),),
                          ),
                          Container(
                            width: 0.08 * MediaQuery.of(context).size.width,
                            child: Text(tableList[i]["wins"].toString(),
                              style: TextStyle(fontSize: 17),),
                          ),
                          Container(
                            width: 0.08 * MediaQuery.of(context).size.width,
                            child: Text(tableList[i]["draws"].toString(),
                              style: TextStyle(fontSize: 17),),
                          ),
                          Container(
                            width: 0.08 * MediaQuery.of(context).size.width,
                            child: Text(tableList[i]["defeits"].toString(),
                              style: TextStyle(fontSize: 17),),
                          ),
                          Container(
                            width: 0.08 * MediaQuery.of(context).size.width,
                            child: Text(tableList[i]["scored"].toString(),
                              style: TextStyle(fontSize: 17),),
                          ),
                          Container(
                            width: 0.08 * MediaQuery.of(context).size.width,
                            child: Text(tableList[i]["missed"].toString(),
                              style: TextStyle(fontSize: 17),),
                          ),
                          Container(
                            width: 0.08 * MediaQuery.of(context).size.width,
                            child: Text(tableList[i]["points"].toString(),
                              style: TextStyle(fontSize: 17),),
                          ),
                        ],
                      ),
                    ),

                    Divider(
                      height: 10,
                    ),
                  ],
                );
              }
          )
        ],
      ),
    );
  }

  Future<Null> makeFirstRequest() async {
    setState(() {
      loading = true;
      table = widget.type;
      tournaments = widget.tournaments;
      tournamentID = "?tournament=" + tournaments[0]["id"].toString();
      tournamentName = tournaments[0]["title"].toString();
    });
    try{
      var response = await http
          .get(Uri.encodeFull(url + table + tournamentID), headers: {"Accept": "application/json"});

      setState(() {
        var extractdata = json.decode(response.body);
        List temp = extractdata["data"];
        data = temp[0];
        tableList = data["table"];
        loading = false;
      });
    } catch(e){
      print(e);
    }
  }

  void makeRequest(item) async {
    setState(() {
      loading = true;
      table = widget.type;
      tournaments = widget.tournaments;
      tournamentID = "?tournament=" + item["id"].toString();
      tournamentName = item["title"].toString();
    });
    try{
      var response = await http
          .get(Uri.encodeFull(url + table + tournamentID), headers: {"Accept": "application/json"});

      setState(() {
        var extractdata = json.decode(response.body);
        List temp = extractdata["data"];
        data = temp[0];
        tableList = data["table"];
        loading = false;
      });
    } catch(e){
      print(e);
    }
  }
}