import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GallaryItem extends StatelessWidget {
  final post;

  const GallaryItem({Key key, @required this.post}) : super(key: key);

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

    String date = readTimestamp(post["unixtime"]);
    var width = MediaQuery.of(context).size.width;
    var height = 100.0 + width;

    return Card(
      color: Colors.white,
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white12),
        child:  Container(
              height: height,
              child: Column(
                  children: <Widget>[
                    Image.network(
                      post["imageUrl"]
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0),
                      child: Text(
                          post["title"],
                          softWrap: true,
                          style: TextStyle(color: Colors.black87, fontSize: 12, fontStyle: FontStyle.normal, fontWeight: FontWeight.w600,)
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
                      child: Row(
                        children: <Widget>[
                          Text(date, style: TextStyle(color: Colors.black87, fontSize: 12,)),
                          Container(
                            width: 15.0,
                          ),
                          Icon(Icons.comment, color: Colors.grey, size: 17,),
                          Container(
                            width: 3.0,
                          ),
                          Text(post["commentsCount"].toString(), style: TextStyle(color: Colors.grey, fontSize: 12,)),
                        ],
                      ),
                    ),
                  ]
              )
          ),
        ),
      );
  }
}
