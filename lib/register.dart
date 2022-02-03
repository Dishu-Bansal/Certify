import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:certify/company/allteams.dart';
import 'package:certify/models/AccessLevel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'employee/certifications.dart';
import 'main.dart';
import 'models/Departments.dart';
import 'models/Users.dart';

class Register extends StatelessWidget {
  Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 40,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            logo(),
            SizedBox(height: 60,),
            loader(),
          ],
        ),
      )
    );
  }
}

List<Departments> departments = List.empty(growable: true);
class loader extends StatefulWidget {
  const loader({Key? key}) : super(key: key);

  @override
  _loaderState createState() => _loaderState();
}

class _loaderState extends State<loader> {

  bool loaded=false;

  getDepartments() async {
    await Amplify.DataStore.stop();
    await Amplify.DataStore.start();
    departments = await Amplify.DataStore.query(Departments.classType);
    setState(() {
      loaded=true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDepartments();
  }

  @override
  Widget build(BuildContext context) {
    return loaded ? form() : Center(child: CircularProgressIndicator(),);
  }
}

class form extends StatefulWidget {
  const form({Key? key}) : super(key: key);

  @override
  _formState createState() => _formState();
}

String name="", email="", password="", department="", code="";

class _formState extends State<form> {

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

  TextEditingController _controller1 = new TextEditingController();
  TextEditingController _controller2 = new TextEditingController();
  TextEditingController _controller3 = new TextEditingController();

  bool verify=false, loading=false;
  @override
  Widget build(BuildContext context) {
    return verify ? verifyit() : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
          child: Text("Name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.start,),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller1,
            onChanged: (val) {
              name=val.trim();
            },
            decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), gapPadding: 2), label: Text("Name")),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
          child: Text("Email", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.start,),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller2,
            onChanged: (val) {
              email=val.trim().toLowerCase();
            },
            decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), gapPadding: 2), label: Text("Email")),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
          child: Text("Password", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.start,),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller3,
            obscureText: true,
            onChanged: (val) {
              password=val.trim();
            },
            decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), gapPadding: 2), label: Text("Password")),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
          child: Text("Department", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.start,),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10,0,0,0),
          child: dropdown(),
        ),
        Row(
          children: [
            Expanded(child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 3.0),
              child: MaterialButton(
                onPressed: () async {

                  if(!loading){
                    setState(() {
                      loading=true;
                    });

                    if(name.isNotEmpty)
                      {
                        if(email.isNotEmpty)
                          {
                            if(password.isNotEmpty && password.length >= 6)
                              {
                                if(department.isNotEmpty && department != null)
                                  {
                                    Map<String, String> userAttributes =  {
                                      "name" : name,
                                    };

                                    try
                                    {
                                      SignUpResult res = await Amplify.Auth.signUp(username: email, password: password, options: CognitoSignUpOptions(userAttributes: userAttributes));
                                      if(res.isSignUpComplete)
                                      {
                                        setState(() {
                                          verify = true;
                                        });
                                      }
                                      else
                                      {
                                        print("Error: " + res.toString());
                                        _ShowToast("Error! Please try again or Contact the developer");
                                        setState(() {
                                          loading=false;
                                        });
                                      }
                                    }
                                    catch (e){
                                      print("Error: " + e.toString());
                                      _ShowToast("Error! Please try again or Contact the developer");
                                      setState(() {
                                        loading=false;
                                      });
                                    }
                                  }
                                else
                                  {
                                    _ShowToast("Please Select a Department");
                                    setState(() {
                                      loading=false;
                                    });
                                  }
                              }
                            else
                              {
                                _ShowToast("Password must be at least 6 characters");
                                setState(() {
                                  loading=false;
                                });
                              }
                          }
                        else
                          {
                            _ShowToast("Please enter an email.");
                            setState(() {
                              loading=false;
                            });
                          }
                      }
                    else
                      {
                        _ShowToast("Please type a name");
                        setState(() {
                          loading=false;
                        });
                      }
                  }
                },
                color: Color.fromRGBO(46, 49, 146, 1),
                child: Text("Register", style: TextStyle(fontSize: 20),),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                height: 45,),
            )),
          ],
        )
      ],
    );
  }
}


