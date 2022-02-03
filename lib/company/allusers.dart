import 'package:certify/admin/certificate_class.dart';
import 'package:certify/admin/files_class.dart';
import 'package:certify/admin/team.dart';
import 'package:certify/models/Users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class allusersloader extends StatelessWidget {
  List<Users> users;
  allusersloader(List<Users> this.users, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<files_class>(create: (_) => files_class()),
          ChangeNotifierProvider<Certificate>(create: (_) => Certificate()),
        ],
      child: allusers(users),
    );
  }
}

class allusers extends StatefulWidget {
  List<Users> users;
  allusers(List<Users> this.users, {Key? key}) : super(key: key);

  @override
  _allusersState createState() => _allusersState(users);
}

class _allusersState extends State<allusers> {
  List<Users> users;
  _allusersState(List<Users> this.users);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          print(users.length.toString());
          return team_tile(users.elementAt(index));
        },
      ),
    );
  }
}

