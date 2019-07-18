import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PhotoDetailsScreen extends StatefulWidget {
  static const routeName = '/PhotoDetails';
  static String idl;

  @override
  State<StatefulWidget> createState() => _PhotoDetailsScreenState();
}

class _PhotoDetailsScreenState extends State<PhotoDetailsScreen>{
  // ignore: non_constant_identifier_names
  static int current_page = 1;
  String language = '';
  var data;
  String url = 'https://championat.asia/api/gallery/photo?id=';
  int imageHeight;
  int imageWidth;
  String id;
  List photos;

  Future<Null> reloadRequest() async {
    var response = await http
        .get(Uri.encodeFull(url + id), headers: {"Accept": "application/json"});
    var extractdata = json.decode(response.body);

    setState(() {
      data = extractdata["data"];
      photos = data["photos"];
    });
  }

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
          .get(Uri.encodeFull(url + id), headers: {"Accept": "application/json"});
      var extractdata = json.decode(response.body);
      setState(() {
        data = extractdata["data"];
        photos = data["photos"];
      });
      print(data.toString());
    } catch(e){
      print(e);
    }
  }


  @override
  void initState() {
    super.initState();
    //print(widget.id);
    setState(() {
      id = PhotoDetailsScreen.idl;
    });
    makeFirstRequest();
  }

  @override
  Widget build(BuildContext context) {
    return data != null ? Scaffold(

        body: RefreshIndicator(
          onRefresh: reloadRequest,
          child: Scaffold(
            appBar: AppBar(
              title: Text(data["gallery"]["title"]),
            ),
            body: ListView.builder(
                itemCount: data == null ? 0 : photos.length,
                itemBuilder: (BuildContext context, i){
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Image.network(photos[i]["source"]["uri"]),
                        Divider( height: 20.0,),
                      ],
                    ),
                  );
                }
            ),

            floatingActionButton: FloatingActionButton(
              onPressed: ()=> debugPrint("Hello!"),
              child: Icon(Icons.comment),),
          ),
        )
    ) : Center(child: CircularProgressIndicator());
  }
}

