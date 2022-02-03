import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'admin/team.dart';
import 'company/allteams.dart';
import 'employee/certifications.dart';
import 'main.dart';
import 'models/AccessLevel.dart';
import 'models/Users.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 40,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              logo(),
              SizedBox(height: 100,),
              Credentials(),
            ],
          ),
        ),
      ),
    );
  }
}

String email="", password="";
class Credentials extends StatefulWidget {
  const Credentials({Key? key}) : super(key: key);

  @override
  _CredentialsState createState() => _CredentialsState();
}

class _CredentialsState extends State<Credentials> {
  TextEditingController _controller1 = new TextEditingController();
  TextEditingController _controller2 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
              child: Text("Email", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.start,),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller1,
            onChanged: (val) {
              email=val.trim().toLowerCase();
            },
            decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), gapPadding: 2), label: Text("Email")),
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
              child: Text("Password", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.start,),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller2,
            obscureText: true,
            onChanged: (val) {
              password=val.trim();
            },
            decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), gapPadding: 2), label: Text("Password")),
          ),
        ),
        Row(
          children: [
            Expanded(child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 3.0),
              child: login_button(),
            )),
          ],
        )
      ],
    );
  }
}

class login_button extends StatefulWidget {
  const login_button({Key? key}) : super(key: key);

  @override
  _login_buttonState createState() => _login_buttonState();
}

class _login_buttonState extends State<login_button> {

  _ShowToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.black,
        fontSize: 16.0
    );
  }

  bool loading=false;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        if(!loading)
          {
            setState(() {
              loading=true;
            });

            if(email.isNotEmpty)
              {
                if(password.isNotEmpty)
                  {
                    try
                    {
                      SignInResult res = await Amplify.Auth.signIn(username: email, password: password);
                      if(res.isSignedIn)
                      {
                        AuthUser us = await Amplify.Auth.getCurrentUser();
                        List<Users> u = await Amplify.DataStore.query(Users.classType, where: Users.ID.eq(us.userId));
                        if(u.first.Access == AccessLevel.EMPLOYEE) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => certify_main()));
                        }
                        else if(u.first.Access == AccessLevel.CLIENT) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => forloader(u.first)));
                        }
                        else if(u.first.Access == AccessLevel.COMPANY)
                          {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => teamloader()));
                          }
                      }
                      else
                      {
                        print("Unable to Sign In");
                        _ShowToast("Error: Please try again or contact the developer");
                        setState(() {
                          loading=false;
                        });
                      }
                    }
                    catch (e){
                      print("Unable to Sign In");
                      _ShowToast("Error: Please try again or contact the developer");
                      setState(() {
                        loading=false;
                      });
                    }
                  }
                else
                  {
                    _ShowToast("Please enter a password");
                    setState(() {
                      loading=false;
                    });
                  }
              }
            else
              {
                _ShowToast("Please enter an email");
                setState(() {
                  loading=false;
                });
              }
          }
      },
      color: Color.fromRGBO(46, 49, 146, 1),
      child: Text("Log In", style: TextStyle(fontSize: 20),),
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
      height: 45,);
  }
}


