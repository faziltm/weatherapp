import 'package:flutter/material.dart';
import 'package:wheatherapp/auth/baseauth.dart';


class MainScreen extends StatelessWidget {
  MainScreen({Key key,this.auth}): super(key: key);

  final BaseAuth auth;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(),
    );

  }

}