import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/getting_weather_data/interpretting_data.dart';
import 'package:http/http.dart' as http;

import 'package:weather_app/globals.dart'
    as globals; // FOR TESTING ONLY - remove later

class ImportingWeather {
  static const BASE_URL =
      "https://api.openweathermap.org/data/2.5/weather"; // NEED TO REMEMBER TO HAVE "api." in front of url or doesn't work
  final String apiKey =
      "b98f0bd6a2c34c2a31f39b38ec1bddcb"; //personal api key that got from https://openweathermap.org/

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(Uri.parse(
        '$BASE_URL?q=$cityName&appid=$apiKey&units=metric')); // Goes to the base url but specifies it to the chosen city and uses the api key to do that. (Obviously units=metric is so we get metric units)

    print(
        "TESTING1: API Response Status Code: ${response.statusCode}"); //FOR TESTING
    print("TESTING2: API Response Body: ${response.body}"); //FOR TESTING

    if (response.statusCode == 200) {
      //if we get a response then it decodes the json
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          "Failed to load weather data"); //if no response then throws exception
    }
  }

  Future<String> getCurrentCity() async {
    //Getting location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //Get current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    globals.coordinates = "${position.latitude}, ${position.longitude}";

    // converting location to a placemark then converting that to a city
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    String? city =
        placemarks[0].locality; //gets the city of the first placemark

    return city ?? ""; //returns city name or blank string if city is null
  }
}
