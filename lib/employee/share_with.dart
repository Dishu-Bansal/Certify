import 'package:amplify_flutter/amplify.dart';
import 'package:certify/models/AccessLevel.dart';
import 'package:certify/models/Users.dart';
import 'package:flutter/material.dart';

import 'file_details.dart';

List<Users> selected = List.empty(growable: true);
class share_with extends StatefulWidget {

  //String path;
  share_with({Key? key}) : super(key: key);

  @override
  _share_withState createState() => _share_withState();
}

class _share_withState extends State<share_with> {

  //String path;
  bool loading=true;

  List<Users> employees = List.empty(growable: true);
  _getEmployees() async {
    employees = await Amplify.DataStore.query(Users.classType, where: Users.ACCESS.eq(AccessLevel.EMPLOYEE));
    setState(() {
      loading=false;
    });
  }

  @override
  void initState(){
    _getEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Share With", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
      ),
      body: loading ? Center(child: CircularProgressIndicator(),) : Column(
        children: [
          Flexible(
            child: Container(
              child: ListView.builder(
                itemCount: employees.length,
                  itemBuilder: (context, index) {
                  return employee_tile(employees.elementAt(index));
                  }
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Next", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),),
                    ),
                    onPressed: () {
                      Navigator.pop(context, selected.toSet().toList());
                      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => file_details(selected, path)));
                    },
                    color: Color.fromRGBO(46, 49, 146, 1),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class employee_tile extends StatefulWidget {
  Users employee;

  employee_tile(Users this.employee, {Key? key}) : super(key: key);

  @override
  _employee_tileState createState() => _employee_tileState(employee);
}

class _employee_tileState extends State<employee_tile> {
  Users employee;
  bool value=false;

  _employee_tileState(Users this.employee);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(flex: 1,
              child: Text(employee.Name!,overflow: TextOverflow.fade, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),)),
          Checkbox(
              value: value,
              onChanged: (bool? val) {
                if(val!) {
                    selected.add(employee);
                    print("Selected: " + selected.toString());
                  }
                else {
                    selected.removeWhere((element) {
                      return employee.Email == element.Email;
                    });
                    print("Selected: " + selected.toString());
                  }
                setState(() {
                  value=val;
                });
              })
        ],
      ),
    );
  }
}

