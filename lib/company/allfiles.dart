import 'package:certify/admin/admin_files_class.dart';
import 'package:certify/admin/team.dart';
import 'package:certify/models/Users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class allfilesloader extends StatelessWidget {
  List<Users> users;
  String name="";
  allfilesloader(String this.name, List<Users> this.users, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<admin_files_class>(create: (_) => admin_files_class())
      ],
      child: allfiles(name, users),
    );
  }
}

class allfiles extends StatefulWidget {
  List<Users> users;
  String name;
  allfiles(String this.name, List<Users> this.users, {Key? key}) : super(key: key);

  @override
  _allfilesState createState() => _allfilesState(name, users);
}

class _allfilesState extends State<allfiles> {
  List<Users> users;
  String name;

  _allfilesState(String this.name, List<Users> this.users);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<admin_files_class>(context, listen: false).initializeFilesforAdmin(name, users);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Files", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Consumer<admin_files_class>(
        builder: (context, files, child){
          return ListView.builder(
            itemCount: files.getAdminFilesLength,
            itemBuilder: (context, index){
              return files_card(files.getFile(index), files.getFileEmployees(index)!, true);
            },
          );
        },
      ),
    );
  }
}

