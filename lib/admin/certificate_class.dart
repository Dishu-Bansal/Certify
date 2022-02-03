import 'package:amplify_flutter/amplify.dart';
import 'package:certify/models/Certificates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Certificate extends ChangeNotifier {
  List<Certificates> certificates = new List.empty(growable: true);

  List<Certificates> get getCertificates {
    return certificates;
  }

  Future<List<Certificates>?> initializeCertificates(String user) async {
    try {
      certificates = await Amplify.DataStore.query(Certificates.classType, where: Certificates.USER.eq(user));
      print("I was here: " + user);
      notifyListeners();
      return certificates;
    }
    catch (e)
    {
      return null;
    }
  }

  Certificates getClosestExpiry() {
    certificates.sort((c1, c2) {
      return DateFormat("dd/MM/yyyy").parse(c1.ExpiryDate!).compareTo(DateFormat("dd/MM/yyyy").parse(c2.ExpiryDate!));
    });
    return certificates.first;
  }

  int get getNumber {
    return certificates.length;
  }
}