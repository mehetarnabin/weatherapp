import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../util/utils.dart' as util;

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  void showStuff() async {
    Map data = await getWeather(util.appId, util.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Weather'),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.menu), onPressed: showStuff)
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              'images/rainy.jpg',
              height: 1000.0,
              width: 700.0,
              fit: BoxFit.fill,
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 5.9, 14.0, 0.0),
            child: new Text(
              'Biratnagar',
              style: cityStle(),
            ),
          ),
          new Container(
            alignment: Alignment.center,
            child: new Image.asset('images/light_rain.png'),
          ),
          //container which will have weather data
          new Container(
            margin: const EdgeInsets.fromLTRB(30.0, 350.0, 0.0, 0.0),
            child: updateTempWidget("Kathmandu"),
          ),
        ],
      ),
    );
  }

  Future<Map> getWeather(String appId, String city) async {
    String apiUrl =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid='
        '${util.appId}&units=metric';
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(
        future: getWeather(util.appId, city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          //where we get all of the json data, we setup widget etc.
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return new Container(
              child: new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text(content['main']['temp'].toString(),
                    style: new TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 49.9,
                      color: Colors.white,
                      fontWeight: FontWeight.w500
                    ),
                    ),
                  )
                ],
              ),
            );
          }
          else {
            return new Container();
          }
        });
  }
}

TextStyle cityStle() {
  return new TextStyle(
      color: Colors.white, fontSize: 22.9, fontStyle: FontStyle.italic);
}

TextStyle tempStyle() {
  return new TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: 49.9);
}
