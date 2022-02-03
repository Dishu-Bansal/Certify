import 'package:amplify_flutter/amplify.dart';
import 'package:certify/models/AccessLevel.dart';
import 'package:certify/models/Certificates.dart';
import 'package:certify/models/Departments.dart';
import 'package:certify/models/FileToUser.dart';
import 'package:certify/models/Files.dart';
import 'package:certify/models/Users.dart';
import 'package:flutter/cupertino.dart';

class teams extends ChangeNotifier {
  List<Departments> departments = new List.empty(growable: true);
  Map<String, List<Users>> department_admin = Map();
  Map<String, List<Users>> department_employees = Map();

  initializeTeams() async {
    departments = await Amplify.DataStore.query(Departments.classType);
    for(Departments d in departments){
      List<Users> admins = await Amplify.DataStore.query(Users.classType, where: Users.DEPARTMENT.eq(d.Name).and(Users.ACCESS.eq(AccessLevel.CLIENT)));
      List<Users> employees = await Amplify.DataStore.query(Users.classType, where: Users.DEPARTMENT.eq(d.Name).and(Users.ACCESS.eq(AccessLevel.EMPLOYEE)));
      department_admin.putIfAbsent(d.Name!, () => admins);
      department_employees.putIfAbsent(d.Name!, () => employees);
    }
    notifyListeners();
  }

  List<Users> getAdmins (int index) {
    Departments d = departments.elementAt(index);
    List<Users> adm = department_admin[d.Name!]!;
    return adm;
  }

  List<Users> getEmployees(int index) {
    Departments d = departments.elementAt(index);
    List<Users> emp = department_employees[d.Name!]!;
    return emp;
  }

  List<Departments> get getDepartments {
    return departments;
  }

  deleteAllFiles(List<Files> files) async {
    for(Files f in files){
      List<FileToUser> f2 = (await Amplify.DataStore.query(FileToUser.classType, where: FileToUser.FILEKEY.eq(f.key)));
      for(FileToUser f3 in f2)
        {
          await Amplify.DataStore.delete(f3); 
        }
      await Amplify.DataStore.delete(f);
    }
  }

  deleteAllCertificates(List<Certificates> certificates) async {
    for(Certificates c in certificates){
      await Amplify.DataStore.delete(c);
    }
  }

  deleteUser(List<Users> employees) async {
    for(Users e in employees)
      {
        List<Certificates> c = await Amplify.DataStore.query(Certificates.classType, where: Certificates.USER.eq(e.id));
        deleteAllCertificates(c);
        await Amplify.DataStore.delete(e);
      }
  }

  Future<void> deleteDepartment(Departments department) async {
    List<Files> files = await Amplify.DataStore.query(Files.classType, where: Files.DEPARTMENT.eq(department.Name!));
    await deleteAllFiles(files);
    List<Users>? employees = department_employees[department.Name!];
    List<Users>? admins = department_admin[department.Name!];
    employees?.addAll(admins!);
    await deleteUser(employees!);
    await Amplify.DataStore.delete(department);
    departments.remove(department);
    department_admin.remove(department);
    department_employees.remove(department);
    notifyListeners();
  }

  int get getDepartmentsLength {
    return departments.length;
  }
}