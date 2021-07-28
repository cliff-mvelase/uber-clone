import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/raised_button.dart';
import 'package:uber/AllScreens/mainscreen.dart';
import 'package:uber/AllScreens/registrationscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uber/AllWidgets/progressDialog.dart';
import 'package:uber/main.dart';

class LoginScreen extends StatelessWidget
{
  static const String idScreen = "login";

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 35.0,),
              Image(
                image: AssetImage("images/logo.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              SizedBox(height: 1.0,),
              Text(
                "LOGIN AS A RIDER",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                    children: [

                      SizedBox(height: 1.0,),
                      TextField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            )
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),

                      SizedBox(height: 1.0,),
                      TextField(
                        controller: passwordTextEditingController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            )
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),
                      
                      SizedBox(height: 30.0,),
                      RaisedButton(
                        color: Colors.yellow,
                        textColor: Colors.white,
                        child: Container(
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                            ),
                          ),

                        ),
                        shape: new RoundedRectangleBorder(
                          borderRadius:  new BorderRadius.circular(24.0)
                        ),
                        onPressed: () {
                         if (!emailTextEditingController.text.contains("@"))
                          {
                            displayToastMessage("Email address is not valid", context);
                          }
                          else if (passwordTextEditingController.text.length <7)
                          {
                            displayToastMessage("Password is required", context);
                          }
                          else
                          {
                            loginAndAuthenticateUser(context);
                          }
                        },

                      ),

                      FlatButton(
                          onPressed: (){
                            Navigator.pushNamedAndRemoveUntil(context, RegistrationScreen.idScreen, (route) => false);
                          },
                          child: Text(
                            " Do not have Account? Register Here.",
                          )
                      )
                    ]
                )
              ),

            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginAndAuthenticateUser(BuildContext context) async{
    
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
          {
             return ProgressDialog("Authenticating, Please wait....");
          }
        );

    final firebaseUser = (await _firebaseAuth
        .signInWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text).catchError(
            (errMsg) {
              Navigator.pop(context);
          displayToastMessage("Error: " + errMsg.toString(), context);
        })).user;

    if(firebaseUser != null)
    {
      usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap){
        if(snap.value != null)
        {
          Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
          displayToastMessage("You are Logged In Now", context);
        }
        else
        {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage("No record found. Please check your credentials.", context);
        }
      });
    }
    else
    {
      Navigator.pop(context);
      displayToastMessage("Error. Cannot be signed in", context);
    }
  }

}
