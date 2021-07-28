import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/raised_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber/AllScreens/loginscreen.dart';
import 'package:uber/AllScreens/mainscreen.dart';
import 'package:uber/AllWidgets/progressDialog.dart';
import 'package:uber/main.dart';

class RegistrationScreen extends StatelessWidget
{
  static const String idScreen = "register";

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
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
                "REGISTER AS A RIDER",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                      children: [

                        SizedBox(height: 1.0,),
                        TextField(
                          controller: nameTextEditingController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              labelText: "Name",
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
                          controller: phoneTextEditingController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              labelText: "Phone",
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
                                "Create Account",
                                style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                              ),
                            ),

                          ),
                          shape: new RoundedRectangleBorder(
                              borderRadius:  new BorderRadius.circular(24.0)
                          ),
                          onPressed: () {

                            if(nameTextEditingController.text.length < 4)
                              {
                                displayToastMessage("Name must be at least 3 characters", context);
                              }
                            else if (!emailTextEditingController.text.contains("@"))
                              {
                                displayToastMessage("Email address is not valid", context);
                              }
                            else if(phoneTextEditingController.text.isEmpty)
                              {
                                displayToastMessage("Phone number is required", context);
                              }
                            else if (passwordTextEditingController.text.length <7)
                              {
                                displayToastMessage("Password is required", context);
                              }
                            else
                            {
                              registerNewUser(context);
                            }
                            
                          },
                        ),

                        FlatButton(
                            onPressed: (){
                              Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                            },
                            child: Text(
                              " Already have an Account? Login Here.",
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

  void registerNewUser(BuildContext context) async
  {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return ProgressDialog("Registering, Please wait....",);
        }
    );


    final firebaseUser = (await _firebaseAuth
        .createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text).catchError(
            (errMsg) {
              Navigator.pop(context);
              displayToastMessage("Error: " + errMsg.toString(), context);
            })).user;

    if(firebaseUser != null)
      {
        //save user info to database
        Map userDataMap = {
          "name": nameTextEditingController.text.trim(),
          "email": emailTextEditingController.text.trim(),
          "phone": phoneTextEditingController.text.trim(),
        };

        usersRef.child(firebaseUser.uid).set(userDataMap);
        displayToastMessage("Your Account has been created", context);
        
        Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
      }
    else
      {
        Navigator.pop(context);
        displayToastMessage("New User Account has not been created", context);
      }
  }

}

displayToastMessage(String message, BuildContext context)
{
  Fluttertoast.showToast(msg: message);
}