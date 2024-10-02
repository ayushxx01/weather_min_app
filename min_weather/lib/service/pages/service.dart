import 'dart:convert'; // Importing the dart:convert library for JSON encoding and decoding

import 'package:geocoding/geocoding.dart'; // Importing the geocoding package for reverse geocoding
import 'package:geolocator/geolocator.dart'; // Importing the geolocator package for location services

import '../../models/pages/weather_models.dart'; // Importing the weather models
import 'package:http/http.dart'
    as http; // Importing the http package for making HTTP requests

class WeatherService {
  static const BASE_URL =
      'https://api.openweathermap.org/data/2.5/weather'; // Base URL for the weather API
  final String apiKey; // API key for the weather service

  WeatherService(
      {required this.apiKey}); // Constructor to initialize the WeatherService with the API key

  // Method to get weather data for a given city name
  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(Uri.parse(
        '$BASE_URL?q=$cityName&appid=$apiKey&units=metric')); // Making a GET request to the weather API

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response
          .body)); // Parsing the JSON response and returning a Weather object
    } else {
      throw Exception(
          'Failed to load weather data'); // Throwing an exception if the request fails
    }
  }

  // Method to get the current city name based on the device's location
  Future<String> getCurrentCity() async {
    LocationPermission permission =
        await Geolocator.checkPermission(); // Checking location permissions
    if (permission == LocationPermission.denied) {
      permission = await Geolocator
          .requestPermission(); // Requesting location permissions if denied
    }

    // Getting the current position with high accuracy
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Getting the placemarks (address details) from the coordinates
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // Extracting the city name from the placemarks
    String? city = placemarks[0].locality;

    return city ?? ""; // Returning the city name or an empty string if null
  }
}
