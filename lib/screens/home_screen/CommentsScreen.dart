import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../drawer_scale_icon.dart';

class CommentsScreen extends StatefulWidget{
  static String id;

  @override
  State<StatefulWidget> createState() {
    return _CommenrsScreenState();
  }
}

class _CommenrsScreenState extends State<CommentsScreen>{
  final textController  = TextEditingController();
  String language;

  String appName = "";
  String best;
  String first;
  String latest;

  @override
  void initState() {
    super.initState();
    _read();
  }

  _read() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'my_lang_key';
      setState(() {
        language = prefs.getString(key) ?? 'en';
        if(language.contains("ru")){
          appName = "Комментарии";
          best = "Лучшие";
          first = "Первые";
          latest = "Последние";
        } else if(language.contains("uz")){
          appName = "Шархлар";
          best = "Енг яхшиси";
          first = "Биринчидан";
          latest = "Охирги";
        } else if(language.contains("oz")){
          appName = "Sharhlar";
          best = "Eng yaxshisi";
          first = "Birinchidan";
          latest = "Oxirgi";
        }
      });
    } catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(appName),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.star), text: best,),
              Tab(icon: Icon(Icons.arrow_upward), text: first,),
              Tab(icon: Icon(Icons.arrow_downward), text: latest,),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CommentView(sort: 'rating'),
            CommentView(sort: 'first'),
            CommentView(sort: 'latest'),
          ],
        ),

        bottomNavigationBar: BottomAppBar(
          child: DrawerScaleIcon.is_authorizated ?
              Container(
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      width: MediaQuery.of(context).size.width - 70,
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        controller: textController,
                        decoration: InputDecoration(
                          hintText: 'Your Comment',
                          //contentPadding:
                          //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      child: Icon(Icons.send),
                    )
                  ],
                )
              )
              :
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                child: InkWell(
                  child: Text("You are not autorizated to write comment!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blue, fontSize: 17),),

                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      '/Auth',
                    );
                  },
                )
              ),

        ),
      ),
    );
  }
}

class CommentView extends StatefulWidget{
  final String sort;

  CommentView({@required this.sort});

  @override
  State<StatefulWidget> createState() {
    return _CommentViewState();
  }
}

class _CommentViewState extends State<CommentView>{
  final String url = "https://championat.asia/api/comments/load?key=chmandroidappkey&type=news";
  final String id = "&id=" + CommentsScreen.id;
  String sort; //= "sort=" + widget.sort;
  int currentPage;
  String page; // = "page=" + currentPage.toString();

  bool hasMore;
  List commentsList;

  String setAnswer = "Answer";

  @override
  void initState() {
    super.initState();

    setState(() {
      sort = "&sort=" + widget.sort;
      page = "&page=" + currentPage.toString();
      currentPage = 0;

      hasMore = true;
    });

    makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return commentsList == null ?
    Center(child: CircularProgressIndicator())
    :
    RefreshIndicator(
      onRefresh: reloadRequest,
      child: Container(
        child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: commentsList.length,
            itemBuilder: (context, i){

              if(i == commentsList.length - 2 && hasMore){
                currentPage ++;
                page = "&page=" + currentPage.toString();
                this.makeRequest();
              }

              var ratingColor;
              if(commentsList[i]["rating"] > 0) ratingColor = Colors.green[600];
              else if(commentsList[i]["rating"] < 0) ratingColor = Colors.red[400];
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
                              child: Text(commentsList[i]["name"].toString(),
                                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
                              alignment: Alignment(0.0, 0.0),
                            ),
                            Container(
                              //color: Colors.blue,
                              child: Text(readTimestamp(commentsList[i]["added"]), style: TextStyle(color: Colors.black87)),
                            )
                          ],
                        ),

                        Container(height: 10,),

                        commentsList[i]["answerFor"] == null ?
                        Container()
                            :
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text("Ответил:  "),
                                Text(commentsList[i]["answerName"].toString(),
                                  style: TextStyle(color: Colors.blue),)
                              ],
                            ),

                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                              alignment: Alignment(-1, 0),
                              color: Colors.grey[300],
                              child: Text(commentsList[i]["answerText"].toString()),
                            ),

                            Container(height: 10,)
                          ],
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                          alignment: Alignment(-1, 0),
                          child: Text(commentsList[i]["text"].toString()),
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
                              Text(commentsList[i]["rating"].toString(),
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
    );
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

  Future<Null> reloadRequest() async{
    try{
      setState(() {
        commentsList.clear();
        currentPage = 0;
        page = "&page=" + currentPage.toString();
      });

      var response = await http
          .get(Uri.encodeFull(url + id + sort + page), headers: {"Accept": "application/json"});

      print(currentPage);
      setState(() {
        var extractdata = json.decode(response.body);
        if(commentsList == null){
          commentsList = extractdata["data"]["comments"];
        } else {
          commentsList.addAll(extractdata["data"]["comments"]);
        }
        hasMore = extractdata["data"]["hasMore"];
      });
    } catch(e){
      print(e);
    }
  }

  Future<Null> makeRequest() async {
    try{
      var response = await http
          .get(Uri.encodeFull(url + id + sort + page), headers: {"Accept": "application/json"});

      print(currentPage);
      setState(() {
        var extractdata = json.decode(response.body);
        if(commentsList == null){
          commentsList = extractdata["data"]["comments"];
        } else {
          commentsList.addAll(extractdata["data"]["comments"]);
        }
        hasMore = extractdata["data"]["hasMore"];
      });
    }catch(e){
      print(e);
    }
  }
}
