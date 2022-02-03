import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';

import 'main.dart';


class settings extends StatelessWidget {
  const settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {Navigator.pop(context);},
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    try{
                      Amplify.Auth.signOut();
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
                    }
                    on AuthException catch(e)
                    {
                      print(e.message);
                    }
                  },
                  color: Color.fromRGBO(46, 49, 146, 1),
                  child: Text("Sign Out"),
                  textColor: Colors.white,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
