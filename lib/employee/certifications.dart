import 'dart:io';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:certify/admin/current_user.dart';
import 'package:certify/employee/picture.dart';
import 'package:certify/models/Certificates.dart';
import 'package:certify/models/Users.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:provider/provider.dart';

import '../settings.dart';
import 'certificate_provider.dart';
import 'files.dart';


class certify_main extends StatefulWidget {
  const certify_main({Key? key}) : super(key: key);

  @override
  _certify_mainState createState() => _certify_mainState();
}

class _certify_mainState extends State<certify_main> {
  int selectedindex =0;

  _onTapped(int index){
    setState(() {
      selectedindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: selectedindex ==0 ? MultiProvider(
          providers: [
            ChangeNotifierProvider<certificate_provider>(create: (_) => certificate_provider())
          ],
        child: certifications(null, null),
      ) : files(null, null),
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

class certifications extends StatefulWidget {
  List<Certificates>? certifica;
  Users? employee;
  certifications(List<Certificates>? this.certifica, Users? this.employee, {Key? key}) : super(key: key);

  @override
  _certificationsState createState() => _certificationsState(certifica, employee);
}
CurrentUser currentUser = CurrentUser();
class _certificationsState extends State<certifications> {

  List<Certificates>? certifica;
  Users? employee;
  CurrentUser currentUser = CurrentUser();
  List<Certificates> certificates = List.empty(growable: true);
  bool loading=true;

  _certificationsState(List<Certificates>? this.certifica, Users? this.employee);

  @override
  void initState(){
    super.initState();
    print("Employee is: " + employee.toString());
    if(employee == null)
      {
        getCertificates();
      }
    else
      {
        getEmployeeCertificates(employee!);
      }
  }

  getCertificates() async {
    AuthUser us = await Amplify.Auth.getCurrentUser();
    String user = us.userId;
    certificates = await Amplify.DataStore.query(Certificates.classType, where: Certificates.USER.eq(user));
    setState(() {
      loading = false;
    });
  }

  getEmployeeCertificates(Users employee) async {
    String user = employee.id;
    certificates = await Amplify.DataStore.query(Certificates.classType, where: Certificates.USER.eq(user));
    setState(() {
      loading=false;
    });
  }

  // getCertificates() async {
  //   await Provider.of<certificate_provider>(context, listen: false).getCertificates();
  //   // setState(() {
  //   //   loading = false;
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Certifications", style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: certifica == null ? SizedBox(): IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_back, color: Colors.black,)),
        actions: certifica == null ? [
          IconButton(
            icon: Icon(Icons.settings),
            color: Colors.black,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => settings()));
            },
          )
        ] : [SizedBox()],
      ),
      backgroundColor: Color.fromRGBO(250, 250, 254, 1),
      body: loading ? Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        CircularProgressIndicator(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Loading Certificates", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
        )
      ],),): ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Certificate_card(certificates.elementAt(index), currentUser);
        },
        itemCount: certificates.length,
      ),
      floatingActionButton: certifica == null ? FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => picture()));
        },
        backgroundColor: Color.fromRGBO(46, 49, 146, 1),
        child: Icon(Icons.camera),
      ) : SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class Certificate_card extends StatefulWidget {
  Certificates certificate;
  CurrentUser currentUser;
  Certificate_card(Certificates this.certificate, CurrentUser this.currentUser, {Key? key}) : super(key: key);

  @override
  _Certificate_cardState createState() => _Certificate_cardState(certificate);
}

class _Certificate_cardState extends State<Certificate_card> {
  Certificates certificate;
  double download_progress=0;
  String image_file="";
  bool downloaded=false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _downloadImage();
  }

  void _downloadImage() async {
    final direct = await getApplicationDocumentsDirectory();
    image_file = direct.path + "/" + certificate.Name! + ".jpg";
    await Amplify.Storage.downloadFile(
        key: certificate.key!,
        local: File(image_file),
        onProgress: (progress) {
          print("Progress: " + progress.getFractionCompleted().toString());
          // setState(() {
          //   download_progress = progress.getFractionCompleted();
          // });
        }
    );
    // setState(() {
    //   downloaded = true;
    // });
  }

  void saveImage() async {
    _ShowToast("Starting Download");
    await GallerySaver.saveImage(image_file);
    _ShowToast("Download complete");
  }

  _Certificate_cardState(Certificates this.certificate);

  _ShowToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

@override
Widget build(BuildContext context) {

  return Card(
    elevation: 10,
    shadowColor: Color.fromRGBO(0, 0, 0, 0.3),
    margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Column(
      children: [
        Row(
          children: [
            Flexible(flex: 1,fit: FlexFit.tight,child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
              child: SingleChildScrollView(scrollDirection: Axis.horizontal,child: Text(certificate.Name!, overflow: TextOverflow.fade,maxLines: 1, softWrap: false, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.left,)),
            )),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 25, 0),
              child: Text(DateFormat("d LLL, yy", ).format(DateTime.fromMillisecondsSinceEpoch(int.parse(certificate.Link!.length > 20 ? certificate.key! : certificate.Link!))), style: TextStyle(fontSize: 14, color: Color.fromRGBO(0, 0, 0, 0.5)),),
            )
          ],
        ),
        SizedBox(height: 10,),
        Row(
          children: [
            Flexible(flex: 1,fit: FlexFit.tight,child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
              child: Text("Expiry Date", style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.5)),),
            )),
            Flexible(flex: 1,fit: FlexFit.tight, child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text("Date of Issue", style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.5)),),
            ))
          ],
        ),
        Row(
          children: [
            Flexible(flex: 1,fit: FlexFit.tight,child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 2, 0, 0),
              child: Text(certificate.ExpiryDate!, style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.8)),),
            )),
            Flexible(flex: 1,fit: FlexFit.tight, child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
              child: Text(certificate.IssueDate!, style: TextStyle(fontSize: 12, color: Color.fromRGBO(0, 0, 0, 0.8)),),
            ))
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 125,
                margin: EdgeInsets.all(10),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: downloaded ? Image.file(File(image_file), fit: BoxFit.fill,) : Icon(Icons.image),
                ),
              ),
            ),
          ],
        ),
        MaterialButton(
          onPressed: () {
            saveImage();
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
        widget.currentUser.isCompany ? MaterialButton(
          onPressed: () async {
            await Amplify.DataStore.delete(certificate);
            Navigator.pop(context);
          },
          child: const Icon(Icons.delete, color: Colors.black,),
          color: Colors.redAccent,
        ) : const SizedBox(),
      ],
    ),
  );
}
}

