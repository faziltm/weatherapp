import 'util.dart';

class AppLog{

  void log(String msg){
    if(Util.isDebugMode){
      print(msg);
    }
  }

}