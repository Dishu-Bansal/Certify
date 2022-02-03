import 'package:amplify_flutter/amplify.dart';
import 'package:certify/admin/current_user.dart';
import 'package:certify/company/allteams.dart';
import 'package:certify/employee/certificate_provider.dart';
import 'package:certify/employee/certifications.dart';
import 'package:certify/employee/files.dart';
import 'package:certify/models/AccessLevel.dart';
import 'package:certify/models/Certificates.dart';
import 'package:certify/models/Departments.dart';
import 'package:certify/models/Files.dart';
import 'package:certify/models/Users.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


CurrentUser currentUser = CurrentUser();
class employee_details extends StatelessWidget {
  Users employee;
  List<Certificates> certificates;
  List<Files> file_list;
  employee_details(Users this.employee, List<Certificates> this.certificates, List<Files> this.file_list, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(employee.Name!, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black),),
                currentUser.isCompany ? IconButton(
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder: (context) {
                            String newname="";
                            return AlertDialog(
                              title: Text("Set a new name"),
                              content: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Name",
                                ),
                                onChanged: (val) {
                                  newname = val;
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    await Amplify.DataStore.save(employee.copyWith(Name: newname));
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => teamloader()));
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
                    },
                    icon: Icon(Icons.edit, color: Colors.black,)) : SizedBox(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(employee.Department!, style: TextStyle(fontSize: 12, color: Colors.black87),),
                currentUser.isCompany ? IconButton(
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder: (context) {
                            return department_dialog(employee);
                          });
                    },
                    icon: Icon(Icons.edit, color: Colors.black,)) : SizedBox(),
              ],
            ),
            currentUser.isCompany ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                promote(employee),
                demote(employee),
              ],
            ) : button(employee),
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
                          child: Text("Certifications:", style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.5)),),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,25),
                          child: Text(certificates.length.toString(), style: TextStyle(fontSize: 12, color: Colors.black),)
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
                          child: Text(file_list.length.toString(), style: TextStyle(fontSize: 12, color: Colors.black),)
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
                  child: Text("Certifications", style: TextStyle(fontSize: 20,), textAlign: TextAlign.center,),),
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: MaterialButton(
                      onPressed: ()  {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => certifications(certificates, employee)));
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
                itemCount: certificates.length,
                itemBuilder: (context, index) {
                  Certificates c = certificates.elementAt(index);
                  return Card(
                    margin: EdgeInsets.all(10),
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
                          child: Text(c.Name!, style: TextStyle(fontSize: 18),),
                        ),
                        Text(c.IssueDate! + " - " + c.ExpiryDate!, style: TextStyle(fontSize: 14),)
                      ],
                    ),
                  );
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
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => files(file_list, employee)));
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
                itemCount: file_list.length,
                itemBuilder: (context, index) {
                  Files f = file_list.elementAt(index);
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
        ),
      ),
    );
  }
}

class button extends StatefulWidget {
  Users employee;
  button(Users this.employee, {Key? key}) : super(key: key);

  @override
  _buttonState createState() => _buttonState();
}

class _buttonState extends State<button> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        Users a = widget.employee.copyWith(Access: AccessLevel.CLIENT);
        if(!loading)
          {
            setState(() {
              loading = true;
            });
            await Amplify.DataStore.save(a);
            loading = false;
            Navigator.pop(context);
          }
      },
      child: Text("Upgrade to Client", style: TextStyle(color: Colors.white, fontSize: 16),),
      color: Color.fromRGBO(46, 49, 146, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }
}
class promote extends StatefulWidget {
  Users employee;
  promote(Users this.employee, {Key? key}) : super(key: key);

  @override
  _promoteState createState() => _promoteState();
}

class _promoteState extends State<promote> {
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        Users a = widget.employee.copyWith(Access: AccessLevel.COMPANY);
        if(!loading)
        {
          setState(() {
            loading = true;
          });
          await Amplify.DataStore.save(a);
          loading = false;
          Navigator.pop(context);
        }
      },
      child: Text("Promote to Company", style: TextStyle(color: Colors.white, fontSize: 16),),
      color: Color.fromRGBO(46, 49, 146, 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }
}

class demote extends StatefulWidget {
  Users employee;
  demote(Users this.employee, {Key? key}) : super(key: key);

  @override
  _demoteState createState() => _demoteState();
}

class _demoteState extends State<demote> {
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        Users a = widget.employee.copyWith(Access: AccessLevel.EMPLOYEE);
        if(!loading)
        {
          setState(() {
            loading = true;
          });
          await Amplify.DataStore.save(a);
          loading = false;
          Navigator.pop(context);
        }
      },
      child: Text("Demote to Employee", style: TextStyle(color: Colors.white, fontSize: 16),),
      color: Colors.redAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }
}


class department_dialog extends StatefulWidget {
  Users employee;
  department_dialog(Users this.employee, {Key? key}) : super(key: key);

  @override
  _department_dialogState createState() => _department_dialogState();
}

class _department_dialogState extends State<department_dialog> {

  List<Departments> departments = List.empty(growable: true);
  bool loading = true;
  String value="";
  getDepartments() async {
    departments = await Amplify.DataStore.query(Departments.classType);
    value = departments.first.Name!;
    setState(() {
      loading = false;
    });
  }


  @override
  void initState() {
    super.initState();
    getDepartments();
  }

  @override
  Widget build(BuildContext context) {
    String newname="";
    return AlertDialog(
      title: Text("Set a new name"),
      content: loading ? Center(child: CircularProgressIndicator(),) : Container(
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
            newname=val.toString();
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
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await Amplify.DataStore.save(widget.employee.copyWith(Department: value));
            Navigator.push(context, MaterialPageRoute(builder: (_) => teamloader()));
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
    );;
  }
}


