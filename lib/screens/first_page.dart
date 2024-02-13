      import 'dart:async';
    import 'package:geolocator/geolocator.dart' as geo;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:users/assistant/assistant_method.dart';
import 'package:users/screens/searchdialog.dart';

class UserMain extends StatefulWidget {
  const UserMain({super.key});

  @override
  State<UserMain> createState() => _UserMainState();
}

class _UserMainState extends State<UserMain> {
  LatLng? pickLocation;
  loc.Location location = loc.Location();
  String? _address;

  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? newGoogleMaoController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(19.076090, 72.877426),
    zoom: 10.4746,
  );

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  double searchLocationContainerHeight = 220;
  double waitingResponsefromDriverContainer = 0;
  double assignedDriverInfoContainerHeight = 0;

  Position? userCurrentposition;
  var geoLocation = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

  List<LatLng> pLineCoordinatedList = [];
  Set<Polyline> polylineset = {};

  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

  String userName = "";
  String userEmail = "";

  bool openNavigationDrawer = true;
  late LocationData currentLocation;

  BitmapDescriptor? actuveNearbyIcon;

  locateUserPosition() async{
    Position cPosition = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
    userCurrentposition = cPosition;
    var userCurrentPosition;
    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentposition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target:latLngPosition,zoom:15);

    newGoogleMaoController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    // String humanReadableAddress=await AssistantMethods.searchAddressForGeographicCordinates(userCurrentPosition, context);
    // print("This is our address = " + humanReadableAddress);
  }

  _getCurrentLocation() async {
    var location = Location();
    //  setState(() async{
    //   currentLocation = await location.getLocation();
    // });
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      currentLocation = LocationData.fromMap({
        "latitude": 19.076090, // Provide a default latitude
        "longitude": 72.877426, // Provide a default longitude
      });
    }
    setState(() {
    });
   
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }
  @override
  Widget build(BuildContext context) {
    // const border = OutlineInputBorder(
    //   borderSide: BorderSide(color: Colors.black87),
    //   borderRadius: BorderRadius.horizontal(
    //     left: Radius.circular(50),
    //   ),
    // );
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Scaffold(
            body: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  polylines:polylineset , 
                  markers: {
                  if (currentLocation != null)
                  Marker(
                    markerId: MarkerId("current location"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: LatLng(
                      currentLocation.latitude ?? 19.076090,
                      currentLocation.longitude ?? 72.877426,
                    ),
                  ),
                  },
                  circles: circleSet,
                  initialCameraPosition: CameraPosition(target: LatLng(
            currentLocation.latitude ?? 0.0,
            currentLocation.longitude ?? 0.0,
          ),
          zoom: 14.0,),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    newGoogleMaoController = controller;

                    setState(() {
                      
                    });
                    // locateUserPosition();
                  },
                  onCameraMove: (CameraPosition? position){
                    if(pickLocation != position!.target){
                      setState(() {
                        pickLocation = position.target;
                      });
                    }
                  },
                  onCameraIdle: (){

                  },
                ),
                Positioned(
                  top: 16.0,
                  left: 16.0,
                  child: Container(
                        padding: EdgeInsets.all(8.0),
                        color: Colors.white,
                        child: IconButton(onPressed: (){
                          CustomDialog.showTwoTextFieldDialog(context);

                        }, icon: (const Icon(Icons.search))),
                        // child: Text(
                        //   'MapJourney',
                        //   style: TextStyle(fontSize: 18.0,color: Colors.black),
                        // ),
                      ),
                ),
                // Positioned(
                //   top: 20.0,
                //   left: 110.0,
                //   child:TextField(
                //     decoration: InputDecoration(
                //       hintText: 'Search',
                //       prefixIcon: Icon(Icons.search),
                //       // border: border,
                //       // enabledBorder: border,
                //     ),
                //   ),
                // ),
              ],
            ),
            // Stack(
            //   children:[
            //     GoogleMap(initialCameraPosition: _kGooglePlex,),
            //   ]

            // )
          ),
        ));
  }
}
