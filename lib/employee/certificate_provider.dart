import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:certify/models/Certificates.dart';
import 'package:certify/models/Users.dart';
import 'package:flutter/cupertino.dart';

class certificate_provider extends ChangeNotifier {
  List<Certificates> certificates = new List.empty(growable: true);

  getCertificates() async {
    AuthUser us = await Amplify.Auth.getCurrentUser();
    String user = us.userId;
    certificates = await Amplify.DataStore.query(Certificates.classType, where: Certificates.USER.eq(user));
    notifyListeners();
  }

  getEmployeeCertificates(Users employee) async {
    //AuthUser us = await Amplify.Auth.getCurrentUser();
    String user = employee.id;
    certificates = await Amplify.DataStore.query(Certificates.classType, where: Certificates.USER.eq(user));
    notifyListeners();
  }

  elementAt(int index){
    return certificates.elementAt(index);
  }

  setCertificates(List<Certificates> certifica){
    certificates = certifica;
    notifyListeners();
  }

  int get getLength {
    return certificates.length;
  }

  deleteCertificate(Certificates certificate) async {
    await Amplify.DataStore.delete(certificate);
    await certificates.remove(certificate);
    notifyListeners();
  }
}