class Weather {
  final String cityName;
  final double temperature;
  final String condition;
  final String pressure;
  final String humidity;
  final String visibility;
  final String windspeed;
  final String windgusts;
  final String rainvol1h;
  final String rainvol3h;
  final String snowvol1h;
  final String snowvol3h;
  final double feelsLike;
  final String sunrise; //keep these as strings
  final String sunset; //keep these as strings

  Weather(
      {required this.cityName,
      required this.condition,
      required this.temperature,
      required this.pressure,
      required this.humidity,
      required this.visibility,
      required this.windspeed,
      required this.windgusts,
      required this.rainvol1h,
      required this.rainvol3h,
      required this.snowvol1h,
      required this.snowvol3h,
      required this.feelsLike,
      required this.sunrise,
      required this.sunset});

  factory Weather.fromJson(Map<String, dynamic> json) {
    print(
        "IS THIS SHOWING? ${json["weather"][0]["main"]}"); // FOR TESTING - WORKED
    return Weather(
      cityName: json["name"] ?? "",
      condition: json["weather"][0]["main"] ?? "",
      temperature: (json["main"]["temp"]).toDouble(),
      pressure: (json["main"]["pressure"]).toString(),
      humidity: (json["main"]["humidity"]).toString(),
      visibility: (json["visibility"]).toString(),
      windspeed: (json["wind"]["speed"]).toString(),
      windgusts: (json["wind"]["gust"]).toString(),
      rainvol1h: (json["rain"]?["1h"]).toString(),
      rainvol3h: (json["rain"]?["3h"]).toString(),
      snowvol1h: (json["snow"]?["1h"]).toString(),
      snowvol3h: (json["snow"]?["3h"]).toString(),
      feelsLike: (json["main"]["feels_like"]).toDouble(),
      sunrise: (json["sys"]["sunrise"]).toString(),
      sunset: (json["sys"]["sunset"]).toString(),
    );
  }
}
