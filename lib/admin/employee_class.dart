import 'package:amplify_flutter/amplify.dart';
import 'package:certify/models/AccessLevel.dart';
import 'package:certify/models/Users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Employee extends ChangeNotifier {
  List<Users> employees = new List.empty(growable: true);

  List<Users> get getEmployees {
    return employees;
  }

  Future<bool> initializeEmployees(String department) async {
    try{
      employees = await Amplify.DataStore.query(Users.classType, where: Users.ACCESS.eq(AccessLevel.EMPLOYEE).and(Users.DEPARTMENT.eq(department)));
      notifyListeners();
      return true;
    }
    catch (e)
    {
      return false;
    }
  }

  int get getEmployeesLength {
    return employees.length;
  }

}