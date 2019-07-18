import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:championat_asia_firstver/screens/match_screen/MatchDetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class EventView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _EventViewState();
  }
}

class _EventViewState extends State<EventView>{

  final String url = "https://championat.asia/api/statistics/event?";
  final String type = "type=" + MatchDetails.type;
  final String id = "&id=" + MatchDetails.id;
  List<Container> homeGoals;
  List<Container> awayGoals;
  bool loading = true;
  var data;
  List incidents;
  List<Widget> incidentsView;
  BuildContext buildContext;

  Future<Null> makeRequest() async{
    setState(() {
      loading = true;
    });
    try{
      var response = await http
          .get(Uri.encodeFull(url + type + id),
          headers: {"Accept": "application/json",});

      setState(() {
        print(id);
        print(type);
        var extractdata = json.decode(response.body);
        data = extractdata["data"];

        homeGoals = new List();
        awayGoals = new List();

        List homeG = data["homeGoals"];
        for(int i = 0; i < homeG.length; i++){
          homeGoals.add(Container(
            margin: new EdgeInsets.only(left: 10),
            padding: new EdgeInsets.all(5),
            child: Text(homeG[i]["title"].toString() + " - " + homeG[i]["elapsed"].toString(),
              style: TextStyle(fontSize: 17, color: Colors.black87),),
          ));
        }

        List awayG = data["awayGoals"];
        for(int i = 0; i < awayG.length; i++){
          awayGoals.add(Container(
            margin: new EdgeInsets.only(right: 10),
            padding: new EdgeInsets.all(5),
            child: Text(awayG[i]["elapsed"].toString() + " - " + awayG[i]["title"].toString(),
              style: TextStyle(fontSize: 17, color: Colors.black87),),
          ));
        }

        incidents = data["incidents"];
        if(!data["statusDesc"].toString().contains("notstarted")){
          incidentsView = new List();
          bool flag = true;
          for(int i = 0; i < incidents.length; i++){
            if(i == 0)
              incidentsView.add(Container(
                color: Colors.deepPurple,
                padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                child: Center(
                  child: Text("First Half", style: TextStyle(color: Colors.white, fontSize: 17)),
                ),
              ));

            if(incidents[i]["elapsed"] > 45 && flag){
              incidentsView.add(Container(
                color: Colors.deepPurple,
                padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                child: Center(
                  child: Text("Second Half", style: TextStyle(color: Colors.white, fontSize: 17)),
                ),
              ));
              flag = false;
            }

            Icon icon;
            if(incidents[i]["incident_code"].toString().contains("card")){
              icon = Icon(Icons.insert_drive_file, color: Colors.yellow,);
            } else if(incidents[i]["incident_code"].toString().contains("goal")){
              icon = Icon(Icons.language, color: Colors.black87,);
            } else if(incidents[i]["incident_code"].toString().contains("subst")){
              icon = Icon(Icons.cached, color: Colors.blue,);
            } else icon = Icon(Icons.insert_drive_file, color: Colors.red,);

            incidentsView.add(Container(
              width: MediaQuery.of(buildContext).size.width,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 0.45 * MediaQuery.of(buildContext).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                        child:  incidents[i]["type"].toString().contains("home") ?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(incidents[i]["name"].toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.black87, fontSize: 17)),

                                    incidents[i]["in_name"] != null ?
                                    Text(incidents[i]["in_name"].toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.black87, fontSize: 14))
                                    :
                                    Container(),
                                  ],
                                ),
                                Container(width: 5,),
                                icon
                              ],
                            )
                            :
                            Container(),
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                        width: 0.1 * MediaQuery.of(buildContext).size.width,
                        height: 40,
                        //color: Colors.red,
                        child: Text(
                            incidents[i]["elapsed"].toString() + "'",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.green, fontSize: 17),
                        ),
                      ),

