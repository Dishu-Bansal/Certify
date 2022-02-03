import 'package:amplify_flutter/amplify.dart';
import 'package:certify/admin/admin_files_class.dart';
import 'package:certify/admin/certificate_class.dart';
import 'package:certify/admin/current_user.dart';
import 'package:certify/admin/employee_details.dart';
import 'package:certify/company/allteams.dart';
import 'package:certify/employee/file_details.dart';
import 'package:certify/employee/share_with.dart';
import 'package:certify/models/Certificates.dart';
import 'package:certify/models/FileToUser.dart';
import 'package:certify/models/Files.dart';
import 'package:certify/models/Users.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../settings.dart';
import 'employee_class.dart';
import 'files_class.dart';
//import 'files_shared.dart';

class forloader extends StatelessWidget {
  Users user;
  forloader(Users this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Employee>(create: (context) => Employee()),
        ChangeNotifierProvider<Certificate>(create: (context) => Certificate()),
        ChangeNotifierProvider<files_class>(create: (context) => files_class()),
        ChangeNotifierProvider<admin_files_class>(create: (context) => admin_files_class()),
      ],
      child: Scaffold(
        body: team(user),
      ),
    );
  }
}

class team extends StatefulWidget {

  Users user;
  team(Users this.user, {Key? key}) : super(key: key);

  @override
  _teamState createState() => _teamState(user);
}

class _teamState extends State<team> {

  int selectedindex =0;
  Users user;

  _teamState(Users this.user);

  _onTapped(int index){
    setState(() {
      selectedindex = index;
    });
  }

  initialize(BuildContext context) async {
    print("Department is: " + user.Department!);
    await Provider.of<Employee>(context, listen: false).initializeEmployees(user.Department!);
    if(selectedindex == 1)
      {
        await Provider.of<admin_files_class>(context, listen: false).initializeFilesforAdmin(user.Department!, Provider.of<Employee>(context, listen: false).getEmployees);
      }
  }

  @override
  void initState() {
    super.initState();
    //initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    initialize(context);
    return Scaffold(
        body: selectedindex == 0 ? team_main(user) : Consumer<Employee>(
            builder: (context, employee, child) {
             return files_shared(user, employee.getEmployees);
            }),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedindex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.wc), label: 'Certifications'),
            BottomNavigationBarItem(icon: Icon(Icons.sick), label: 'Files')
          ],
          onTap: _onTapped,
        ),
      );
  }
}

class team_main extends StatelessWidget {
  Users user;

  team_main(Users this.user,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //initialize(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("My Team", style: TextStyle(color: Colors.black),),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
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
        body: Consumer<Employee>(
          builder: (context, Employee, child) {
            return ListView.builder(
              itemCount: Employee.getEmployeesLength,
              itemBuilder: (context, index) {
                return team_tile(Employee.getEmployees.elementAt(index));
              },
            );
          },
        ),
    );
  }
}

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
                print("1: " + files.getFile(index).toString());
                print("2: " + files.getFileEmployees(index).toString());
                return files_card(files.getFile(index), files.getFileEmployees(index)!, false);
              });
        },
      ),
      floatingActionButton:FloatingActionButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles();
          if (result != null) {
            List<Users> selected = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => share_with()));
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => file_details(selected, result.files.single)));
          } else {
            // User canceled the picker
          }
        },
        backgroundColor: Color.fromRGBO(46, 49, 146, 1),
        child: Icon(Icons.file_copy),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class files_card extends StatelessWidget {
  Files file;
  List<String> employees;
  bool admin;
  files_card(Files this.file, List<String> this.employees, bool this.admin, {Key? key}) : super(key: key);

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
            child: Text(file.Comment == null ? "" : file.Comment!,
              style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.8)),),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25,10,25,0),
            child: Text("Shared With", style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.5)),),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25,2,25,0),
            child: Container(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
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
          ),
          CurrentUser().isCompany ? Center(
            child: MaterialButton(
              onPressed: () async {
                List<FileToUser> f = await Amplify.DataStore.query(FileToUser.classType, where: FileToUser.FILEKEY.eq(file.key));
                for(FileToUser f2 in f){
                  await Amplify.DataStore.delete(f2);
                }
                await Amplify.DataStore.delete(file);
                Navigator.pop(context);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete, color: Colors.black, size: 20,),
                ],
              ),
              textColor: Colors.black,
              color: Colors.redAccent,
            ),
          ): SizedBox(),
        ],
      ),
    );
  }
}

