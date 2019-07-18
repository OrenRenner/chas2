import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostWidget extends StatelessWidget {
  final post;

  const PostWidget({Key key, @required this.post}) : super(key: key);

  String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('dd/MM kk:mm');
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
    String colorRating =post["ratingColor"].toString();
    var colorIcon;
    if(colorRating.contains("negative")){
      colorIcon = Colors.yellow[200];
    } else if(colorRating.contains("low")){
      colorIcon = Colors.orange[400];
    } else if(colorRating.contains("medium")){
      colorIcon = Colors.orange[900];
    } else {
      colorIcon = Colors.red[700];
    }

    String date = readTimestamp(post["unixtime"]);

    return Card(
      color: Colors.white,
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white12),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          title: Container(
              child: Wrap(
                runSpacing: 0.0, // gap between lines
                children: <Widget>[
                  post["tag"] != null ? Text(
                      post["tag"],
                      style: TextStyle(color: Colors.red[400], fontStyle: FontStyle.normal, fontSize: 16, fontWeight: FontWeight.bold,)
                  ) : Container(),
                  Container(width: 3),
                  Text(
                      post["title"],
                      softWrap: true,
                      style: TextStyle(color: Colors.black87, fontSize: 16, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600,)
                  ),
                  Container(width: 3),
                  Icon(Icons.wb_cloudy, color: colorIcon, size: 20,),
                  Container(width: 2),
                  Text(
                      post["rating"].toString(),
                      style: TextStyle(color: Colors.black87, fontSize: 16, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600,)
                  )
                ],
              )
          ),
          /**/

          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

          subtitle: Row(
            children: <Widget>[
              Text(date, style: TextStyle(color: Colors.black87)),
              Container(
                width: 30.0,
              ),
              Icon(Icons.visibility, color: Colors.grey, size: 20,),
              Container(
                width: 3.0,
              ),
              Text(post["viewsCount"].toString(), style: TextStyle(color: Colors.grey)),
              Container(
                width: 30.0,
              ),
              Icon(Icons.comment, color: Colors.grey, size: 17,),
              Container(
                width: 3.0,
              ),
              Text(post["commentsCount"].toString(), style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

class HotNews extends StatelessWidget {
  final post;

  const HotNews({Key key, @required this.post}) : super(key: key);

  String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('dd/MM kk:mm');
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
    String colorRating =post["ratingColor"].toString();
    var colorIcon;
    if(colorRating.contains("negative")){
      colorIcon = Colors.yellow[200];
    } else if(colorRating.contains("low")){
      colorIcon = Colors.orange[400];
    } else if(colorRating.contains("medium")){
      colorIcon = Colors.orange[900];
    } else {
      colorIcon = Colors.red[700];
    }

    String date = readTimestamp(post["unixtime"]);

    return Card(
      color: Colors.white,
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white12),
        child:  Container(

              child: Column(
                  children: <Widget>[
                    Image.network(
                      post["imageUrl"]
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                      child: Wrap(
                        runSpacing: 0.0, // gap between lines
                        children: <Widget>[
                          post["tag"] != null ? Text(
                              post["tag"],
                              style: TextStyle(color: Colors.red[400], fontStyle: FontStyle.normal, fontSize: 15, fontWeight: FontWeight.bold,)
                          ) : Container(),
                          Container(width: 3),
                          Text(
                              post["title"],
                              softWrap: true,
                              style: TextStyle(color: Colors.black87, fontSize: 15, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600,)
                          ),
                          /*Container(width: 3),
                          Icon(Icons.wb_cloudy, color: colorIcon, size: 20,),
                          Container(width: 2),
                          post["rating"] == null ? Text(
                              post["rating"].toString(),
                              style: TextStyle(color: Colors.black87, fontSize: 15, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600,)
                          ) : Container()*/
                        ],
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
                      child: Row(
                        children: <Widget>[
                          Text(date, style: TextStyle(color: Colors.black87)),
                          Container(
                            width: 30.0,
                          ),
                          Icon(Icons.visibility, color: Colors.grey, size: 20,),
                          Container(
                            width: 3.0,
                          ),
                          Text(post["viewsCount"].toString(), style: TextStyle(color: Colors.grey)),
                          Container(
                            width: 30.0,
                          ),
                          Icon(Icons.comment, color: Colors.grey, size: 17,),
                          Container(
                            width: 3.0,
                          ),
                          Text(post["commentsCount"].toString(), style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),

                    Container(height: 5,),
                  ]
              )
          ),
          /**/

        ),
      );
  }
}

Widget OtherNews(BuildContext context, String language){
  String goto = " ";
  if(language.contains("ru")){
    goto = "Все Новости";
  } else if(language.contains("oz")){
    goto = "Barcha Yangiliklar";
  } else if(language.contains("uz")){
    goto = "Барча Янгиликлар";
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