import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:min_weather/models/pages/weather_models.dart';
import 'package:min_weather/service/pages/service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService =
      WeatherService(apiKey: 'b609d4a45240a4c8c4f1c4e45172dca3');
  Weather? _weather;
  bool _isLoading = false; // Loading state

  //fetch weather
  _fetchWeather() async {
    setState(() {
      _isLoading = true; // Set loading state to true when fetching starts
    });

    String cityName = await _weatherService.getCurrentCity();

    //get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading =
            false; // Set loading state to false when fetching is complete
      });
    }
  }

  //weather animations
  String getWeatherAnimations(String? mainCondition) {
    switch (mainCondition?.toLowerCase()) {
      // Converting to lowercase to avoid case mismatch
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json'; // Cloudy animation for all these conditions
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json'; // Rainy animation
      case 'thunderstorm':
        return 'assets/thunderstorm.json'; // Thunderstorm animation
      case 'clear':
        return 'assets/sunny.json'; // Sunny animation
      default:
        return 'assets/sunny.json'; // Default to sunny animation
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Min Weather'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading) // Show CircularProgressIndicator when loading
              CircularProgressIndicator(),
            if (!_isLoading) ...[
              Text(_weather?.cityName ?? 'Loading city...'),
              Lottie.asset(getWeatherAnimations(_weather?.mainCondition)),
              Text(
                _weather?.mainCondition ?? "",
              ),
              Text('${_weather?.temperature?.round() ?? ''}°C'),
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: ElevatedButton(
          onPressed: _fetchWeather,
          child: Text('Refresh'),
        ),
      ),
    );
  }
}
