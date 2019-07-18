import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:championat_asia_firstver/screens/gallary_screen/photo_screen/ItemGallary.dart';

class VideoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen>{

  static int current_page = 1;
  List data;
  String language = '';
  String url = 'https://championat.asia/api/gallery/videos?key=chmandroidappkey&language=';
  bool loading = true;

  Future<Null> makeRequest(pageNum) async {
    String url = 'https://championat.asia/api/gallery/videos?key=chmandroidappkey&language=' ;
    var response = await http
        .get(Uri.encodeFull(url + language + '&page=' + '${pageNum.toString()}'), headers: {"Accept": "application/json"});

    setState(() {
      print(response.statusCode);
      var extractdata = json.decode(response.body);
      if(data == null){
        data = extractdata["data"]["list"];
      } else {
        data.addAll(extractdata["data"]["list"]);
      }
      loading = false;
    });
  }

  Future<Null> reloadRequest() async {
    String url = 'https://championat.asia/api/gallery/videos?key=chmandroidappkey&language=' ;
    var response = await http
        .get(Uri.encodeFull(url + language + '&page=1'), headers: {"Accept": "application/json"});

    setState(() {
      print(response.statusCode);
      var extractdata = json.decode(response.body);
      data = extractdata["data"]["list"];
      loading = false;
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
          .get(Uri.encodeFull(url + language +'&page=1'), headers: {"Accept": "application/json"});
      setState(() {
        print(response.statusCode);
        var extractdata = json.decode(response.body);
        if(data == null){
          data = extractdata["data"]["list"];
        } else {
          data.addAll(extractdata["data"]["list"]);
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
    current_page = 1;
    this.makeFirstRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
            onRefresh: reloadRequest,
            child: loading ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (BuildContext context, i) {
                  if(i == data.length - 5){
                    current_page ++;
                    this.makeRequest(current_page);
                  }
                  return GallaryItem(post: data[i]);
                }
            )
        )
    );
  }

}