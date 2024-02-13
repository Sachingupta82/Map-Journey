import 'package:firebase_database/firebase_database.dart';
import 'package:users/global/global.dart';
Future<void> retrieveUserData() async {
  String userId = currentUser!.uid; 
  DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users").child(userId);

  // Fetch the data
  DataSnapshot dataSnapshot = (await userRef.once()) as DataSnapshot;
  Map<dynamic, dynamic>? userData = dataSnapshot.value as Map<dynamic, dynamic>?;
  String name = userData?["name"];
  String email = userData?["email"];
  String phone = userData?["phone"];

  print("Name: $name");
  print("Email: $email");
  print("Phone: $phone");
}
