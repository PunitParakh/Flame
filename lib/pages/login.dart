// ignore_for_file: prefer_typing_uninitialized_variables, unused_field, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/pages/home_page.dart';
import 'package:flame/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late var _email,_password;


  final FirebaseAuth _auth = FirebaseAuth.instance;
  // StreamSubscription? subscription;  

checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()));
      }
    });
  }
    void signUp(){ 
         Navigator.of(context).push(MaterialPageRoute(
        builder: (context)=>const SignUp()));
    }

    Future askForPermissions() async {
       await Permission.microphone.request();
}

  login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
      } catch (e) {
        if (e.toString().contains("[firebase_auth/user-not-found]")) {
          showError("User Not Found!!\nCheck email and password");
        } else if (e.toString().contains("[firebase_auth/wrong-password]")) {
          showError("Invalid Password\nCheck it again");
        }else if (e.toString().contains("[firebase_auth/invalid-email]")) {
          showError("Invalid Email\nCheck it again");
        }
        print(e);
      }
    }
  }
showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }
navigateToSignUp() async {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const SignUp()));
  }

  @override
  void initState() {
    super.initState();
    askForPermissions();
    checkAuthentification();
  }



  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 400,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -40,
                    height: 400,
                    width: width,
                    child: 
                        Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/background.png'),
                                  fit: BoxFit.fill)),
                        ),
                  ),
                  Positioned(
                    height: 400,
                    width: width + 20,
                    child: 
                        Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/background-2.png'),
                                  fit: BoxFit.fill)),
                        ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  
                      const Text(
                        "Login",
                        style: TextStyle(
                            color: Color.fromRGBO(49, 39, 79, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                  const SizedBox(
                    height:30,
                  ),
                  
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(196, 135, 198, .3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                child: TextFormField(
                                  validator: (input){
                                    if (input != null) {
                                    if (input.isEmpty) {
                                      return 'Enter Email';
                                    }
                                  }
                                  },
                                  onSaved: (input)=>_email = input,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
                                      prefixIcon: Icon(Icons.email),
                                      hintStyle: TextStyle(color: Colors.grey)),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                child:  TextFormField(
                                    validator: (input) {
                                    // ignore: curly_braces_in_flow_control_structures
                                    if (input != null) if (input.length < 6)
                                      // ignore: curly_braces_in_flow_control_structures
                                      return 'Provide Minimum 6 Character';
                                  },
                                  obscureText: true,
                                  onSaved: (input) => _password = input,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      prefixIcon: Icon(Icons.lock),
                                      hintStyle: TextStyle(color: Colors.grey)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                  const SizedBox(
                    height: 10,
                  ),
                  
                  const SizedBox(
                    height: 40,
                  ),
                  
                      Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 60),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: const Color.fromRGBO(49, 39, 79, 1),
                        ),
                        child:  Center(
                          child: TextButton(onPressed: (){login();}, child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                  const SizedBox(
                    height: 15,
                  ),
                     Center(
                      child: TextButton(onPressed: (){navigateToSignUp();}, child: const Text(
                        "Create Account",
                        style: TextStyle(color: Color.fromRGBO(49, 39, 79, .6)),
                      ),)
                    ),
                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}