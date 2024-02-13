
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users/global/global.dart';
import 'package:users/screens/first_page.dart';
import 'package:users/screens/fresh_page.dart';
import 'package:users/screens/signup_Page.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final useremail = TextEditingController();
  final userpassword = TextEditingController();

  bool _passwordvisibility = true;
  final _formkey = GlobalKey<FormState>();
  

  void _submit() async {
    if (_formkey.currentState!.validate()) {
      await firebaseAuth
          .signInWithEmailAndPassword(
              email: useremail.text.trim(), password: userpassword.text.trim())
          .then((auth) async {
        currentUser = auth.user;
        await Fluttertoast.showToast(msg: "Successfully Logged In");
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
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
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
                      hintText: "Email",
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
                height: 15,
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
                    "SignIn",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Center(
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => const SignUp(),));
                    },
                    child: const Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
          ]
        )
        ),
      )
    );
  }
}