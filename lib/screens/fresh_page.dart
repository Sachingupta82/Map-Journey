// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

// class JourneyPlannerPage extends StatefulWidget {
//   @override
//   _JourneyPlannerPageState createState() => _JourneyPlannerPageState();
// }

// class _JourneyPlannerPageState extends State<JourneyPlannerPage> {
//   late GoogleMapController mapController;
//   final TextEditingController _destinationController = TextEditingController();
//   late Position _currentPosition;
//   String _currentAddress = '';
//   double totalTime = 0.0;
//   double totalCost = 0.0;
//   String weatherForecast = '';
//   double totalFuelRequired = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   void _getCurrentLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       _currentPosition = position;
//     });

//     _getAddressFromLatLng();
//   }

//   void _getAddressFromLatLng() async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//           _currentPosition.latitude, _currentPosition.longitude);

//       Placemark place = placemarks[0];

//       setState(() {
//         _currentAddress =
//             "${place.name}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   void calculateJourneyDetails() {
//     // Simulated calculation for demonstration
//     setState(() {
//       totalTime = 5.5; // Dummy value for total time
//       totalCost = 50.0; // Dummy value for total cost
//       weatherForecast = 'Sunny'; // Dummy value for weather forecast
//       totalFuelRequired = 10.0; // Dummy value for total fuel required
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Journey Planner'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               'Current Location: $_currentAddress',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16.0),
//             TextField(
//               controller: _destinationController,
//               decoration: InputDecoration(labelText: 'Destination'),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 calculateJourneyDetails();
//               },
//               child: Text('Submit'),
//             ),
//             SizedBox(height: 16.0),
//             Text('Total Time: $totalTime hours'),
//             Text('Total Cost: $totalCost dollars'),
//             Text('Weather Forecast: $weatherForecast'),
//             Text('Total Fuel Required: $totalFuelRequired liters'),
//             SizedBox(height: 16.0),
//             Expanded(
//               child: GoogleMap(
//                 onMapCreated: _onMapCreated,
//                 initialCameraPosition: CameraPosition(
//                   target: LatLng(_currentPosition.latitude,
//                       _currentPosition.longitude),
//                   zoom: 15,
//                 ),
//                 markers: Set.from([
//                   Marker(
//                     markerId: MarkerId("currentLocation"),
//                     position: LatLng(_currentPosition.latitude,
//                         _currentPosition.longitude),
//                     infoWindow: InfoWindow(title: "Your Location"),
//                   ),
//                 ]),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice/directions.dart' as directions;
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart' as geolocator; // aliasing Geolocator
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:users/screens/userprofiledata.dart';

class JourneyPlannerPage extends StatefulWidget {
  @override
  _JourneyPlannerPageState createState() => _JourneyPlannerPageState();
}

class _JourneyPlannerPageState extends State<JourneyPlannerPage> {
  late GoogleMapController mapController;
  final TextEditingController _destinationController = TextEditingController();
  late Position _currentPosition;
  String _currentAddress = '';
  double totalTime = 0.0;
  double totalCost = 0.0;
  String weatherForecast = '';
  double totalFuelRequired = 0.0;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    retrieveUserData();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: geolocator.LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng(position.latitude, position.longitude);
    } on PlatformException catch (e) {
      print('PlatformException: ${e.message}');
    } catch (e) {
      print(e.toString());
    }
  }

  void _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
            "${place.name}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: '#', // Replace with your Google Maps API Key
      mode: Mode.overlay,
      language: "en",
      components: [Component(Component.country, "us")],
    );

    if (p != null) {
      _destinationController.text = p.description!;
    }
  }

  void calculateJourneyDetails(String destinationAddress) async {
    try {
      // Fetch directions from current location to destination
      final directions.GoogleMapsDirections directionsService =
          directions.GoogleMapsDirections(apiKey: '#');

      final directions.DirectionsResponse response =
          await directionsService.directionsWithLocation(
        directions.Location(lat:_currentPosition.latitude, lng:_currentPosition.longitude),
        (await _getLocationFromAddress(destinationAddress)),


      );

      if (response.isOkay) {
        final route = response.routes!.first;
        final totalDuration = route.legs!.fold(
            Duration(),
            (previousValue, element) =>
                previousValue + Duration(milliseconds: element.duration!.value!.toInt()));
        final totalDistance = route.legs!.fold(
            0,
            (previousValue, element) =>
                previousValue + element.distance!.value!.toInt());

        setState(() {
          totalTime = totalDuration.inHours.toDouble();
          totalCost = totalDistance * 0.01 ; // Dummy cost calculation
          totalFuelRequired = (totalDistance * 0.001)  ; // Dummy fuel calculation
        });
      }
      _markers.clear();

      _markers.add(
        Marker(
          markerId: MarkerId('currentLocation'),
          position: LatLng(_currentPosition.latitude, _currentPosition.longitude),
          infoWindow: InfoWindow(title: 'Current Location'),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('destination'),
          position: LatLng(
            (await _getLocationFromAddress(destinationAddress)).lat,
            (await _getLocationFromAddress(destinationAddress)).lng,
          ),
          infoWindow: InfoWindow(title: 'Destination'),
        ),
      );
      setState(() {
        weatherForecast = 'Sunny';
      });

    } catch (e) {
      print(e.toString());
    }
  }

Future<directions.Location> _getLocationFromAddress(String address) async {
  final places = GoogleMapsPlaces(apiKey: '#'); // Replace with your Google Maps API Key
  PlacesSearchResponse response = await places.searchByText(address);
  if (response.results.isNotEmpty) {
    PlacesSearchResult result = response.results.first;
    return directions.Location(
      lat: result.geometry!.location.lat,
      lng: result.geometry!.location.lng,
    );
  }
  throw Exception('Location not found');
}


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Map Journey'),
      automaticallyImplyLeading: false,
    ),
    body: Padding(
      padding: EdgeInsets.all(16.0),
      child: FutureBuilder<bool>(
        future: Future.delayed(Duration(seconds: 6), () => true),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(), // Show loading spinner
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Current Location: $_currentAddress',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _destinationController,
                  decoration: InputDecoration(
                    labelText: 'Destination',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _handlePressButton,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    String destinationAddress = _destinationController.text;
                    calculateJourneyDetails(destinationAddress);
                  },
                  child: Text('Submit'),
                ),
                SizedBox(height: 16.0),
                totalCost < 15.0
                    ? Text('Total Time: 4 minutes approx')
                    : totalCost > 30.0
                        ? Text('Total Time: 45 minutes approx')
                        : Text('Total Time: 15 minutes approx'),
                Text('Total Cost: $totalCost rupees'),
                Text('Weather Forecast: $weatherForecast'),
                Text('Total Fuel Required: $totalFuelRequired ml'),
                SizedBox(height: 16.0),
                Expanded(
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_currentPosition.latitude,
                          _currentPosition.longitude),
                      zoom: 15,
                    ),
                    markers: _markers,
                  ),
                ),
              ],
            );
          }
        },
      ),
    ),
  );
}

}

