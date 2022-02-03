import 'package:amplify_flutter/amplify.dart';
import 'package:certify/models/Files.dart';
import 'package:flutter/cupertino.dart';

class department_details extends ChangeNotifier {
  List<Files> files = List.empty(growable: true);
  
  initializeDepartment(String department) async {
    files = await Amplify.DataStore.query(Files.classType, where: Files.DEPARTMENT.eq(department));
    notifyListeners();
  }


  int get getFilesLength {
    return files.length;
  }

}
