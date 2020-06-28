import 'package:flutter/material.dart';
import 'package:wheatherapp/auth/baseauth.dart';
import 'package:wheatherapp/ui/signup/signup_main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:android_intent/android_intent.dart';
import 'package:latlong/latlong.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wheatherapp/api/api_service.dart';
import 'package:wheatherapp/util/log.dart';
import 'package:wheatherapp/model/wheather_model.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen({Key key,this.auth}): super(key: key);
  final BaseAuth auth;


    @override
   _HomeScreenState createState() => new _HomeScreenState();


}

class _HomeScreenState extends State<HomeScreen> {

  var geoLocator = Geolocator();
  var status;
  Position position;

  bool locationLoading;
  bool errorStatus;
  String errorMsg;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  ApiService _apiService = ApiService();

  WheatherModel wheatherMode;


@override
  void initState() {
    // TODO: implement initState
    super.initState();

    locationLoading=true;
    errorStatus=false;

    


    checkLocationEnabled();

  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> checkLocationEnabled()async{

await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    bool isLocationEnabled = await Geolocator().isLocationServiceEnabled();

    if(isLocationEnabled){

      checkLocationPermission();


    } else {
      setState(() {
      errorStatus=true;
      errorMsg="Please make sure you enable GPS and try again";
    });
        showSnackBar(errorMsg);
    }


  }

  Future<void> checkLocationPermission()async{

    status = await geoLocator.checkGeolocationPermissionStatus();

      if (status == GeolocationStatus.denied) {
        setState(() {
          errorStatus=true;
          errorMsg="your location permission is denied";
        });
        showSnackBar(errorMsg);
        
      }else if (status == GeolocationStatus.disabled) {
        setState(() {
          errorStatus=true;
          errorMsg="your location permission is disabled";
        });
        showSnackBar(errorMsg);

      }else if (status == GeolocationStatus.restricted) {
       setState(() {
          errorStatus=true;
          errorMsg="your location permission is restricted";
        });
        showSnackBar(errorMsg);

      }else if (status == GeolocationStatus.unknown) {
        setState(() {
          errorStatus=true;
          errorMsg="your location permission is unknown";
        });
        showSnackBar(errorMsg);

      }else if (status == GeolocationStatus.granted) {
        retrievLocation();
      }

  }

  
    Future<void> retrievLocation()async{
      

      try{
      position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print("position: Location lattitude:"+position.latitude.toString());
      print("position: Location longitude:"+position.longitude.toString());


        

       fetchWheather(new LatLng(position.latitude,position.longitude));

    }catch(e) {

      print("Error occured: $e");
      setState(() {
          errorStatus=true;
          errorMsg="Facing problem for fetching location";
        });
        showSnackBar(errorMsg);
    }

    }

    fetchWheather(LatLng latLng){

        _apiService.getWheather(latLng.latitude.toString(),latLng.longitude.toString()).then((value){



            setState(() {
          locationLoading=false;
          errorStatus=false;
        });


            setState(() {
              wheatherMode=value;
            });
            
        }).catchError((onError){
            AppLog().log('onError1:'+onError.toString());
            errorMsg="Not getting data from server.";
            setState(() {
              locationLoading=false;
              errorStatus=true;
            });

        });
      
    }

  void showSnackBar(String message){

     final snackBar = SnackBar(
                content: Text(message+". Check your settings."),
                action: SnackBarAction(
                label: 'OK',
                onPressed: () {
                  final AndroidIntent intent = AndroidIntent(
                        action: 'android.settings.LOCATION_SOURCE_SETTINGS');

                    intent.launch();
                    Navigator.of(context, rootNavigator: true).pop();
                },
               ),
            );

            _scaffoldKey.currentState.showSnackBar(snackBar);
  }


  Future<Null> refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(milliseconds: 300));

    setState(() {
    locationLoading=true;
    errorStatus=false;
    });

    checkLocationEnabled();