                      Container(
                        width: 0.45 * MediaQuery.of(buildContext).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                        child:  incidents[i]["type"].toString().contains("away") ?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            icon,
                            Container(width: 5,),
                            Column(
                              children: <Widget>[
                                Text(incidents[i]["name"].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black87, fontSize: 17)),

                                incidents[i]["in_name"] != null ?
                                Text(incidents[i]["in_name"].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black87, fontSize: 14))
                                    :
                                Container(),
                              ],
                            ),
                          ],
                        )
                            :
                        Container(),
                      )
                    ],
                  ),

                  Icon(Icons.golf_course),
                ],
              )
            ));
          }
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
    makeRequest();
  }

  String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('dd/MM/yyy, kk:mm');
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = date.difference(now);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date); // Doesn't get called when it should be
    } else {
      time = diff.inDays.toString() + 'DAYS AGO'; // Gets call and it's wrong date
    }

    return time;
  }


  @override
  Widget build(BuildContext context) {
    setState(() {
      buildContext = context;
    });

    return loading ?
    Center(child: CircularProgressIndicator())
        :
    RefreshIndicator(
      onRefresh: makeRequest,
      child: Container(
        child: ListView(
          children: <Widget>[
            Container(height: 20,),

            Container(
              width: MediaQuery.of(context).size.width,
              child: Text(data["stage"].toString() + ". Тур " + data["round"].toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black87),),
            ),

            Container(height: 20,),

            Container(
              width: MediaQuery.of(context).size.width,
              child: Text(readTimestamp(data["unixtime"]),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 19, color: Colors.black87),),
            ),

            Container(height: 20,),

            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Container(
                      width: 0.3*MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.network(data["homeLogo"]),
                          Text(data["home"],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 19, color: Colors.black87,),)
                        ],
                      )
                  ),
                  Container(
                    width: 0.4*MediaQuery.of(context).size.width,
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: data["statusDesc"].toString().contains("notstarted") ?
                              Text("-",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 25, color: Colors.black87, fontWeight: FontWeight.bold),)
                                  :
                              Text(data["runningHome"].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 25, color: Colors.black87, fontWeight: FontWeight.bold),),
                              padding: new EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                              decoration: BoxDecoration(
                                  border: new Border.all(color: Colors.black87, width: 1)
                              ),
                            ),

                            Text(" : ",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 25, color: Colors.black87, fontWeight: FontWeight.bold),),

                            Container(
                              child: data["statusDesc"].toString().contains("notstarted") ?
                              Text("-",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 25, color: Colors.black87, fontWeight: FontWeight.bold),)
                                  :
                              Text(data["runningAway"].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 25, color: Colors.black87, fontWeight: FontWeight.bold),),
                              margin: new EdgeInsets.only(
                                left: 10.0,
                              ),
                              padding: new EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                              decoration: BoxDecoration(
                                  border: new Border.all(color: Colors.black87, width: 1)
                              ),
                            ),
                          ],
                        ),

                        Container(
                          margin: new EdgeInsets.only(
                            top: 10.0,
                          ),
                          child: Text(data["statusText"],
                            style: TextStyle(fontSize: 17, color: Colors.red[300], fontWeight: FontWeight.bold),),
                        )
                      ],
                    ),
                  ),
                  Container(
                      width: 0.3*MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.network(data["awayLogo"]),
                          Text(data["away"],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 19, color: Colors.black87),)
                        ],
                      )
                  ),
                ],
              ),
            ),

            Container(
              height: 20,
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 0.5*MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //primary: false,
                      //shrinkWrap: true,
                      children: homeGoals != null ? homeGoals.toList() : <Widget>[Container()],
                    ),
                  ),


                  Container(
                    width: 0.5*MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      //primary: false,
                      //shrinkWrap: true,
                      children: awayGoals != null ? awayGoals.toList() : <Widget>[Container()],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 20,
            ),

            !data["statusDesc"].toString().contains("notstarted") ?
                Column(
                  children: incidentsView.toList(),
                )
                :
                Container(),

            data["statusDesc"].toString().contains("finished") ?
                Container(
                  color: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                  child: Center(
                    child: Text("Match is over", style: TextStyle(color: Colors.white, fontSize: 17)),
                  ),
                )
                :
                Container()
          ],
        ),
      ),
    );
  }
}