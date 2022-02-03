import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:certify/admin/current_user.dart';
import 'package:certify/company/allteams.dart';
import 'package:certify/register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'admin/team.dart';
import 'amplifyconfiguration.dart';
import 'employee/certifications.dart';
import 'login.dart';
import 'models/ModelProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}
class logo extends StatelessWidget {
  const logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: MediaQuery.of(context).size.width/2,
          height: 130,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Image.asset("lib/images/aim.png"),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width/2,
          height: 130,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Image.asset("lib/images/ewm.jpg"),
          ),
        )
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool loading=true;
  CurrentUser currentUser = CurrentUser();
  @override
  void initState() {
    if(!Amplify.isConfigured)
      {
        _configureAmplify();
      }
    else
      {
        _getCurrentUser();
      }
  }

  void _configureAmplify() async {
    // await Amplify.addPlugin(AmplifyAPI()); // UNCOMMENT this line after backend is deployed
    await Amplify.addPlugin(
        AmplifyDataStore(modelProvider: ModelProvider.instance));
    await Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.addPlugin(AmplifyAPI());
    await Amplify.addPlugin(AmplifyStorageS3());

    // Once Plugins are added, configure Amplify
    await Amplify.configure(amplifyconfig);
    try {
      // setState(() {
      //   _amplifyConfigured = true;
      // });
      _getCurrentUser();
      print("Successful Plugin Integration");
    } catch (e) {
      print(e);
    }
  }

  _getCurrentUser() async {
    Users u = await currentUser.getCurrentUser();
    if (currentUser.isSignedIn) {
      if(currentUser.isEmployee) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => certify_main()));
      }
      else if(currentUser.isClient) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => forloader(u)));
      }
      else if(currentUser.isCompany) {
        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => const teamloader()));
      }
    }
    else {
      setState(() {
        loading=false;
      });
    }
  }

    @override
    Widget build(BuildContext context) {
      return loading ? Scaffold(
        body: Center(child: CircularProgressIndicator(),),
      ): Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 1,),
            Text("Welcome to",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
            logo(),
            Spacer(flex: 1,),
            Row(
              children: [
                Expanded(child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 3.0),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          new MaterialPageRoute(builder: (context) => Login()));
                    },
                    color: Color.fromRGBO(46, 49, 146, 1),
                    child: Text("Log In", style: TextStyle(fontSize: 20),),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    height: 45,),
                )),
              ],
            ),
            Row(
              children: [
                Expanded(child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 10.0),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          new MaterialPageRoute(builder: (context) =>
                              Register()));
                    },
                    color: Colors.white,
                    child: Text("Register", style: TextStyle(fontSize: 20),),
                    textColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        side: BorderSide()),
                    height: 45,
                    elevation: 0,),
                )),
              ],
            )
          ],
        ),
      );
    }
  }




