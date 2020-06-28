import 'dart:convert';
import 'package:wheatherapp/model/location.dart';
import 'package:wheatherapp/model/current.dart';

class WheatherModel{

  Location location;
  Current current;

  WheatherModel({this.location, this.current});

  factory WheatherModel.fromJson(Map<String, dynamic> map) {
    return WheatherModel(
      location: Location.fromJsonLocation(map["location"]),
      current: Current.fromJsonCurrent(map["current"])
      );
  }


}


WheatherModel getWheatherFromJson(String jsonData) {
  final data = json.decode(jsonData);



  return WheatherModel.fromJson(data);
}


