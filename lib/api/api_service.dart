import 'package:http/http.dart' show Client;
import 'package:wheatherapp/util/util.dart';
import 'package:wheatherapp/model/wheather_model.dart';


class ApiService {
  final String baseUrl = Util.URL;
  Client client = Client();


  Future<WheatherModel> getWheather(String lat,String lon) async {


        final response = await client.get(
      "$baseUrl"+lat+","+lon,

      headers: {"content-type": "application/json"},
    );
    if (response.statusCode == 200) {

     
        return getWheatherFromJson(response.body);
    } else {
      return null;
    }

  }

}