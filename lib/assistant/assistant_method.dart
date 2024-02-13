
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:users/global/global.dart';
import 'package:users/models/user_models.dart';
class AssistantMethods{
  static void readCurrentOnlineUserInfo() async{
    currentUser = firebaseAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
    .ref()
    .child('users')
    .child(currentUser!.uid);

    userRef.once().then((snap){
      if(snap.snapshot.value != null){
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
    });
  }
  // static Future<String> searchAddressForGeographicCordinates(Position position,context) async {
  //  String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

  //  String humanreadalbeAddress ="";
  //  var requestResponse = new RequestAssistant;

  //  return humanreadalbeAddress;

  // }
}