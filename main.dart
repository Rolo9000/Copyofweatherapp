import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/getting_weather_data/importing_weather.dart';
import 'package:weather_app/getting_weather_data/interpretting_data.dart';

import 'package:weather_app/globals.dart'
    as globals; // FOR TESTING ONLY - remove later

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 153, 108, 229)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Weather home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // variables/functions to do stuff here

  // Adding weather service that created in "importing_weather.dart"
  final _importingWeather = ImportingWeather();
  Weather? _weather;
  String _cityName =
      "Loading City..."; // Default value before fetching the city

  // getting weather data
  _fetchWeather() async {
    // getting city
    String cityName = await _importingWeather.getCurrentCity();
    setState(() {
      _cityName = cityName;
    });
    // getting weather for that city
    try {
      final weather = await _importingWeather.getWeather(cityName);
      setState(() {
        //updates state of widget
        _weather = weather;
        print("TESTING: ${_weather?.cityName}"); // TESTING ONLY
      });
    } catch (e) {
      // if any errors - prints to console. --> Will need to change this later
      print(e);
    }
  }

  @override

  // Gets weather when app starts up
  void initState() {
    super.initState();

    _fetchWeather();
    print("TESTING3: ${_weather?.cityName}"); // TESTING ONLY
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    var location =
        _cityName; // ?? "Loading City..."; // --> set the default value below instead
    var temperature = _weather?.temperature.toString();
    var condition = _weather?.condition;
    final theme = Theme.of(context);
    print("TESTING4: ${_weather?.cityName}"); // TESTING ONLY
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.only(
                  top: 15.0,
                  bottom: 18.0,
                  left: 7.5,
                  right: 7.5,
                ),
                child: LocationCard(theme: theme, location: location)),
            PrimaryInformation(
              theme: theme,
              temperature: temperature ?? "-",
              condition: condition ?? "error",
            ),
            Cards(
              theme: theme,
              weather: _weather,
            ),
            InformationCard(
              text: "Coordinates",
              icon: (Icons.abc),
              information: globals.coordinates,
              theme: theme,
            ),
            creditInfo(
              theme: theme,
            ),
          ],
        ));
  }
}

class Cards extends StatelessWidget {
  const Cards({super.key, required this.theme, this.weather});

  final ThemeData theme;
  final Weather? weather;

  // Have to do the following for values that could be null so doesn't show null onscreen

  String windspeed() {
    if (weather?.windspeed == "null") {
      return "no \n wind ";
    } else {
      return weather?.windspeed ?? "no wind";
    }
  }

  String windgusts() {
    if (weather?.windgusts == "null") {
      return "no \n gusts";
    } else {
      return weather?.windgusts ?? "no gusts";
    }
  }

  String rain1h() {
    if (weather?.rainvol1h == "null") {
      return "no rain";
    } else {
      return weather?.rainvol1h ?? "no rain";
    }
  }

  String rain3h() {
    if (weather?.rainvol3h == "null") {
      return "no rain";
    } else {
      return weather?.rainvol3h ?? "no rain";
    }
  }

  String snow1h() {
    if (weather?.snowvol1h == "null") {
      return "no snow";
    } else {
      return weather?.snowvol1h ?? "no snow";
    }
  }

  String snow3h() {
    if (weather?.snowvol3h == "null") {
      return "no snow";
    } else {
      return weather?.snowvol3h ?? "no snow";
    }
  }

  String sunrise() {
    return weather?.sunrise ?? "error";
  }

  String sunset() {
    return weather?.sunset ?? "error";
  }

