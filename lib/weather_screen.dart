import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  WeatherScreenState createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen> {
  String apiKey = 'b1f4d982c1123b90d430f0897e7df604';
  String city = 'Panama City';
  String weather = 'Loading...';
  String iconCode = '';
  String humidity = '';
  String windSpeed = '';
  Color backgroundColor = Colors.blueAccent;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    try {
      final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        double temp = (data['main']['temp'] as num).toDouble();
        setState(() {
          weather = "${data['weather'][0]['description']} - ${temp.toStringAsFixed(1)}°C";
          iconCode = data['weather'][0]['icon'];
          humidity = data['main']['humidity'].toString();
          windSpeed = data['wind']['speed'].toString();
          backgroundColor = data['weather'][0]['main'] == 'Rain' ? Colors.grey : Colors.blueAccent;
        });
      } else {
        throw Exception('Failed to load weather');
      }
    } catch (e) {
      setState(() {
        weather = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: fetchWeather,
        child: Container(
          color: backgroundColor,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a city',
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        city = value;
                        weather = 'Loading...';
                      });
                      fetchWeather();
                    },
                  ),
                  SizedBox(height: 20),
                  iconCode.isNotEmpty
                      ? Image.network('https://openweathermap.org/img/wn/$iconCode@2x.png')
                      : Icon(Icons.wb_sunny, size: 100, color: Colors.orangeAccent),
                  SizedBox(height: 20),
                  Text(
                    weather,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.water_drop),
                      title: Text('Humidity'),
                      subtitle: Text('$humidity%'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.air),
                      title: Text('Wind Speed'),
                      subtitle: Text('$windSpeed m/s'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
