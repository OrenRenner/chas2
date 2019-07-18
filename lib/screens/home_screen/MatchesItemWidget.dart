import 'package:flutter/material.dart';

class MatchesItemWidget extends StatelessWidget {
  final post;

  const MatchesItemWidget({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double myWidth = (width - 50)/2;
    String status = post["status"];

    var homeTeamLogo;
    var awayTeamLogo;

    try{
      homeTeamLogo = Image.network(post["homeTeamLogoUrl"], width: 21.0, height: 21.0,);
    }catch(e){
      print(e);
      homeTeamLogo = Container(width: 21.0, height: 21.0,);;
    }

    try{
      awayTeamLogo = Image.network(post["awayTeamLogoUrl"], width: 21.0, height: 21.0,);
    }catch(e){
      print(e);
      awayTeamLogo= Container(width: 21.0, height: 21.0,);
    }

    return Card(
      color: Colors.white,
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white12),
        child: Column(
          children: <Widget>[
            Center(
              child: Text(post["stage"], style: TextStyle(color: Colors.grey)),
            ),
            Container(height: 4.0,),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(post["startTime"], style: TextStyle(color: Colors.grey)),
                    Container( width: 3.0),
                    Text(post["startDay"], style: TextStyle(color: Colors.grey)),
                    Container( width: 3.0),
                    status.contains("inprogress") ?
                    Text("(" + post["time"]["icon"].toString() + ")", style: TextStyle(color: Colors.red[400])) : Text("(" + post["time"]["icon"] + ")", style: TextStyle(color: Colors.grey)),
                  ],
                )
              )
            ),
            Container(height: 5.0,),
            Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Container(
                      width: myWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(post["homeTeam"], style: TextStyle(color: Colors.black87, fontSize: 15)),
                          Container( width: 3.0),
                          homeTeamLogo,
                          Container( width: 5.0),
                        ],
                      ),
                    ),


                    Container(
                      child: Row(
                        children: <Widget>[
                          !status.contains("notstarted") ?
                          Text(post["homeScore"].toString(), style: TextStyle(color: Colors.black87, fontSize: 16)) : Container(width: 5.0),

                          Container(child: Text(" - ", style: TextStyle(color: Colors.black87, fontSize: 16))),

                          !status.contains("notstarted") ?
                          Text(post["awayScore"].toString(), style: TextStyle(color: Colors.black87, fontSize: 16)) : Container(width: 5.0),
                        ],
                      ),
                    ),


                    Container(
                      width: myWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container( width: 5.0),
                          awayTeamLogo,
                          Container( width: 3.0),
                          Text(post["awayTeam"], style: TextStyle(color: Colors.black87, fontSize: 15)),
                        ],
                      ),
                    ),

                  ],
                )
            ),

            Container(height: 5.0,)
          ],
        ),
      ),
    );
  }
}

Widget OtherMatches(BuildContext context, String language){
  String goto = " ";
  if(language.contains("ru")){
    goto = "Все Матчи";
  } else if(language.contains("oz")){
    goto = "Barcha Uchrashuvlar";
  } else if(language.contains("uz")){
    goto = "Барча Учрашувлар";
  }

  return Card(
    color: Colors.white,
    elevation: 8.0,
    margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
    child: Container(
        decoration: BoxDecoration(color: Colors.white12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(goto),
            Icon(Icons.keyboard_arrow_down)
          ],
        )
    ),
  );
}


class MatchesItemWidget1 extends StatelessWidget {
  final post;

  const MatchesItemWidget1({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double myWidth = (width - 50)/2;
    String status = post["status"];

    var homeTeamLogo;
    var awayTeamLogo;

    try{
      homeTeamLogo = Image.network(post["homeTeamLogoUrl"], width: 21.0, height: 21.0,);
    }catch(e){
      print(e);
      homeTeamLogo = Container(width: 21.0, height: 21.0,);;
    }

    try{
      awayTeamLogo = Image.network(post["awayTeamLogoUrl"], width: 21.0, height: 21.0,);
    }catch(e){
      print(e);
      awayTeamLogo= Container(width: 21.0, height: 21.0,);
    }

    return Card(
      color: Colors.white,
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white12),
        child: Column(
          children: <Widget>[
            Container(height: 4.0,),
            Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(post["startTime"], style: TextStyle(color: Colors.grey)),
                        Container( width: 3.0),
                        Text(post["startDay"], style: TextStyle(color: Colors.grey)),
                        Container( width: 3.0),
                        status.contains("inprogress") ?
                        Text("(" + post["time"]["icon"].toString() + ")", style: TextStyle(color: Colors.red[400])) : Text("(" + post["time"]["icon"] + ")", style: TextStyle(color: Colors.grey)),
                      ],
                    )
                )
            ),
            Container(height: 5.0,),
            Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Container(
                      width: myWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(post["homeTeam"], style: TextStyle(color: Colors.black87, fontSize: 16)),
                          Container( width: 3.0),
                          homeTeamLogo,
                          Container( width: 5.0),
                        ],
                      ),
                    ),


                    Container(
                      child: Row(
                        children: <Widget>[
                          !status.contains("notstarted") ?
                          Text(post["homeScore"].toString(), style: TextStyle(color: Colors.black87, fontSize: 16)) : Container(width: 5.0),

                          Container(child: Text(" - ", style: TextStyle(color: Colors.black87, fontSize: 16))),

                          !status.contains("notstarted") ?
                          Text(post["awayScore"].toString(), style: TextStyle(color: Colors.black87, fontSize: 16)) : Container(width: 5.0),
                        ],
                      ),
                    ),


                    Container(
                      width: myWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container( width: 5.0),
                          awayTeamLogo,
                          Container( width: 3.0),
                          Text(post["awayTeam"], style: TextStyle(color: Colors.black87, fontSize: 16)),
                        ],
                      ),
                    ),

                  ],
                )
            ),

            Container(height: 5.0,)
          ],
        ),
      ),
    );
  }
}