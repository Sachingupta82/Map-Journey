import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users/global/global.dart';
import 'package:users/screens/first_page.dart';
import 'package:users/screens/fresh_page.dart';
import 'package:users/screens/login_Page.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final username = TextEditingController();
  final userphone = TextEditingController();
  final useremail = TextEditingController();
  final userpassword = TextEditingController();
  final userconfirmpassword = TextEditingController();

  bool _passwordvisibility = true;
  final _formkey = GlobalKey<FormState>();
  void _submit() async {
    if (_formkey.currentState!.validate()) {
      await firebaseAuth
          .createUserWithEmailAndPassword(
              email: useremail.text.trim(), password: userpassword.text.trim())
          .then((auth) async {
        currentUser = auth.user;

        if (currentUser != null) {
          Map usermap = {
            "id": currentUser!.uid,
            "name": username.text.trim(),
            "phone": userphone.text.trim(),
            "email": useremail.text.trim(),
            "password": userpassword.text.trim(),
          };

          DatabaseReference userRef =
              FirebaseDatabase.instance.ref().child("users");
          userRef.child(currentUser!.uid).set(usermap);

          print("Data submitted sucessfully");
        }
        await Fluttertoast.showToast(msg: "Successfully Registered");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (c) => JourneyPlannerPage(),
          ),
        );
      }).catchError((errorMessage){
        Fluttertoast.showToast(msg: "Error Occured \n $errorMessage");
      });

    }
    else{
      Fluttertoast.showToast(msg: "Not all fields are valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.green.shade100,
        body: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            Image.asset('images/MapJourney.gif'),
            const SizedBox(height: 10),
            Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(100),
                      ],
                      decoration: InputDecoration(
                          hintText: "Name",
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 67, 66, 66),
                          ),
                          filled: true,
                          fillColor:Colors.grey.shade200,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: const BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              )),
                          prefixIcon: const Icon(Icons.person)),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Name cannot be empty.';
                        }
                        if (text.length < 2) {
                          return "Please enter a valid name";
                        }
                        if (text.length > 49) {
                          return "Name cannot be more than 50 characters";
                        }
                        return null;
                      },
                      onChanged: (text) => setState(() {
                        username.text = text;
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(100),
                ],
                decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 67, 66, 66),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        )),
                    prefixIcon: const Icon(Icons.mail)),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Email cannot be empty.';
                  }
                  if (EmailValidator.validate(text) == true) {
                    return null;
                  }
                  if (text.length < 2) {
                    return "Please enter a valid Email";
                  }
                  if (text.length > 49) {
                    return "Email cannot be more than 50 characters";
                  }
                  return null;
                },
                onChanged: (text) => setState(() {
                  useremail.text = text;
                }),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.name,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(100),
                ],
                decoration: InputDecoration(
                    hintText: "Phone",
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 67, 66, 66),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        )),
                    prefixIcon: const Icon(Icons.phone)),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Phone no. can\'t be empty.';
                  }
                  if (text.length < 10 || text.length > 10) {
                    return "Please enter a valid number";
                  }
                  return null;
                },
                onChanged: (text) => setState(() {
                  userphone.text = text;
                }),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                obscureText: _passwordvisibility,
                keyboardType: TextInputType.name,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(100),
                ],
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 67, 66, 66),
                  ),
                  filled: true,
                  fillColor:
                      Colors.grey.shade200,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      )),
                  prefixIcon: const Icon(Icons.password),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordvisibility = !_passwordvisibility;
                      });
                    },
                    icon: Icon(_passwordvisibility
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Password can\'t be empty.';
                  }
                  return null;
                },
                onChanged: (text) => setState(() {
                  userpassword.text = text;
                }),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                obscureText: _passwordvisibility,
                keyboardType: TextInputType.name,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(100),
                ],
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 67, 66, 66),
                  ),
                  filled: true,
                  fillColor:
                      Colors.grey.shade200,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      )),
                  prefixIcon: const Icon(Icons.password),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordvisibility = !_passwordvisibility;
                      });
                    },
                    icon: Icon(_passwordvisibility
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Confirm Password can\'t be empty.';
                  }
                  if (userpassword.text != text) {
                    return "Password do not match";
                  }
                  return null;
                },
                onChanged: (text) => setState(() {
                  userconfirmpassword.text = text;
                }),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.lightGreen.shade400,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    minimumSize: const Size(double.infinity, 50)),
                onPressed: () {
                  _submit();
                },
                child: const Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // GestureDetector(
            //   onTap: () {},
            //   child: const Center(
            //     child: Text(
            //       "Forgot Password?",
            //       style: TextStyle(color: Colors.blue),
            //     ),
            //   ),
            // ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Have an account?  ",style: TextStyle(fontSize: 16),),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => const Login(),),);
                  },
                  child: const Center(
                    child: Text(
                      "Sign In",
                      style: TextStyle(color: Colors.blue,fontSize: 18),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
