import 'package:certify/models/Files.dart';
import 'package:certify/models/Users.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../settings.dart';
import 'admin_files_class.dart';


class files_shared extends StatelessWidget {
  Users user;
  List<Users> employees;
  files_shared(Users this.user,List<Users> this.employees, {Key? key}) : super(key: key);

  initialize(BuildContext context){
    print("User is: " + user.Department!);
    print("Employees are: " + employees.toString());
    Provider.of<admin_files_class>(context).initializeFilesforAdmin(user.Department!, employees);
  }

  @override
  Widget build(BuildContext context) {
    //initialize(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("Files Shared", style: TextStyle(color: Colors.black),),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            color: Colors.black,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => settings()));
            },
          )
        ],
      ),
      body: Consumer<admin_files_class>(
        builder: (context, files, child){
          print("12: " + files.getFilesAdmin.toString());
          return ListView.builder(
              itemCount: files.getAdminFilesLength,
              itemBuilder: (context, index) {
                return files_card(files.getFile(index), files.getFileEmployees(index)!);
              });
        },
      ),
    );
  }
}

class files_card extends StatelessWidget {
  Files file;
  List<String> employees;
  files_card(Files this.file, List<String> this.employees, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: Color.fromRGBO(0, 0, 0, 0.3),
      margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(25, 10, 0, 0),
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Icon(Icons.image, size: 35,),
                ),
              ),
              Flexible(flex: 1,fit: FlexFit.tight,child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                child: Text(file.Name!, overflow: TextOverflow.fade,maxLines: 1, softWrap: false, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
              )),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 25, 0),
                child: Text(DateFormat("dd/MM/yyyy").format(DateTime.fromMillisecondsSinceEpoch(int.parse(file.key!))), style: TextStyle(fontSize: 14, color: Color.fromRGBO(0, 0, 0, 0.5)),),
              )
            ],
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.fromLTRB(25,10,25,0),
            child: Text("Comments", style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.5)),),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25,2,25,0),
            child: Text(file.Comment!,
              style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.8)),),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25,10,25,0),
            child: Text("Shared With", style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.5)),),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25,2,25,0),
            child: ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index){
                return ChoiceChip(
                  selected: true,
                  label: Text(employees.elementAt(index)),
                  selectedColor: Colors.grey[200],
                  labelStyle: TextStyle(color: Colors.black),
                );
              },
            ),
          ),
          Center(
            child: MaterialButton(
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.download, color: Colors.blue, size: 20,),
                  SizedBox(width: 5,),
                  Text("Download", style: TextStyle(fontSize: 25),)
                ],
              ),
              textColor: Colors.blue,
            ),
          )
        ],
      ),
    );
  }
}