class team_tile extends StatefulWidget {
  Users employee;
  team_tile(Users this.employee, {Key? key}) : super(key: key);

  @override
  _team_tileState createState() => _team_tileState(employee);
}

class _team_tileState extends State<team_tile> {
  Users employee;
  List<Certificates> certificates = List.empty(growable: true);
  List<Files> files = List.empty(growable: true);
  bool loading= true;

  _team_tileState(Users this.employee);

  initialize(BuildContext context) async {
    certificates = await Amplify.DataStore.query(Certificates.classType, where: Certificates.USER.eq(employee.id));
    files = await Provider.of<files_class>(context, listen: false).initializeFiles(employee.id);
    setState(() {
      loading = false;
    });
  }

  Certificates getClosestExpiry() {
    certificates.sort((c1, c2) {
      return DateFormat("dd/MM/yyyy").parse(c1.ExpiryDate!.isEmpty ? "01/01/2099" : c1.ExpiryDate!).compareTo(DateFormat("dd/MM/yyyy").parse(c1.ExpiryDate!.isEmpty ? "01/01/2099" : c1.ExpiryDate!));
    });
    return certificates.first;
  }

  Files getLatestFile() {
    files.sort((c1, c2) {
      return int.parse(c1.key!) - int.parse(c2.key!);
    });
    return files.last;
  }

  @override
  void initState() {
    super.initState();
    initialize(context);
  }

  deleteAllFiles() async {
    for(Files f in files){
      FileToUser f2 = (await Amplify.DataStore.query(FileToUser.classType, where: FileToUser.FILEKEY.eq(f.key).and(FileToUser.USERID.eq(employee.id)))).first;
      await Amplify.DataStore.delete(f2);
    }
  }

  deleteAllCertificates() async {
  for(Certificates c in certificates){
    await Amplify.DataStore.delete(c);
  }
  }

  deleteUser() async {
    await Amplify.DataStore.delete(employee);
  }

  @override
  Widget build(BuildContext context) {
    //initialize(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(16),
      elevation: 10,
      child: loading ? Center(child: CircularProgressIndicator(),) : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(employee.Name!, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                CurrentUser().isCompany ? IconButton(
                    onPressed: () {
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          content: loading ? Center(child: CircularProgressIndicator(),) : Text("This will delete all employee data including the certificates and files shared. This is IRREVERSIBLE."),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                deleteAllFiles();
                                deleteAllCertificates();
                                deleteUser();
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
                    icon: Icon(Icons.delete, color: Colors.redAccent,),
                ) : SizedBox(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: Row(
              children: [
                Expanded(child: Text("No. of Certificates", style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.5)),)),
                Expanded(child: Text("Files Shared", style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.5)),)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(25, 5, 25, 0),
            child: Row(
              children: [
                Expanded(child: Text(certificates.length.toString(), style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 1)),)),
                Expanded(child: Text(files.length.toString(), style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 1)),)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(25, 16, 25, 0),
            child: Text("Closest Expiry Date", style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.5)),),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(25, 5, 25, 0),
              child: Text(certificates.isEmpty ? "No Certificates" : getClosestExpiry().ExpiryDate! + " - " + getClosestExpiry().Name!, style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 1)),),
            //Text("30 December, 2021 - Certificate Type", style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 1)),),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(25, 16, 25, 0),
            child: Text("Latest File Shared", style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.5)),),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(25, 5, 25, 0),
              child:  Text(files.isEmpty ? "No File" : getLatestFile().Name!, style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 1)),),
            //Text("File 3.pdf on 7 December, 2021", style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 1)),),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(25, 5, 25, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<Certificate>(
                  builder: (context, certificate, child){
                    return Consumer<files_class>(
                      builder: (context, file, child){
                        return MaterialButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => employee_details(employee, certificates, files)));
                          },
                          color: Color.fromRGBO(46, 49, 146, 1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text("Show All", style: TextStyle(color: Colors.white, fontSize: 25),),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

