import 'package:firebase_auth/firebase_auth.dart';
import 'package:users/models/user_models.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;

UserModel? userModelCurrentInfo;