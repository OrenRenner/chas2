import 'dart:convert';
import 'package:championat_asia_firstver/drawer_scale_icon.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Authorization extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _AuthorizationState();
  }
}

class _AuthorizationState extends State<Authorization> {

  bool is_authorizated = DrawerScaleIcon.is_authorizated;
  bool loading = false;
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  BuildContext unContext;
  String errorMes = "";

  sign_out() async{
      final prefs = await SharedPreferences.getInstance();
      final key = 'token';
      final value = "";
      prefs.setString(key, value);
      DrawerScaleIcon.is_authorizated = false;
      Navigator.of(unContext).pop();
      Navigator.of(unContext).pushReplacementNamed("/App");
  }

  // ignore: missing_return
  Future<String> sign_in() async{
    setState(() {
      loading = true;
    });
    try{
      Map data = {
        "username": loginController.text,
        "password": passwordController.text
      };
      //encode Map to JSON
      var response = await http
          .post(
          Uri.encodeFull("https://championat.asia/api/user/login"),
          headers: {"Accept": "application/json", "User-Agent": "mobileapp  /devAgentMxm"},
          body: data);

      var status = json.decode(response.body);
      if(response.statusCode == 200 && status["status"].toString().contains("ok")){
        final prefs = await SharedPreferences.getInstance();
        final key = 'token';
        final value = response.body;
        prefs.setString(key, value);
        DrawerScaleIcon.is_authorizated = true;
        print(response.body);

        Navigator.of(unContext).pop();
        Navigator.of(unContext).pushReplacementNamed("/App");
      } else{
        setState(() {
          errorMes = "Wrong Login or Password";
          loading = false;
        });
      }
    }catch(e){
      final prefs = await SharedPreferences.getInstance();
      final key = 'token';
      final value = "";
      prefs.setString(key, value);
      DrawerScaleIcon.is_authorizated = false;
      setState(() {
        errorMes = "Wrong Login or Password";
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Authorization is " + is_authorizated.toString());
    setState(() {
      unContext = context;
    });

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/chas.png'),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: loginController,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: passwordController,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: sign_in,
        padding: EdgeInsets.all(12),
        color: Colors.deepPurple,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: (){},
    );

    return
    is_authorizated ?
      Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: sign_out,
              padding: EdgeInsets.all(12),
              color: Colors.deepPurple,
              child: Text('Log Out', style: TextStyle(color: Colors.white)),
            ),
          )
        )
      )
    :
      Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.white,
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              logo,
              SizedBox(height: 48.0),
              email,
              SizedBox(height: 8.0),
              password,
              SizedBox(height: 24.0),
              loginButton,
              forgotLabel,
              loading ? Center(child: CircularProgressIndicator()) : Container(),
              Text(errorMes, style: TextStyle(color: Colors.redAccent, fontSize: 17),)
            ],
          ),
        ),
      );
  }
}
