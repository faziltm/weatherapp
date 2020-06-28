import 'package:flutter/material.dart';
import 'package:wheatherapp/ui/main/main_screen.dart';
import 'package:wheatherapp/ui/home/home_screen.dart';
import 'package:wheatherapp/ui/undermaintanance/under_maintanance_screen.dart';
import 'package:wheatherapp/ui/update/update_screen.dart';
import 'package:wheatherapp/auth/baseauth.dart';
import 'package:wheatherapp/util/util.dart';
import 'package:wheatherapp/util/log.dart';
import 'package:wheatherapp/ui/signup/signup_main.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  bool isInDebugMode=true;

     FlutterError.onError = (FlutterErrorDetails details) {
    if (isInDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);


    } else {
      // In production mode report to the application zone to report to
      // Crashlytics.

    }
  };

    void homeMain(bool isUser){

 runApp(new MaterialApp(
  home: 
  isUser? HomeScreen(auth: new Auth()):SignupMainScreen(auth: new Auth()),
  //MainScreen(auth: new Auth()),
  routes: <String, WidgetBuilder>{
    
    '/SignupScreen': (BuildContext context) => new MainScreen(auth: new Auth()),
    '/HomeScreen': (BuildContext context) => new HomeScreen(auth: new Auth()),
  },
));
  }



void checkUser(){
      Auth().getCurrentUser().then((user){

      if(user !=null){
        homeMain(true);

      } else{
        homeMain(false);
      }

    }).catchError((onError){
      homeMain(false);

    });
}

  void updateMain(){
  runApp(
  UpdateScreen());
  }

  void undermanitenanceMain(String undermaintananceText){
    runApp(UnderMaintananceScreen(message: undermaintananceText,));
  }



  Auth().getFirestore()
  .collection("app-config")
  .document("android").collection('version')
  .document(Util.VERSIONCODE).get().then((onValue){

      bool status=onValue.data['status']??true;
      bool statusUndermaintanance=onValue.data['undermaintanance']??true;
      String undermaintananceText=onValue.data['undermaintananceText']??"";

      if(status&&!statusUndermaintanance){
        checkUser();
      } else if(status&&statusUndermaintanance){
        undermanitenanceMain(undermaintananceText);
      } else if(!status){
        updateMain();
      }else{
        checkUser();
      }
  }).catchError((onError){

    AppLog().log("main onError:"+onError.toString());
      checkUser();
  });





}