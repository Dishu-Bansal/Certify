import 'dart:async';

import 'package:amplify_flutter/amplify.dart';
import 'package:certify/company/teams_class.dart';
import 'package:certify/models/Departments.dart';
import 'package:certify/models/Users.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../settings.dart';
import 'client.dart';

class teamloader extends StatefulWidget {
  const teamloader({Key? key}) : super(key: key);

  @override
  _teamloaderState createState() => _teamloaderState();
}

class _teamloaderState extends State<teamloader> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<teams>(create: (_) => teams())
      ],
      child: Scaffold(
        body: allteams(),
      ),
    );
  }
}



class allteams extends StatelessWidget {
  const allteams({Key? key}) : super(key: key);

  initialize(BuildContext context){
    Provider.of<teams>(context, listen: false).initializeTeams();
  }

  deleteDepartment(BuildContext context, Departments department) async {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        content: Text("This will delete all employee data including the certificates and files shared. This is IRREVERSIBLE."),
        actions: [
          TextButton(
            onPressed: () async {
              Provider.of<teams>(context, listen: false).deleteDepartment(department);
            },
            child: Text("Confirm"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        ],
      );
    });
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    initialize(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("Team", style: TextStyle(fontSize: 20, color: Colors.black),),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black,),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => settings()));
            },
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // drop_down(),
          Flexible(
            fit: FlexFit.tight,
            child: Consumer<teams>(
              builder: (context, teams, child){
                return ListView.builder(
                    itemCount: teams.getDepartmentsLength,
                    itemBuilder: (context, index) {
                      List<Users> admins = teams.getAdmins(index);
                      List<Users> employees = teams.getEmployees(index);
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        margin: EdgeInsets.all(16),
                        elevation: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(25, 10, 10, 10),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: SingleChildScrollView(scrollDirection: Axis.horizontal,
                                          child: Text(teams.getDepartments.elementAt(index).Name!, maxLines: 1,overflow: TextOverflow.fade,style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),))),
                                  IconButton(
                                    padding: const EdgeInsets.all(1.0),
                                    icon: Icon(Icons.delete, color: Colors.redAccent,),
                                    onPressed: () {
                                      deleteDepartment(context, teams.getDepartments.elementAt(index));
                                    },
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                              child: Row(
                                children: [
                                  Expanded(child: Text("No. of Employees", style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.5)),)),
                                  Expanded(child: Text("no. of Admins", style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.5)),)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(25, 5, 25, 0),
                              child: Row(
                                children: [
                                  Expanded(child: Text(employees.length.toString(), style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 1)),)),
                                  Expanded(child: Text(admins.length.toString(), style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 1)),)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(25,10,25,0),
                              child: Text("Employees", style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.5)),),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                              height: 50,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: employees.length,
                                itemBuilder: (context, index) {
                                  return ChoiceChip(
                                    label: Text(employees.elementAt(index).Name!),
                                    selected: false,
                                  );
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(25,10,25,0),
                              child: Text("Admins", style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.5)),),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                              height: 50,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: admins.length,
                                itemBuilder: (context, index) {
                                  return ChoiceChip(
                                    label: Text(admins.elementAt(index).Name!),
                                    selected: false,
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(25, 5, 25, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => clientloader(teams.getDepartments.elementAt(index), employees, admins)));
                                    },
                                    color: Color.fromRGBO(46, 49, 146, 1),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text("Show All", style: TextStyle(color: Colors.white, fontSize: 25),),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
            ),
          )
        ],
      ),
    );
  }
}

// class drop_down extends StatefulWidget {
//   const drop_down({Key? key}) : super(key: key);
//
//   @override
//   _drop_downState createState() => _drop_downState();
// }
//
// class _drop_downState extends State<drop_down> {
//   String value = "Clients";
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton(
//         value: value,
//         items: [
//           DropdownMenuItem(child: Text("Clients", style: TextStyle(fontSize: 16, color: Colors.black),),
//             value: "Clients",),
//           DropdownMenuItem(child: Text("Employees", style: TextStyle(fontSize: 16, color: Colors.black),),
//             value: "Employees",),
//         ],
//         onChanged: (String? val) {
//           setState(() {
//             value = val!;
//           });
//         },
//       borderRadius: BorderRadius.circular(15),
//       underline: DropdownButtonHideUnderline(child: Container()),
//     );
//   }
// }

