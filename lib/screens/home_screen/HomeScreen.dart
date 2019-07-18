import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'package:championat_asia_firstver/screens/match_screen/MatchDetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:championat_asia_firstver/screens/home_screen/MatchesItemWidget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:championat_asia_firstver/screens/home_screen/ItemNews.dart';
import 'package:championat_asia_firstver/screens/home_screen/NewsDetails.dart';

class HomeScreen extends StatefulWidget { // ignore: must_be_immutable
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

// Создаём состояние виджета
class _HomeScreenState extends State<HomeScreen> {
  // ignore: non_constant_identifier_names
  //Home data_for_homescreen;
  String url = 'https://championat.asia/api/home?language=';
  String language = '';
  List news;
  List nextGames;
  List hotNews;
  List recommendedNews;
  List interviews;

  // Инициализация состояния
  @override
  void initState() {
    super.initState();
    makeRequest();
  }

  // ignore: missing_return
  Future<String> makeRequest() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'my_lang_key';
      setState(() {
        language = prefs.getString(key) ?? '';
        url += language;
      });
    } catch(e){
      print(e);
    }

    try {
      var response = await http
          .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
      final parsed = json.decode(response.body);
      setState(() {
        news = parsed["data"]["news"];
        nextGames = parsed["data"]["nextGames"];
        hotNews = parsed["data"]["hotNews"];
        recommendedNews = parsed["data"]["recommendedNews"];
        interviews = parsed["data"]["interviews"];
      });
    } catch(e){
      print(e);
    }
  }

  // ignore: missing_return
  Future<String> reloadRequest() async {
    try {
      var response = await http
          .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
      final parsed = json.decode(response.body);
      setState(() {
        news = parsed["data"]["news"];
        nextGames = parsed["data"]["nextGames"];
        hotNews = parsed["data"]["hotNews"];
        recommendedNews = parsed["data"]["recommendedNews"];
        interviews = parsed["data"]["interviews"];
      });
    } catch(e){
      print(e);
    }
  }

  // Формирование виджета
  @override
  Widget build(BuildContext context) {
    String for_title = "FootBall News";
    String for_title1 = "Interviews";
    if(language.contains("ru")){
      for_title = "Футбольные Новости";
      for_title1 = "Интервью";
    } else if(language.contains("uz")){
      for_title = "Футбол Янгиликлари";
      for_title1 = "Интервьюлар";
    } else if(language.contains("oz")){
      for_title = "Futbol yangiliklari";
      for_title1 = "Intervyular";
    }

    return news != null && nextGames != null ? Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: reloadRequest,

          child:  ListView(
            children: <Widget>[
              Container(
                child: ListView.builder(
                  itemCount: nextGames.length + 1,
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, position) {
                    if(position < nextGames.length){
                      return InkWell(
                          child: MatchesItemWidget(post: nextGames[position]),
                          onTap: () {
                            MatchDetails.logoName = nextGames[position]["homeTeam"].toString() + " - " + nextGames[position]["awayTeam"].toString();
                            MatchDetails.type = nextGames[position]["type"].toString();
                            MatchDetails.id = nextGames[position]["id"].toString();
                            Navigator.pushNamed(context, '/MatchDetails');
                          },
                        );
                    } else {
                      return InkWell(
                            splashColor: Colors.black87,
                            child: OtherMatches(context, language),
                            onTap: () {
                          // Navigate to the second screen using a named route
                              Navigator.pushNamed(context, '/Match');
                            },
                        );
                    }
                  },
                ),
              ),

              Container(height: 3),

              CarouselSlider(
                aspectRatio: 16/9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: false,
                enlargeCenterPage: false,
                height: 0.85 * MediaQuery.of(context).size.width,
                items: hotNews.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return InkWell(
                          child: HotNews(post: i),
                          onTap: () {
                            // Navigate to the second screen using a named route
                            NewsDetailsScreen.idl =i["id"].toString();
                            Navigator.pushNamed(
                              context,
                              NewsDetailsScreen.routeName,
                              arguments: NewsDetailsScreenArguments(
                                  i["id"].toString()
                              ),
                            );
                          },
                        );
                    },
                  );
                }).toList(),
              ),

              Container(height: 8),

              Container(
                width: 20,
                child: Text(
                    "  " + for_title,
                    style: TextStyle(color: Colors.red[400], fontStyle: FontStyle.normal, fontSize: 16, fontWeight: FontWeight.bold,)
                ),
              ),

              Container(height: 3),

              Container(
                child: ListView.builder(
                   shrinkWrap: true,
                   primary: false,
                   itemCount: news == null ? 0 : news.length + 1,
                   itemBuilder: (BuildContext context, i) {
                     if(i < news.length) {
                       return
                           InkWell(
                               child: PostWidget(post: news[i]),
                               onTap: () {
                                 // Navigate to the second screen using a named route
                                 NewsDetailsScreen.idl = news[i]["id"].toString();
                                 Navigator.pushNamed(
                                   context,
                                   NewsDetailsScreen.routeName,
                                   arguments: NewsDetailsScreenArguments(
                                       news[i]["id"].toString()
                                   ),
                                 );
                               },
                             );
                     } else return InkWell(
                           splashColor: Colors.black87,
                           child: OtherNews(context, language),
                           onTap: () {
                             // Navigate to the second screen using a named route
                             Navigator.pushNamed(context, '/News');
                           },
                         );
                   }
               ),
              ),

              Container(height: 3),

              CarouselSlider(
                aspectRatio: 16/9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: false,
                //autoPlayInterval: Duration(seconds: 3),
                //autoPlayAnimationDuration: Duration(milliseconds: 800),
                //pauseAutoPlayOnTouch: Duration(seconds: 10),
                enlargeCenterPage: false,
                height: 0.85 * MediaQuery.of(context).size.width,
                items: recommendedNews.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return InkWell(
                          child: HotNews(post: i),
                          onTap: () {
                            // Navigate to the second screen using a named route
                            NewsDetailsScreen.idl =i["id"].toString();
                            Navigator.pushNamed(
                              context,
                              NewsDetailsScreen.routeName,
                              arguments: NewsDetailsScreenArguments(
                                  i["id"].toString()
                              ),
                            );
                          },
                        );
                    },
                  );
                }).toList(),
              ),

              Container(height: 8),

              Container(
                width: 20,
                child: Text(
                    "  " + for_title1,
                    style: TextStyle(color: Colors.red[400], fontStyle: FontStyle.normal, fontSize: 16, fontWeight: FontWeight.bold,)
                ),
              ),

              Container(height: 3),

              Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: interviews == null ? 0 : interviews.length,
                    itemBuilder: (BuildContext context, i) {

                      return InkWell(
                        child: HotNews(post: interviews[i]),
                        onTap: (){
                          NewsDetailsScreen.idl = interviews[i]["id"].toString();
                          Navigator.pushNamed(
                            context,
                            NewsDetailsScreen.routeName
                          );
                        },
                      );
                    }
                ),
              ),

              Container(height: 3),
            ],
          )
        ),
    ) : Center(child: CircularProgressIndicator());
  }

}

/**/