  String epochToNormalTime(String fromApi) {
    //sunset and sunrise are both given in epoch time (time since jan1 1970) so need to convert this to date format
    try {
      //needed because initially on startup hasnt collected the data so will throw an error
      int epochToConvert = int.parse(fromApi) *
          1000; //needs *1000 because itmestamp format is in Seconds (Unix timestamp) as opposed to microseconds
      DateTime now = DateTime.now();
      var currentEpoch = now.millisecondsSinceEpoch;
      int difference = currentEpoch - epochToConvert;
      DateTime convertedTime = now.subtract(Duration(milliseconds: difference));

      String formattedConvertedTime = convertedTime
          .toIso8601String(); //will have to add \n otherwise wont fit inside an information card
      List output = formattedConvertedTime.split("T"); //getting rid of date
      List outputB =
          output[1].split(":"); //getting rid of seconds/milli/micro seconds
      print(outputB);
      try {
        return (outputB[0] + ":" + outputB[1]) ?? "error";
      } catch (e) {
        return "error";
      }
    } catch (e) {
      print(e);
      return ("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding:
                const EdgeInsets.only(bottom: 0, top: 0, left: 25, right: 20),
            child: Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines
                children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      height: 115,
                      width: 160,
                      child: InformationCard(
                        text: "Feels Like",
                        icon: (Icons.sunny),
                        information: "${weather?.feelsLike.round() ?? "-"}°",
                        theme: theme,
                      )),
                  Container(
                      padding: const EdgeInsets.all(10),
                      height: 115,
                      width: 160,
                      child: InformationCard(
                        text: "Windspeed",
                        icon: (Icons.air_sharp),
                        information: "${windspeed()} m/s",
                        theme: theme,
                      )),
                  Container(
                      padding: const EdgeInsets.all(10),
                      height: 115,
                      width: 160,
                      child: InformationCard(
                        text: "Wind gusts",
                        icon: (Icons.air_sharp),
                        information: "${windgusts()} m/s",
                        theme: theme,
                      )),
                  Container(
                      padding: const EdgeInsets.all(10),
                      height: 115,
                      width: 160,
                      child: InformationCard(
                        text: "Pressure",
                        icon: (Icons.arrow_downward_sharp),
                        information: "${weather?.pressure ?? "-"} hPa",
                        theme: theme,
                      )),
                  Container(
                      padding: const EdgeInsets.all(10),
                      height: 115,
                      width: 160,
                      child: InformationCard(
                        text: "Visablity",
                        icon: (Icons.remove_red_eye_outlined),
                        information: "${weather?.visibility ?? "-"}m",
                        theme: theme,
                      )),
                  Container(
                      padding: const EdgeInsets.all(10),
                      height: 115,
                      width: 160,
                      child: InformationCard(
                        text: "Humidity",
                        icon: (Icons.water),
                        information: "${weather?.humidity ?? "-"}%",
                        theme: theme,
                      )),
                  Container(
                      padding: const EdgeInsets.all(10),
                      height: 115,
                      width: 160,
                      child: InformationCard(
                        text: "Sunrise",
                        icon: (Icons.wb_sunny_outlined),
                        information: "${epochToNormalTime(sunrise())} ",
                        theme: theme,
                      )),
                  Container(
                      padding: const EdgeInsets.all(10),
                      height: 115,
                      width: 160,
                      child: InformationCard(
                        text: "Sunset",
                        icon: (Icons.shield_moon),
                        information: "${epochToNormalTime(sunset())} ",
                        theme: theme,
                      )),
                  Container(
                      padding: const EdgeInsets.all(10),
                      height: 115,
                      width: 160,
                      child: InformationCard(
                        text: "Rain last\n hour",
                        icon: (Icons.water_drop_outlined),
                        information: "${rain1h()}mm",
                        theme: theme,
                      )),
                  Container(
                      padding: const EdgeInsets.all(10),
                      height: 115,
                      width: 160,
                      child: InformationCard(
                        text: "Rain last 3\n hours",
                        icon: (Icons.water_drop_outlined),
                        information: "${rain3h()}mm",
                        theme: theme,
                      )),
                  Container(
                      padding: const EdgeInsets.all(10),
                      height: 115,
                      width: 160,
                      child: InformationCard(
                        text: "Snow last\n hour",
                        icon: (Icons.cloudy_snowing),
                        information: "${snow1h()}mm",
                        theme: theme,
                      )),
                  Container(
                      padding: const EdgeInsets.all(10),
                      height: 115,
                      width: 160,
                      child: InformationCard(
                        text: "Snow last 3\n hours",
                        icon: (Icons.cloudy_snowing),
                        information: "${snow3h()}mm",
                        theme: theme,
                      ))
                ])));
  }
}

class LocationCard extends StatelessWidget {
  const LocationCard({super.key, required this.theme, required this.location});

  final String location;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: theme.colorScheme.inversePrimary,
        child: Padding(
            padding: const EdgeInsets.all(7.5),
            child: Row(children: [
              const Icon(Icons.location_pin),
              const Text("   "),
              Text(location)
            ])));
  }
}

class InformationCard extends StatelessWidget {
  const InformationCard(
      {super.key,
      required this.text,
      required this.icon,
      required this.information,
      required this.theme});

  final String text;
  final IconData icon;
  final String information;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: theme.colorScheme.inversePrimary,
        child: Padding(
            padding: const EdgeInsets.all(7.5),
            child: Row(children: [
              Icon(icon),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        text,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(information)
                  ],
                ),
              )
            ])));
  }
}

class PrimaryInformation extends StatelessWidget {
  const PrimaryInformation(
      {super.key,
      required this.theme,
      required this.temperature,
      required this.condition});

  final ThemeData theme;
  final String temperature;
  final String condition;

  //Weather animation
  String getWeatherAnimation(String? condition) {
    switch (condition?.toLowerCase()) {
      case "snow":
        return "animations/snowy.json";
      case "clouds":
      case "mist":
      case "smoke":
      case "haze":
      case "dust":
      case "fog":
        return "animations/cloudy.json";
      case "rain":
      case "drizzle":
      case "shower rain":
        return "animations/rainy.json";
      case "thunderstorm":
        return "animations/stormy.json";
      case "clear":
        return "animations/sunny.json";
      default:
        return "animations/sunny.json";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    // Temp, highs, lows, time etc.
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "$temperature °C",
                      style: TextStyle(
                        fontSize: 40,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 6
                          ..color = Colors.blue[700]!,
                      ),
                    )),
                Container(
                    // Lottie animation
                    height: 150,
                    width: 200,
                    child: Lottie.asset(getWeatherAnimation(condition))),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                padding: EdgeInsets.only(left: 15.0, bottom: 8.0),
                child: Text("Now",
                    style: TextStyle(
                      fontSize: 15,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1.5
                        ..color = const Color.fromARGB(255, 0, 0, 0),
                    )),
              ),
              Container(
                //Condition
                padding: EdgeInsets.only(right: 160.0, bottom: 8.0),
                child: Text(
                  condition,
                  style: TextStyle(
                    fontSize: 25,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 2
                      ..color = const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              )
            ]),
          ],
        ),
      ),
    );
  }
}

class creditInfo extends StatelessWidget {
  const creditInfo({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: theme.colorScheme.primary,
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(width: 10, height: 150),
              Column(
                children: [
                  Text("Credit",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(" Made by Rohan Somaia for mgs high tarriff summer work")
                ],
              ),
            ],
          ),
        ));
  }
}
