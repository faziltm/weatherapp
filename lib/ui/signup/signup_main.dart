import 'package:flutter/material.dart';
import 'package:wheatherapp/auth/baseauth.dart';
import 'package:wheatherapp/ui/signup/signup.dart';
import 'package:wheatherapp/ui/login/login.dart';



class SignupMainScreen extends StatelessWidget {
  SignupMainScreen({Key key,this.auth}): super(key: key);

  final BaseAuth auth;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(top:25.0,left:10.0,right: 10.0),
              ),

              new Container(
                padding: EdgeInsets.only(top:25.0,left:10.0,right: 10.0),
                child: new Text("Weather App",style: new TextStyle(fontSize: 22),),
              ),

              new Container(
                    padding: EdgeInsets.only(top:5.0,bottom: 10.0,left: 30.0,right: 30.0),
                    child:Image.asset("assets/wheather.png",height: MediaQuery.of(context).size.height*0.30),),
              
              new Container(
                child:new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0)),
            color: Colors.blue,
            child: new Text('Sign Up' ,
                style: new TextStyle( color: Colors.white)),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen(auth: this.auth,)));
            },
          ),
        )),
                  new SizedBox(width: 10.0,),
              new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0)),
            color: Colors.blue,
            child: new Text('Login' ,
                style: new TextStyle( color: Colors.white)),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(auth: this.auth,)));
            },
          ),
        )),

                ],)
              )

            ],
          ),
        ),
      ),
    );

  }

}