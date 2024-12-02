import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(WeatherApp());

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Consulta del Clima')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeatherByCoords()),
                );
              },
              child: Text('Consultar por Coordenadas'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeatherByCity()),
                );
              },
              child: Text('Consultar por Ciudad'),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherByCoords extends StatefulWidget {
  @override
  _WeatherByCoordsState createState() => _WeatherByCoordsState();
}

class _WeatherByCoordsState extends State<WeatherByCoords> {
  String? weatherInfo;

  Future<void> fetchWeather(double lat, double lon) async {
    final apiKey = '94ad184e3149a23b19f14f11bfac674e';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        weatherInfo =
            'Clima: ${data['weather'][0]['description']}\nTemp: ${data['main']['temp']}°C\nHumedad: ${data['main']['humidity']}%';
      });
    } else {
      setState(() {
        weatherInfo = 'Error al obtener el clima.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Clima por Coordenadas')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => fetchWeather(44.34, 10.99),
              child: Text('Consultar Clima'),
            ),
            if (weatherInfo != null) Text(weatherInfo!),
          ],
        ),
      ),
    );
  }
}

class WeatherByCity extends StatefulWidget {
  @override
  _WeatherByCityState createState() => _WeatherByCityState();
}

class _WeatherByCityState extends State<WeatherByCity> {
  String? weatherInfo;

  Future<void> fetchWeather(String city) async {
    final apiKey = '94ad184e3149a23b19f14f11bfac674e';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        weatherInfo =
            'Clima: ${data['weather'][0]['description']}\nTemp: ${data['main']['temp']}°C\nHumedad: ${data['main']['humidity']}%';
      });
    } else {
      setState(() {
        weatherInfo = 'Error al obtener el clima.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Clima por Ciudad')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onSubmitted: fetchWeather,
              decoration: InputDecoration(hintText: 'Ingrese nombre de la ciudad'),
            ),
            if (weatherInfo != null) Text(weatherInfo!),
          ],
        ),
      ),
    );
  }
}