    return null;
  }

  

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
          title: new Text('Home'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: (){signOut(context);})
          ],
        ),
      body: locationLoading? 
       Shimmer.fromColors(
    baseColor: Colors.grey[300],
    highlightColor: Colors.grey[50],
    child: Column(
      children: <Widget>[

        new Row(
          children: <Widget>[
            new Expanded(
              flex: 1,
              child:new Container(
                 margin: EdgeInsets.only(top:10.0,bottom: 10.0,left: 5.0,right: 5.0),
                 color: Colors.white,
                 height: 150,),
            ),
            new Expanded(
              flex: 1,
              child:new Column(
                children: <Widget>[
                  new Container(
                 margin: EdgeInsets.only(top:10.0,bottom: 5.0,left: 5.0,right: 5.0),
                 color: Colors.white,
                 height: 35,),
                new SizedBox(height: 5,),
                 new Container(
                 margin: EdgeInsets.only(top:5.0,bottom: 5.0,left: 5.0,right: 5.0),
                 color: Colors.white,
                 height: 35,),
                 new SizedBox(height: 5,),
                 new Container(
                 margin: EdgeInsets.only(top:5.0,bottom: 10.0,left: 5.0,right: 5.0),
                 color: Colors.white,
                 height: 35,),
                ],
              )
            )
          ],
        ),
        new SizedBox(height: 20,),
        new Container(
                                margin: EdgeInsets.all(5.0),
                                  color: Colors.white,
                                height: 50,),
        new SizedBox(height: 20,),
        new Container(
                                margin: EdgeInsets.all(5.0),
                                  color: Colors.white,
                                height: 50,),
      ],
    ),
  )

      :
      RefreshIndicator(
          key: refreshKey,
           onRefresh: refreshPage,
          child:errorStatus?
          ListView(children: <Widget>[
            new Container(
            margin: EdgeInsets.all(25),
            child: showErrorMessage(),
          )
          ],)
          
          :ListView(children: <Widget>[

            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(top:10.0, bottom: 10.0),
                  child:new Text("scroll down for refresh")
                 ),
              ],
            ),

            new Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                child: new Text(wheatherMode.location.name.toString(), textAlign: TextAlign.center, style: new TextStyle(fontSize: 16.0),),
           ),

           new Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0,bottom: 20.0),
                child: new Text(wheatherMode.location.locatTime.toString(), textAlign: TextAlign.center, style: new TextStyle(fontSize: 16.0),),
           ),


            new Row(
              children: <Widget>[
                new Expanded(flex: 1,child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
  

                    Padding(
                     padding: const EdgeInsets.only(top: 15.0,bottom:20.0,left: 0.1,right: 0.1),
                     child: Wrap(
                       
                       spacing: 1,
                        children: createIconList(),
                     ),
                  ),

                    

                    new Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                      child: new Text(wheatherDescription().toString(), textAlign: TextAlign.center, style: new TextStyle(fontSize: 22.0),),
                    )
                  ],
                ),),
                new  Expanded(
                  flex: 1,
                  child: new Column(
                    children: <Widget>[

                    new Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                      child: new Text(wheatherMode.current.tempraeture.toString()+" \u2103", textAlign: TextAlign.center, style: new TextStyle(fontSize: 32.0),),
                    ),
                    new Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 3.0),
                      child: new Text('Temperature', textAlign: TextAlign.center, style: new TextStyle(fontSize: 12.0),),
                    ),


                    new Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 30.0),
                      child: new Text(wheatherMode.current.humidity.toString(), textAlign: TextAlign.center, style: new TextStyle(fontSize: 32.0),),
                    ),
                    new Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 3.0),
                      child: new Text('Humidity', textAlign: TextAlign.center, style: new TextStyle(fontSize: 12.0),),
                    )


                    ],
                  ))
              ],
            ),

            
           new Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                child: new Text('feelslike: '+wheatherMode.current.feelslike.toString(), textAlign: TextAlign.center, style: new TextStyle(fontSize: 16.0),),
           ),



           
            
        ],),
      )
    );

    

  }

  String wheatherDescription(){

    String wheatherDescription="";

                List<String> list = wheatherMode.current.weatherDescription.toList();
final string = list.reduce((value, element) => value + ',' + element);
 AppLog().log(string.toString());

    wheatherDescription=string;

  return wheatherDescription;
  }

  List<Widget> createIconList() {

     List<Widget> createIconList = List<Widget>();
     for (int i = 0; i < wheatherMode.current.weatherIcons.length; i++) {

       createIconList.add(
         new Container(
           child:new CachedNetworkImage(
                      imageUrl: wheatherMode.current.weatherIcons[i],
                      height: 50,
                    placeholder: (context, url) => new Container(color: Colors.grey[200],height: MediaQuery.of(context).size.height*0.50,),
                    )
         )
       );

     }

     return createIconList;

  }

    Widget showErrorMessage() {
    if (errorMsg.length > 0 && errorMsg != null) {
      return new Text(
        errorMsg,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

    void signOut(BuildContext context) async {
    try {
      await widget.auth.signOut();

      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SignupMainScreen(auth: widget.auth,)), (Route<dynamic> route) => false);
     
    } catch (e) {
      print(e);
    }
  }

}