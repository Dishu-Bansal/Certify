import 'dart:io';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:certify/admin/current_user.dart';
import 'package:certify/models/FileToUser.dart';
import 'package:certify/models/Files.dart';
import 'package:certify/models/Users.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../settings.dart';


class files extends StatefulWidget {
  List<Files>? fi;
  Users? employee;
  files(List<Files>? this.fi, Users? this.employee, {Key? key}) : super(key: key);

  @override
  _filesState createState() => _filesState(fi, employee);
}

class _filesState extends State<files> {
  List<Files>? fi;
  Users? employee;

  List<Files> files = List.empty(growable: true);
  bool loaded=false;

  _filesState(List<Files>? this.fi, Users? this.employee);

  getFiles() async {
    String id="";
    if(employee == null)
      {
        AuthUser u = await Amplify.Auth.getCurrentUser();
        id = u.userId;
      }
    else
      {
        id = employee!.id;
      }
    //List<Users> us = await Amplify.DataStore.query(Users.classType, where: Users.EMAIL.eq(u.username));
    List<FileToUser> filesrelations = await Amplify.DataStore.query(FileToUser.classType, where: FileToUser.USERID.eq(id));
    for(FileToUser relation in filesrelations){
      List<Files> file = await Amplify.DataStore.query(Files.classType, where: Files.KEY.eq(relation.FileKey));
      files.addAll(file);
    }
    await Provider.of<CurrentUser>(context, listen: false).getCurrentUser();
    print("Files: " + files.toString());
    setState(() {
      loaded=true;
    });
  }

  @override
  void initState(){
    super.initState();
    // if(fi == null)
    //   {
        getFiles();
    //   }
    // else
    //   {
    //     files = fi!;
    //     loaded = true;
    //   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Files Shared", style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: fi == null ? SizedBox() : IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Colors.black,)),
          actions: fi == null ? [
            IconButton(
              icon: Icon(Icons.settings),
              color: Colors.black,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => settings()));
              },
            )
          ] : [SizedBox()]
      ),
      backgroundColor: Color.fromRGBO(250, 250, 254, 1),
      body: loaded ? ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return files_card(files.elementAt(index), employee);
        },
        itemCount: files.length,
      ) : Center(child: CircularProgressIndicator(),),
      // floatingActionButton: fi == null ? FloatingActionButton(
      //   onPressed: () async {
      //     FilePickerResult? result = await FilePicker.platform.pickFiles();
      //
      //     if (result != null) {
      //       List<Users> selected = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => share_with()));
      //       Navigator.of(context).push(MaterialPageRoute(builder: (context) => file_details(selected, result.files.single)));
      //     } else {
      //       // User canceled the picker
      //     }
      //   },
      //   backgroundColor: Color.fromRGBO(46, 49, 146, 1),
      //   child: Icon(Icons.file_copy),
      // ) : SizedBox(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class files_card extends StatelessWidget {
  Files file;
  Users? employee;
  String file_path="";
  files_card(Files this.file, Users? this.employee, {Key? key}) : super(key: key);

  _ShowToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.black,
        fontSize: 16.0
    );
  }

  void _downloadFile() async {
    _ShowToast("Starting Download");
    final direct = await getApplicationDocumentsDirectory();
    file_path = direct.path + "/" + file.Name! + ".jpg";
    await Amplify.Storage.downloadFile(
        key: file.key!,
        local: File(file_path),
        onProgress: (progress) {
          print("Progress: " + progress.getFractionCompleted().toString());
        }
    );
    _ShowToast("Download Complete");
  }

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
                child: SingleChildScrollView(scrollDirection: Axis.horizontal,child: Text(file.Name!, overflow: TextOverflow.fade,maxLines: 1, softWrap: false, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.left,)),
              )),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 25, 0),
                child: Text(DateFormat("dd/MM/yy").format(DateTime.fromMillisecondsSinceEpoch(int.parse(file.key!))), style: TextStyle(fontSize: 14, color: Color.fromRGBO(0, 0, 0, 0.5)),),
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
          Center(
            child: MaterialButton(
              onPressed: () {
                _downloadFile();
              },
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
          Provider.of<CurrentUser>(context, listen: false).isCompany ? Center(
            child: MaterialButton(
              onPressed: () async {
                FileToUser f = (await Amplify.DataStore.query(FileToUser.classType, where: FileToUser.FILEKEY.eq(file.key).and(FileToUser.USERID.eq(employee!.id)))).first;
                await Amplify.DataStore.delete(f);
                Navigator.pop(context);
              },
              child: const Icon(Icons.delete, color: Colors.black,),
              color: Colors.redAccent,
            ),
          ) : const SizedBox(),
        ],
      ),
    );
  }
}
