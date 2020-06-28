class Location{
  String name;
  String locatTime;

  Location({this.name, this.locatTime});
  
  factory Location.fromJsonLocation(Map<String, dynamic> map) {
    return Location(
      name: map["name"]??"",
      locatTime: map["localtime"]??""
      );
  }
}