import 'dart:io';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:camera/camera.dart';
import 'package:certify/employee/certifications.dart';
import 'package:certify/models/CertificateTypes.dart';
import 'package:certify/models/Certificates.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';


String expirydate="", issuedate="", name="";


class certificate_details extends StatefulWidget {
  XFile image;
  certificate_details({Key? key, required XFile this.image}) : super(key: key);

  @override
  _certificate_detailsState createState() => _certificate_detailsState(image);
}

List<CertificateTypes> certificates = List.empty(growable: true);

class _certificate_detailsState extends State<certificate_details> {
  XFile image;
  bool loaded=false;

  _certificate_detailsState(XFile this.image);

  getCertificates() async {
    certificates = await Amplify.DataStore.query(CertificateTypes.classType);
    setState(() {
      loaded=true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCertificates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Details", style: TextStyle(fontSize: 25, color: Colors.black),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: loaded ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          preview(image: image),
          text1(),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
            child: form(),
          ),
          Row(
            children: [
              text2(),
              text3()
            ],
          ),
          Row(
            children: [
              Expanded(child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 8, 15, 0),
                child: date_form1(),
              )),
              Expanded(child: Padding(
                padding: const EdgeInsets.fromLTRB(5,8,25,0),
                child: date_form2(),
              ),)
            ],
          ),
          Spacer(flex: 1,),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: MaterialButton(
                    onPressed: () {},
                    child: Text("Cancel", style: TextStyle(color: Colors.black, fontSize: 20),),
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                  child: submit_button(image),
                ),
              ),
            ],
          )
        ],
      ) : Center (child: CircularProgressIndicator(),),
    );
  }
}

class submit_button extends StatefulWidget {
  XFile image;
  submit_button(XFile this.image, {Key? key}) : super(key: key);

  @override
  _submit_buttonState createState() => _submit_buttonState(image);
}

class _submit_buttonState extends State<submit_button> {
  XFile image;
  _submit_buttonState(XFile this.image);


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

  bool uploading=false;
  String upload_progress="0";
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        if(!uploading)
          {
            setState(() {
              uploading=true;
            });
            if(name.isNotEmpty && name != null)
              {
                if(issuedate.isNotEmpty)
                  {
                    // if(expirydate.isNotEmpty)
                    //   {
                        String unique = DateTime.now().millisecondsSinceEpoch.toString();
                        AuthUser user = await Amplify.Auth.getCurrentUser();
                        try {
                          final UploadFileResult result = await Amplify.Storage.uploadFile(
                              local: new File(image.path),
                              key: unique,
                              onProgress: (progress) {
                                print("Fraction completed: " + progress.getFractionCompleted().toString());
                                setState(() {
                                  upload_progress = (progress.getFractionCompleted() * 100).toStringAsPrecision(3);
                                });
                              }
                          );
                          print('Successfully uploaded file: ${result.key}');
                          GetUrlResult res = await Amplify.Storage.getUrl(key: unique, options: GetUrlOptions());
                          String url = res.url;
                          await Amplify.DataStore.save(new Certificates(Name: name, IssueDate: issuedate, ExpiryDate: expirydate, User: user.userId, Link: url, key: unique));
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => certify_main()));
                        } on StorageException catch (e) {
                          print('Error uploading file: $e');
                          _ShowToast("Error: Please try again or contact the developer");
                          setState(() {
                            uploading=false;
                          });
                        }
                    //   }
                    // else
                    //   {
                    //     _ShowToast("Please select an expiry date");
                    //     setState(() {
                    //       uploading=false;
                    //     });
                    //   }
                  }
                else
                  {
                    _ShowToast("Please select an issue date");
                    setState(() {
                      uploading=false;
                    });
                  }
              }
            else
              {
                _ShowToast("Please select an certificate name");
                setState(() {
                  uploading=false;
                });
              }
          }
      },
      child: uploading? Text(upload_progress+"%", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),): Text("Submit", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
      color: Color.fromRGBO(46, 49, 146, 1),
      padding: EdgeInsets.all(15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    );
  }
}



class date_form1 extends StatefulWidget {
  const date_form1({Key? key}) : super(key: key);

  @override
  _date_form1State createState() => _date_form1State();
}

class _date_form1State extends State<date_form1> {

  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        label: Text("DD/MM/YYYY", style: TextStyle(fontSize: 12),),
        suffixIcon: Icon(Icons.calendar_today_outlined, color: Colors.black,),
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
      ),
      controller: _controller,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context, initialDate: DateTime.now(),
            firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2101)
        );
        if(pickedDate != null ){
          print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
          String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
          print(formattedDate); //formatted date output using intl package =>  2021-03-16
//you can implement different kind of Date Format here according to your requirement
          setState(() {
            issuedate = formattedDate.trim().toLowerCase();
            setState(() {
              _controller.text = formattedDate;
            });
//set output date to TextField value.
          });
        }else{
          print("Date is not selected");
        }
      },
    );
  }
}

class date_form2 extends StatefulWidget {
  const date_form2({Key? key}) : super(key: key);

  @override
  _date_form2State createState() => _date_form2State();
}

class _date_form2State extends State<date_form2> {

  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          label: Text("DD/MM/YYYY", style: TextStyle(fontSize: 12),),
          suffixIcon: Icon(Icons.calendar_today_outlined, color: Colors.black,),
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
      ),
      controller: _controller,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context, initialDate: DateTime.now(),
            firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2101)
        );
        if(pickedDate != null ){
          print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
          String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
          print(formattedDate); //formatted date output using intl package =>  2021-03-16
//you can implement different kind of Date Format here according to your requirement
          setState(() {
            expirydate = formattedDate.trim().toLowerCase();
            setState(() {
              _controller.text = formattedDate;
            });
//set output date to TextField value.
          });
        }else{
          print("Date is not selected");
        }
      },
    );
  }
}

class text3 extends StatelessWidget {
  const text3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(flex: 1,fit: FlexFit.tight, child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Text("Date of Expiry", style: TextStyle(fontSize: 15, color: Color.fromRGBO(0, 0, 0, 1), fontWeight: FontWeight.bold),),
    ));
  }
}


class text2 extends StatelessWidget {
  const text2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(flex: 1,fit: FlexFit.tight,child: Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
      child: Text("Date of Issue", style: TextStyle(fontSize: 15, color: Color.fromRGBO(0, 0, 0, 1), fontWeight: FontWeight.bold),),
    ));
  }
}

class text1 extends StatelessWidget {
  const text1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
      child: Text("Certificate Type", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
    );
  }
}


class preview extends StatelessWidget {
  XFile image;
  preview({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.file(new File(image.path), fit: BoxFit.fill,)),
    );
  }
}

class form extends StatefulWidget {
  const form({Key? key}) : super(key: key);

  @override
  _formState createState() => _formState();
}

class _formState extends State<form> {

  String? value=null;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, width: 1
        ),
        borderRadius: BorderRadius.circular(15)
      ),
      padding: EdgeInsets.fromLTRB(10, 2, 10, 1),
      child: DropdownButton<String>(
        value: value,
        hint: Text("Select an option"),
        onChanged: (String? val) {
          name = val.toString();
          setState(() {
            value = val!.toString();
          });
        },
        underline: DropdownButtonHideUnderline(child: Container()),
        items: certificates.map((certificate) {
          return DropdownMenuItem<String>(
            child: Text(certificate.Name!, style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5)),),
            value: certificate.Name!,
          );
        }).toList(),
        borderRadius: BorderRadius.circular(15),
        isExpanded: true,
      ),
    );
  }
}

