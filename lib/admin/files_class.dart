import 'package:amplify_flutter/amplify.dart';
import 'package:certify/models/FileToUser.dart';
import 'package:certify/models/Files.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class files_class extends ChangeNotifier {
  List<Files> files = new List.empty(growable: true);

  List<Files> get getFiles {
    return files;
  }

  Future<List<Files>> initializeFiles(String user) async {
    files.clear();
      List<FileToUser> l = await Amplify.DataStore.query(FileToUser.classType, where: FileToUser.USERID.eq(user));
      print("File 1: " + l.toString());
      for(FileToUser f in l.toSet()){
        List<Files> f2 = await Amplify.DataStore.query(Files.classType, where: Files.KEY.eq(f.FileKey));
        print("File 2: " + f2.toString());
        files.addAll(f2.toSet());
      }
      files = files.toSet().toList(growable: true);
      return files;
  }

  Files getLatestFile() {
    files.sort((c1, c2) {
      return int.parse(c1.key!) - int.parse(c2.key!);
    });
    return files.last;
  }

  int get getNumber {
    return files.length;
  }
}