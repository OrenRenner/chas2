import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'package:championat_asia_firstver/drawer_scale_icon.dart';
import 'package:championat_asia_firstver/screens/home_screen/CommentsScreen.dart';
import 'package:championat_asia_firstver/screens/searching.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:share/share.dart';

class NewsDetailsScreenArguments {
  final String id;

  NewsDetailsScreenArguments(this.id);
}

class NewsDetailsScreen extends StatefulWidget {
  static const routeName = '/NewsDetails';
  static String idl;
  final String id;

  const NewsDetailsScreen({
    Key key,
    @required this.id,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen>{
  // ignore: non_constant_identifier_names
  static int current_page = 1;
  String language = '';
  var data;
  String url = 'https://championat.asia/api/news/view?key=chmandroidappkey&id=';
  String commentURL = "https://championat.asia/api/comments/best?type=news&id=";
  int imageHeight;
  int imageWidth;
  String id;
  var coef;
  var width;
  var heigth;
  String for_sourse = "Sourse: ";
  String best_com = "Best Comments";
  String setAnswer = "Answer";
  String allComments = "All Comments";
  String writeComment = "Write Comment";
  String markdown;
  List<Widget> tags;
  BuildContext _buildContext;
  String shareText;
  int total;
  List comments;

  Future<Null> reloadRequest() async {
    try {
      var response = await http
          .get(Uri.encodeFull(url + id), headers: {"Accept": "application/json"});
      var responseCom = await http
          .get(Uri.encodeFull(commentURL + id), headers: {"Accept": "application/json"});
      var extractdata = json.decode(response.body);
      var extractdataCom = json.decode(responseCom.body);
      setState(() {
        total = extractdataCom["data"]["total"];
        comments = extractdataCom["data"]["comments"];
        shareText = extractdata["data"]["shareText"];
        data = extractdata["data"];
        imageWidth = extractdata["data"]["imageWidth"];
        imageHeight = extractdata["data"]["imageHeight"];
        coef = imageHeight/imageWidth;
        width = MediaQuery.of(context).size.width;
        heigth = coef*width;
        markdown = html2md.convert(data["details"]);

        List temp = data["tags"];
        tags = new List();
        for(int i = 0; i < temp.length && temp.length != 0; i++){
          tags.add(
              Row(
                children: <Widget>[
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.grey,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                      child: Text(temp[i]["title"]),
                    ),
                    onTap: (){
                      Search.searchingTAG = "\""+ temp[i]["title"] +"\"";
                      Navigator.pop(context);
                      Navigator.pushNamed(_buildContext, '/Search',);
                    },
                  ),
                  Container(width: 10,)
                ],
              )
          );
        }
      });
    } catch(e){
      print(e);
    }
  }

  Future<Null> makeFirstRequest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'my_lang_key';
      setState(() {
        language = prefs.getString(key) ?? '';
        if(language.contains("ru")){
          for_sourse = "Источник: ";
          best_com = "Лучшие Комментарии";
          setAnswer = "Ответить";
          allComments = "Все Комментарии";
          writeComment = "НАПИСАТЬ КОММЕНТАРИЙ";
        } else if(language.contains("uz")){
          for_sourse = "Манба: ";
          best_com = "Энг Яхши Фикрлар";
          setAnswer = "Жавоб";
          allComments = "Барча Изохлар";
          writeComment = "ЁРУМ КАДИРЛАЙСИЗ";
        } else if(language.contains("oz")){
          for_sourse = "Manba: ";
          best_com = "Eng yaxshi fikrlar";
          setAnswer = "Javob";
          allComments = "Barcha izohlar";
          writeComment = "YORUM QADRLAYSIZ";
        }
      });
    } catch(e){
      print(e);
    }
    try {
      var response = await http
          .get(Uri.encodeFull(url + id), headers: {"Accept": "application/json"});
      var responseCom = await http
          .get(Uri.encodeFull(commentURL + id), headers: {"Accept": "application/json"});
      var extractdata = json.decode(response.body);
      var extractdataCom = json.decode(responseCom.body);
      setState(() {
        total = extractdataCom["data"]["total"];
        comments = extractdataCom["data"]["comments"];
        shareText = extractdata["data"]["shareText"];
        data = extractdata["data"];
        imageWidth = extractdata["data"]["imageWidth"];
        imageHeight = extractdata["data"]["imageHeight"];
        coef = imageHeight/imageWidth;
        width = MediaQuery.of(context).size.width;
        heigth = coef*width;
        markdown = html2md.convert(data["details"]);

        List temp = data["tags"];
        tags = new List();
        for(int i = 0; i < temp.length && temp.length != 0; i++){
          tags.add(
              Row(
                children: <Widget>[
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.grey,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                      child: Text(temp[i]["title"]),
                    ),
                    onTap: (){
                      Search.searchingTAG = "\""+ temp[i]["title"] +"\"";
                      Navigator.pop(context);
                      Navigator.pushNamed(_buildContext, '/Search',);
                    },
                  ),
                  Container(width: 10,)
                ],
              )
          );
        }
      });
    } catch(e){
      print(e);
    }
  }

  _share() async{
    print("shareText: " + data["shareText"]);
    await Share.share(data["shareText"]);
  }

  @override
  void initState() {
    super.initState();
    //print(widget.id);
    setState(() {
      id = NewsDetailsScreen.idl;
    });
    makeFirstRequest();
  }

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
    setState(() {
      _buildContext = context;
    });
    try { tags = data["tags"];}
    catch(e){print(e);}
    return Scaffold(
      body: data != null ?
      RefreshIndicator(
        onRefresh: reloadRequest,
        child: ListView(
          children: <Widget>[
            Container(
              width: width,
              height: heigth,
              child: Scaffold(
                body:  DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(data["imageUrl"]), fit: BoxFit.cover),
                  ),
                  child: Container(
                    width: width,
                    height: heigth,
                    child: Column(
                      children: <Widget>[
                        Container(height: 30,),
                        Container(
                          height: 50,
                          child: Row(
                            children: <Widget>[
                              Container(width: 10,),
                              Container(
                                width: 50,
                                child: FloatingActionButton(
                                  onPressed: (){Navigator.pop(context);},
                                  child: Icon(Icons.arrow_back),
                                ),),
                              Container(width: width - 60,),
                            ],
                          ),
                        ),
                        Container(height: heigth-80,),
                      ],
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: _share,
                  child: Icon(Icons.share),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Text(
                  data["pubdateFormatted"],
                  style: TextStyle(color: Colors.grey, fontSize: 15)
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Text(
                  data["title"],
                  style: TextStyle(color: Colors.black87, fontSize: 17, fontStyle: FontStyle.normal, fontWeight: FontWeight.w800,)
              ),
            ),

            Container(height: 10,),

            Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row( children: tags.toList()),
              ),
            ),

            Container(height: 10,),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Row(
                children: <Widget>[
                  Text(
                      for_sourse,
                      style: TextStyle(color: Colors.grey, fontSize: 15)
                  ),
                  Text(
                      data["source"],
                      style: TextStyle(color: Colors.orangeAccent, fontSize: 15)
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Text(
                  data["announce"],
                  style: TextStyle(color: Colors.black87, fontSize: 15)
              ),
            ),

            Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child: MarkdownBody(
                  data: markdown,
                )
            ),

            Container(
              color: Colors.deepPurple,
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
              child: Center(
                child: Text(best_com, style: TextStyle(color: Colors.white, fontSize: 17)),
              ),
            ),

            total == 0 ?
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: Center(
                child: Text("Комментариев нет, будьте первым!",//TODO for different languages
                  style: TextStyle(color: Colors.blue, fontSize: 17),),
              ),
            )
                :
            Container(),

            Container(
              child: ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: comments.length,
                  itemBuilder: (context, i){
                    var ratingColor;
                    if(comments[i]["rating"] > 0) ratingColor = Colors.green[600];
                    else if(comments[i]["rating"] < 0) ratingColor = Colors.red[400];
                    else ratingColor = Colors.black54;
                    return Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    //color: Colors.red,
                                    child: Text(comments[i]["name"].toString(),
                                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
                                    alignment: Alignment(0.0, 0.0),
                                  ),
                                  Container(
                                    //color: Colors.blue,
                                    child: Text(readTimestamp(comments[i]["added"]), style: TextStyle(color: Colors.black87)),
                                  )
                                ],
                              ),

                              Container(height: 10,),

                              comments[i]["answerFor"] == null ?
                              Container()
                                  :
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text("Ответил:  "),
                                      Text(comments[i]["answerName"].toString(),
                                        style: TextStyle(color: Colors.blue),)
                                    ],
                                  ),

                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                    alignment: Alignment(-1, 0),
                                    color: Colors.grey[300],
                                    child: Text(comments[i]["answerText"].toString()),
                                  ),

                                  Container(height: 10,)
                                ],
                              ),

                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                alignment: Alignment(-1, 0),
                                child: Text(comments[i]["text"].toString()),
                              ),
                            ],
                          ),
                        ),

                        DrawerScaleIcon.is_authorizated ?
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              InkWell(
                                child: Text(setAnswer,
                                  style: TextStyle(color: Colors.blue, fontSize: 17),),
                                onTap: (){
                                  print("TODO");
                                },
                              ),

                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.add, color: Colors.green[600],),
                                    Container(width: 4,),
                                    Text(comments[i]["rating"].toString(),
                                      style: TextStyle(fontSize: 16, color: ratingColor),),
                                    Container(width: 4,),
                                    Icon(Icons.remove, color: Colors.red[400]),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                            :
                        Container(),

                        Divider(
                          height: 10.0,
                        ),
                      ],
                    );
                  }
              ),
            ),

            Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                  )
              ),
              child: InkWell(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.list, color: Colors.blue,),
                      Text(allComments, style: TextStyle(color: Colors.blue, fontSize: 17),),
                      Text(" (", style: TextStyle(color: Colors.blue, fontSize: 17),),
                      Text(total.toString(), style: TextStyle(color: Colors.blue, fontSize: 17),),
                      Text(") ", style: TextStyle(color: Colors.blue, fontSize: 17),),
                    ],
                  ),
                ),

                onTap: (){
                  CommentsScreen.id = id;
                  Navigator.pushNamed(context, '/Comments', arguments: id);
                },
              ),
            ),

            Container(height: 10,),

            DrawerScaleIcon.is_authorizated ?
            Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                color: Colors.deepPurple,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.add, color: Colors.white,),
                      Container(width: 10,),
                      Text(writeComment, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),),
                    ]
                )
            )
                :
            Container(
                child: InkWell(
                  child: Center(
                    child: Text("You are not autorizated to write comment!",
                      style: TextStyle(color: Colors.blue, fontSize: 17),),
                  ),

                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      '/Auth',
                    );
                  },
                )
            ),

            Container(height: 10,),
          ],
        ),
      )
          :
      Center(child: CircularProgressIndicator())
    );
  }
}