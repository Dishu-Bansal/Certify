import 'package:amplify_flutter/amplify.dart';
import 'package:certify/admin/certificate_class.dart';
import 'package:certify/company/allfiles.dart';
import 'package:certify/company/allusers.dart';
import 'package:certify/company/department_class.dart';
import 'package:certify/models/Certificates.dart';
import 'package:certify/models/Departments.dart';
import 'package:certify/models/FileToUser.dart';
import 'package:certify/models/Files.dart';
import 'package:certify/models/Users.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'allteams.dart';

class clientloader extends StatelessWidget {
  Departments name;
  List<Users> employees;
  List<Users> admins;
  clientloader(Departments this.name, List<Users> this.employees, List<Users> this.admins, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    employees.addAll(admins);
    return MultiProvider(providers: [
      ChangeNotifierProvider<department_details>(create: (_) => department_details()),
      ChangeNotifierProvider<Certificate>(create: (_) => Certificate()),
    ],
    child: client(name, employees));
  }
}

String newname="";

class client extends StatelessWidget {
  Departments name;
  List<Users> users = List.empty(growable: true);
  client(Departments this.name, List<Users> this.users, {Key? key}) : super(key: key);


  initialize(BuildContext context) {
    Provider.of<department_details>(context, listen: false).initializeDepartment(name.Name!);
  }
  @override
  Widget build(BuildContext context) {
    initialize(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {Navigator.pop(context);},
          icon: Icon(Icons.arrow_back, color: Colors.black,),
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer<department_details>(
          builder: (context, details, child){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(child: SingleChildScrollView(scrollDirection: Axis.horizontal,child: Text(name.Name!, style: TextStyle(fontSize: 40,overflow: TextOverflow.fade, fontWeight: FontWeight.bold, color: Colors.black),))),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, size: 30,),
                      onPressed: (){
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Set a new name"),
                                content: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "Name",
                                  ),
                                  onChanged: (val) {
                                    newname = val;
                                    print("new name is: " + newname);
                                  },
                                ),
                                actions: [
                                  updateName(name),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancel"),
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Card(
                        margin: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(25,15,25,10),
                              child: Text("Users:", style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.5)),),
                            ),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(0,0,0,25),
                                child: Text(users.length.toString(), style: TextStyle(fontSize: 12, color: Colors.black),)
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        margin: EdgeInsets.fromLTRB(0,20,20,20),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(25, 15, 25, 10),
                              child: Text("Files Shared:", style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.5)),),
                            ),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(0,0,0,25),
                                child: Text(details.getFilesLength.toString(), style: TextStyle(fontSize: 12, color: Colors.black),)
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text("Users", style: TextStyle(fontSize: 20,), textAlign: TextAlign.center,),),
                    Padding(
                        padding: const EdgeInsets.all(5),
                        child: MaterialButton(
                          onPressed: ()  {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> allusersloader(users)));
                          },
                          child: Text("All>", style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.5)), textAlign: TextAlign.center,),
                        )
                    ),
                  ],
                ),
                Container(
                  height: 200,
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    scrollDirection: Axis.horizontal,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      Users user = users.elementAt(index);
                      return user_card(user);
                    },),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text("Files", style: TextStyle(fontSize: 20,), textAlign: TextAlign.center,),),
                    Padding(
                        padding: const EdgeInsets.all(5),
                        child: MaterialButton(
                          onPressed: ()  {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => allfilesloader(name.Name!, users)));
                          },
                          child: Text("All>", style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.5)), textAlign: TextAlign.center,),
                        )
                    ),
                  ],
                ),
                Container(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: details.getFilesLength,
                    itemBuilder: (context, index) {
                      Files f = details.files.elementAt(index);
                      return Card(
                        margin: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 10,
                        child: Column(
                          children: [
                            Container(
                              width: 180,
                              child: Icon(Icons.image, size: 114,),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8,0,8,0),
                              child: Text(f.Name!, style: TextStyle(fontSize: 18),),
                            ),
                            Text(DateFormat("dd/MM/yyyy").format(DateTime.fromMillisecondsSinceEpoch(int.parse(f.key!))), style: TextStyle(fontSize: 14),)
                          ],
                        ),
                      );
                    },),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class button extends StatefulWidget {
  button({Key? key}) : super(key: key);

  @override
  _buttonState createState() => _buttonState();
}

class _buttonState extends State<button> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
      },
      child: Text("Upgrade to Company", style: TextStyle(color: Colors.white, fontSize: 16),),
      color: Color.fromRGBO(46, 49, 146, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }
}

class user_card extends StatefulWidget {
  Users user;
  user_card(Users this.user, {Key? key}) : super(key: key);

  @override
  _user_cardState createState() => _user_cardState(user);
}

class _user_cardState extends State<user_card> {
  Users user;
  List<Certificates> certificates = List.empty(growable: true);
  List<Files> files = List.empty(growable: true);
  _user_cardState(Users this.user);
  bool loading = true;


  @override
  void initState() {
    super.initState();
    initialize();
  }

  getFiles() async {
    List<FileToUser> filesrelations = await Amplify.DataStore.query(FileToUser.classType, where: FileToUser.USERID.eq(user.id));
    for(FileToUser relation in filesrelations){
      List<Files> file = await Amplify.DataStore.query(Files.classType, where: Files.KEY.eq(relation.FileKey));
      files.addAll(file);
    }
  }

  initialize() async {
    certificates = await Provider.of<Certificate>(context, listen: false).getCertificates;
    await getFiles();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 10,
      child: loading ? CircularProgressIndicator() : Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(50,0,50,0),
            child: Text(user.Name!, style: TextStyle(fontSize: 30),),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0,0,0,20),
            child: Text(user.Access.toString(), style: TextStyle(fontSize: 14),),
          ),
          Text("Certifications: " + certificates.length.toString(), style: TextStyle(fontSize: 14),),
          Text("Files: " + files.length.toString(), style: TextStyle(fontSize: 14),),
        ],
      ),
    );
  }
}

class updateName extends StatefulWidget {
  Departments name;
  updateName(Departments this.name, {Key? key}) : super(key: key);

  @override
  _updateNameState createState() => _updateNameState(name);
}

class _updateNameState extends State<updateName> {
  Departments name;
  _updateNameState(Departments this.name);
  bool loading=false;

  @override
  Widget build(BuildContext context) {
    print("My new name is: " + newname);
    return TextButton(
      onPressed: () async {
        setState(() {
          loading = true;
        });
        await Amplify.DataStore.save(name.copyWith(Name: newname));
        List<Users> users = await Amplify.DataStore.query(Users.classType, where: Users.DEPARTMENT.eq(name.Name!));
        for(Users u in users){
          await Amplify.DataStore.save(u.copyWith(Department: newname));
        }
        List<Files> files = await Amplify.DataStore.query(Files.classType, where: Files.DEPARTMENT.eq(name.Name!));
        for(Files u in files){
          await Amplify.DataStore.save(u.copyWith(Department: newname));
        }
        Navigator.push(context, MaterialPageRoute(builder: (_) => teamloader()));
      },
      child: loading ? CircularProgressIndicator() : Text("Confirm"),
    );
  }
}


