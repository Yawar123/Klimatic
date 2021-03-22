import 'package:flutter/material.dart';
import '../util/utils.dart' as util;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  String _cityEntered;

  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context)
        .push(new MaterialPageRoute<Map>(builder: (BuildContext) {
      return new ChangeCity();
    }));

    if (results != null && results.containsKey('enter')) {
      _cityEntered = results['enter'];
      print(results['enter'].toString());
    }
  }

  // void showStuff() async {
  //   Map data = await getWeather(util.apiId, util.defaulCity);
  //   //print(data.toString());
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Klimatic'),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.menu),
            onPressed: () {
              _goToNextScreen(context);
            },
          )
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              'images/umbrella.png',
              width: 490,
              height: 1200,
              fit: BoxFit.fill,
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: new Text(
              '${_cityEntered == null ? util.defaulCity : _cityEntered}',
              style: cityStyle(),
            ),
          ),
          new Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(12.0, 12.0, 0.0, 0.0),
            child: new Image.asset('images/light_rain.png'),
          ),
          new Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(30.0, 300.0, 0.0, 0.0),
            child: updateTempWidget(_cityEntered),
          )
        ],
      ),
    );
  }

  Future<Map> getWeather(String apiId, String city) async {
    String apiUrl =
        "http://api.openweathermap.org/data/2.5/weather?q=$city&APPID="
        "${util.apiId}&units=metric";

    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(
        future: getWeather(util.apiId, city == null ? util.defaulCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return new Container(
              child: new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text(
                      content['main']['temp'].toString() + " C",
                      style: new TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 50.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    subtitle: new ListTile(
                      title: new Text(
                        "Humidity : ${content['main']['humidity'].toString()}\n"
                        "Min : ${content['main']['temp_min'].toString()} C\n"
                        "Max : ${content['main']['temp_max'].toString()} C\n",
                        style: extraData(),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return new Container();
          }
        });
  }
}

class ChangeCity extends StatelessWidget {
  var _cityFieldController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text('Change City'),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset('images/white_snow.png',
                width: 490.0, height: 1200.0, fit: BoxFit.fill),
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: 'Enter City',
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),
              new ListTile(
                title: new FlatButton(
                  onPressed: () {
                    Navigator.pop(
                        context, {'enter': _cityFieldController.text});
                  },
                  textColor: Colors.white70,
                  color: Colors.redAccent,
                  child: new Text('Get Weather'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

TextStyle cityStyle() {
  return new TextStyle(
      color: Colors.white, fontSize: 22.9, fontStyle: FontStyle.italic);
}

TextStyle extraData() {
  return new TextStyle(
      color: Colors.white70, fontSize: 17.9, fontStyle: FontStyle.normal);
}

TextStyle tempStyle() {
  return new TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 49.9,
      fontStyle: FontStyle.normal);
}
