class Current{

  int tempraeture;
  int humidity;
  int feelslike;

  List<String> weatherIcons;
  dynamic weatherDescription;

  Current({this.tempraeture, this.weatherIcons, this.weatherDescription, this.humidity, this.feelslike});

  factory Current.fromJsonCurrent(Map<String, dynamic> map) {
    return Current(
      humidity: map["humidity"]??0,
      tempraeture: map["temperature"]??"",
      weatherIcons: map["weather_icons"].cast<String>(),
      weatherDescription: map["weather_descriptions"].cast<String>(),
      feelslike: map["feelslike"]??0
      );
  }
}

