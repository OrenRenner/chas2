import 'package:championat_asia_firstver/screens/match_screen/MatchDetails.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LineupView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _LineupViewState();
  }

}

class _LineupViewState extends State<LineupView> {
  bool loading = true;
  final String url = "https://championat.asia/api/statistics/lineup-" + MatchDetails.type + "?id=" + MatchDetails.id;
  List home;
  List away;
  var event;

  Future<Null> makeRequest() async{
    try{
      var response = await http
          .get(Uri.encodeFull(url),
          headers: {"Accept": "application/json",});
      //print(response.body);
      setState(() {
        var extractdata = json.decode(response.body);
        home = extractdata["data"]["home"];
        away = extractdata["data"]["away"];
        event = extractdata["data"]["event"];

        loading = false;
      });

    } catch(e){
      print(e);
    }
  }


  @override
  void initState() {
    super.initState();
    makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return loading ?
    Center(child: CircularProgressIndicator())
        :
    RefreshIndicator(
        onRefresh: makeRequest,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image.network(event["homeLogo"]),
                  ),
                  Text(event["home"].toString(),
                  style: TextStyle(fontSize: 19, color: Colors.black87),),
                ],
              ),

              ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: home.length,
                  itemBuilder: (BuildContext context, i){
                    return Container(
                      padding: new EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 45.0,
                            width: 45.0,
                            padding: new EdgeInsets.all(7.0),
                            decoration: new BoxDecoration(
                              color: Colors.deepPurple,
                              shape: BoxShape.circle,
                              border: new Border.all(
                                color: Colors.amberAccent,
                                width: 2.5,
                              ),
                            ),
                            child: new Center(
                              child: new Text(
                                home[i]["shirt_number"].toString(),
                                style: TextStyle(color: Colors.white, fontSize: 17),
                              ),
                            ),
                          ),

                          Container(width: 5,),

                          Text(home[i]["name"],
                            style: TextStyle(fontSize: 18, color: Colors.black87),),

                          Container(width: 5,),

                          Text("(" + home[i]["type"].toString() + ")",
                            style: TextStyle(fontSize: 15, color: Colors.black87),),
                        ],
                      ),
                    );
                  }
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image.network(event["awayLogo"]),
                  ),
                  Text(event["away"].toString(),
                    style: TextStyle(fontSize: 19, color: Colors.black87),),
                ],
              ),

              ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: away.length,
                  itemBuilder: (BuildContext context, i){
                    return Container(
                      padding: new EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 45.0,
                            width: 45.0,
                            padding: new EdgeInsets.all(7.0),
                            decoration: new BoxDecoration(
                              color: Colors.deepPurple,
                              shape: BoxShape.circle,
                              border: new Border.all(
                                color: Colors.amberAccent,
                                width: 2.5,
                              ),
                            ),
                            child: new Center(
                              child: new Text(
                                away[i]["shirt_number"].toString(),
                                style: TextStyle(color: Colors.white, fontSize: 17),
                              ),
                            ),
                          ),

                          Container(width: 5,),

                          Text(away[i]["name"],
                            style: TextStyle(fontSize: 18, color: Colors.black87),),

                          Container(width: 5,),

                          Text("(" + away[i]["type"].toString() + ")",
                            style: TextStyle(fontSize: 15, color: Colors.black87),),
                        ],
                      ),
                    );
                  }
              )
            ],
          ),
        ),
    );
  }
}