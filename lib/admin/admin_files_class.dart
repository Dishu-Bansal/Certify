import 'package:amplify_flutter/amplify.dart';
import 'package:certify/models/FileToUser.dart';
import 'package:certify/models/Files.dart';
import 'package:certify/models/Users.dart';
import 'package:flutter/cupertino.dart';

class admin_files_class extends ChangeNotifier {

  Map<Files, List<String>> filesAdmin = Map();
  List<Files> keys = List.empty(growable: true);

  Map<Files, List<String>> get getFilesAdmin {
    return filesAdmin;
  }

  Files getFile(int index){
    return keys.elementAt(index);
  }

  List<String>? getFileEmployees(int index){
    return filesAdmin[getFile(index)];
  }


  Future<bool> initializeFilesforAdmin(String department, List<Users> employees) async {
    filesAdmin.clear();
    try {
      keys = await Amplify.DataStore.query(Files.classType, where: Files.DEPARTMENT.eq(department));
      print("Keys are:" + keys.toString());
      for(Files f in keys){
        List<FileToUser> ftu = await Amplify.DataStore.query(FileToUser.classType, where: FileToUser.FILEKEY.eq(f.key));
        List<String> emp = List.empty(growable: true);
        for(FileToUser a in ftu){
          //List<Users> emp = await Amplify.DataStore.query(Users.classType, where: Users.ID.eq(a.UserID));
          emp.add(employees.firstWhere((element) { return element.id == a.UserID;}).Name!);
        }
        filesAdmin[f] = emp;
      }
      print("Admin Files are: " + filesAdmin.toString());
      notifyListeners();
      return true;
    }
    catch (e)
    {
      return false;
    }
  }

  int get getAdminFilesLength {
    return filesAdmin.length;
  }

  void deleteFile(Files f) {
    filesAdmin.remove(f);
    keys.remove(f);
    notifyListeners();
  }
}