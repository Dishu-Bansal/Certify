import 'dart:io';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:certify/models/FileToUser.dart';
import 'package:certify/models/Files.dart';
import 'package:certify/models/Users.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class file_details extends StatefulWidget {

  List<Users> selected;
  PlatformFile file;

  file_details(List<Users> this.selected, PlatformFile this.file, {Key? key}) : super(key: key);

  @override
  _file_detailsState createState() => _file_detailsState(selected, file);
}

String comments="";

class _file_detailsState extends State<file_details> {

  List<Users> selected = List.empty(growable: true);
  PlatformFile file;

  _file_detailsState(List<Users> this.selected, PlatformFile this.file);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Details", style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(new File(file.path!), fit: BoxFit.fill,),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
              child: Text("Share With",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w600
                ),
              ),
            ),
            selectedpeople(selected),
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
              child: Text("Comments",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w600
                ),
              ),
            ),
            comment_field(),
            submit_button(selected, file)
          ],
        ),
      ),
    );
  }
}


class submit_button extends StatefulWidget {
  List<Users> selected;
  PlatformFile file;
  submit_button(List<Users> this.selected, PlatformFile this.file, {Key? key}) : super(key: key);

  @override
  _submit_buttonState createState() => _submit_buttonState(selected, file);
}

class _submit_buttonState extends State<submit_button> {

  bool loading = false;
  List<Users> selected;
  PlatformFile file;
  String upload_progress="0";

  _submit_buttonState(List<Users> this.selected, PlatformFile this.file);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              onPressed: () async {
                if(!loading)
                  {
                    setState(() {
                      loading=true;
                    });
                  String unique = DateTime.now().millisecondsSinceEpoch.toString();
                  try {
                  final UploadFileResult result = await Amplify.Storage.uploadFile(
                  local: new File(file.path!),
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
                  await Amplify.DataStore.save(new Files(Name: file.name, Comment: comments, Link: url, key: unique, Department: selected.first.Department!),);
                  for(Users user in selected){
                    await Amplify.DataStore.save(new FileToUser(FileKey: unique, UserID: user.id));
                  }
                  Navigator.pop(context);
                  } on StorageException catch (e) {
                    print('Error uploading file: $e');
                    setState(() {
                      loading=false;
                    });
                  }
                  }
              },
              color: Color.fromRGBO(46, 49, 146, 1),
              child: loading? Text(upload_progress + "%", style: TextStyle(color: Colors.white, fontSize: 20,),): Text("Submit", style: TextStyle(color: Colors.white, fontSize: 20,),),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)
              ),
              padding: EdgeInsets.all(10),
            ),
          ),
        ),
      ],
    );
  }
}

class comment_field extends StatefulWidget {
  const comment_field({Key? key}) : super(key: key);

  @override
  _comment_fieldState createState() => _comment_fieldState();
}

class _comment_fieldState extends State<comment_field> {
  TextEditingController _controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Container(
        height: 300,
        child: TextFormField(
          controller: _controller,
          onChanged: (val) {
            comments = val.trim();
          },
          //maxLines: 13,
          maxLines: null,
          expands: true,
          decoration: InputDecoration(
            hintText: "Type Here...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15)
            ),
            //filled: true,
            fillColor: Colors.transparent,
          ),
          textAlignVertical: TextAlignVertical.top,
        ),
      ),
    );
  }
}


class selectedpeople extends StatefulWidget {
  List<Users> selected = List.empty(growable: true);
  selectedpeople(List<Users> this.selected, {Key? key}) : super(key: key);

  @override
  _selectedpeopleState createState() => _selectedpeopleState(selected);
}

class _selectedpeopleState extends State<selectedpeople> {
  List<Users> selected = List.empty(growable: true);
  _selectedpeopleState(List<Users> this.selected);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child:  Container(
        height: 30,
        child: ListView.builder(
          itemCount: selected.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return ChoiceChip(
                label: Text(selected.elementAt(index).Name!, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                pressElevation: 0,
                tooltip: selected.elementAt(index).Name!,
                labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: BorderSide()),
                backgroundColor: Colors.transparent,
                disabledColor: Colors.transparent,
                selected: false,
                );
            }),
      ),
    );
  }
}