class register_button extends StatefulWidget {
  const register_button({Key? key}) : super(key: key);

  @override
  _register_buttonState createState() => _register_buttonState();
}

class _register_buttonState extends State<register_button> {


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

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading ? MaterialButton(
      onPressed: () {},
      color: Color.fromRGBO(46, 49, 146, 1),
      child: const CircularProgressIndicator(),
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
      height: 45,) :
    MaterialButton(
      onPressed: () async {

        if(!loading){
          setState(() {
            loading = true;
          });

          if(code.isNotEmpty && code.length == 6)
            {
              try{
                SignUpResult res = await Amplify.Auth.confirmSignUp(username: email, confirmationCode: code);
                if(res.isSignUpComplete)
                {
                  SignInResult re = await Amplify.Auth.signIn(username: email, password: password);
                  if(re.isSignedIn)
                  {
                    AuthUser user = await Amplify.Auth.getCurrentUser();
                    await Amplify.DataStore.save(new Users(id: user.userId, Name: name, Department: department, Access: AccessLevel.EMPLOYEE, Email: email, Password: password));
                    //Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => certify_main()));
                    Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => allteams()));
                  }
                  else
                  {
                    print("Error: " + re.toString());
                    _ShowToast("Error! Please try again or Contact the developer");
                    setState(() {
                      loading=false;
                    });
                  }
                }
                else
                {
                  print("Error: " + res.toString());
                  _ShowToast("Error! Please try again or Contact the developer");
                  setState(() {
                    loading = false;
                  });
                }
              }
              catch (e){
                print("Error: " + e.toString());
                _ShowToast("Error! Please try again or Contact the developer");
                setState(() {
                  loading = false;
                });
              }
            }
          else
            {
              _ShowToast("Please enter a 6 digit code");
              setState(() {
                loading = false;
              });
            }
        }
      },
      color: Color.fromRGBO(46, 49, 146, 1),
      child: Text("Verify", style: TextStyle(fontSize: 20),),
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
      height: 45,);
  }
}


class dropdown extends StatefulWidget {
  const dropdown({Key? key}) : super(key: key);

  @override
  _dropdownState createState() => _dropdownState();
}

class _dropdownState extends State<dropdown> {

  String? value=null;
  @override
  Widget build(BuildContext context) {
    print("Departments are: " + departments.toString());
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 8, 3),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color.fromRGBO(0, 0, 0, 0.5)
        ),
        borderRadius: BorderRadius.circular(15)
      ),
      padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
      child: DropdownButton<String>(
        value: value,
        hint: Text("Select an option"),
        onChanged: (String? val) {
          department=val.toString();
          setState(() {
            value = val.toString();
          });
        },
        underline: DropdownButtonHideUnderline(child: Container()),
        items: departments.map((department) {
          return DropdownMenuItem<String>(
            child: Text(department.Name!, style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),),
            value: department.Name!,
          );
        }).toList(),
        borderRadius: BorderRadius.circular(15),
        isExpanded: true,
      ),
    );
  }
}


class verifyit extends StatefulWidget {
  const verifyit({Key? key}) : super(key: key);

  @override
  _verifyitState createState() => _verifyitState();
}

class _verifyitState extends State<verifyit> {
  TextEditingController _controller1 = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
          child: Text("Verification Code", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.start,),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller1,
            onChanged: (val) {
              code=val.trim().toLowerCase();
            },
            decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), gapPadding: 2), label: Text("######"), helperText: "Check your email for the code"),
          ),
        ),
        Row(
          children: [
            Expanded(child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 3.0),
              child: register_button(),
            )),
          ],
        )
      ],
    );
  }
}


