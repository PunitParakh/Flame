import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame/pages/home_page.dart';
import 'package:flame/pages/login.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({ Key? key }) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late var _email,_password,_username;


  final FirebaseAuth _auth = FirebaseAuth.instance;  

checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()));
      }
    });
  }
 
 signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        // ignore: unnecessary_null_comparison
        if (user != null) {
          Map<String, dynamic> data = {
            "email": _email,
            "username": _username
            };
          FirebaseFirestore.instance
              .collection("allemail")
              .doc(_email.toString())
              .set(data);
          // ignore: deprecated_member_use
          await _auth.currentUser!.updateProfile(displayName: _username);

        }
      } catch (e) {
        if (e.toString().contains("[firebase_auth/invalid-email]"))
          // ignore: curly_braces_in_flow_control_structures
          showError("Invalid Email!!\nPlease check email.");
        else
          // ignore: curly_braces_in_flow_control_structures
          showError("Something went wrong!!\nTry again.");
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
        MaterialPageRoute(builder: (context) => const LoginPage()));
  }

@override
  void initState() {
    super.initState();
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
                                      'assets/bg.png'),
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
                                      'assets/signbg.png'),
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
                        "Sign up",
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
                              color: Color.fromARGB(75, 95, 80, 13),
                              blurRadius: 40,
                              offset: Offset(0, 40),
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
                                  onChanged: (input)=>_username = input,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Username",
                                      prefixIcon: Icon(Icons.person),
                                      hintStyle: TextStyle(color: Colors.grey)),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                child:  TextFormField(
                                    validator: (input) {
                                      // ignore: curly_braces_in_flow_control_structures
                                      if (input != null) if (input.isEmpty)
                                        // ignore: curly_braces_in_flow_control_structures
                                        return 'Enter Email';
                                      if (!RegExp(
                                              "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                          .hasMatch(input!))
                                        // ignore: curly_braces_in_flow_control_structures
                                        return 'Please enter a valid email';
                                    },
                                  
                                  onChanged: (input) => _email = input,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
                                      prefixIcon: Icon(Icons.email),
                                      hintStyle: TextStyle(color: Colors.grey)),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                child:  TextFormField(
                                    validator: (input) {
                                    // ignore: curly_braces_in_flow_control_structures
                                    if (input != null) if (input.length < 6)
                                      // ignore: curly_braces_in_flow_control_structures
                                      return 'Provide Minimum 6 Character';
                                  },
                                  obscureText: true,
                                  onChanged: (input) => _password = input,
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
                          color: Color.fromARGB(255, 222, 186, 26),
                        ),
                        child:  Center(
                          child: TextButton(onPressed: (){signUp();}, child: const Text(
                            "Sign Up",
                            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          )),
                        ),
                      ),
                  const SizedBox(
                    height: 15,
                  ),
                     Center(
                      child: TextButton(
                        onPressed: (){navigateToSignUp();},
                       child: const Text(
                        "Already have an Account",
                        style: TextStyle(color: Color.fromRGBO(49, 39, 79, .6)),
                      ))
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