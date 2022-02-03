import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:certify/models/AccessLevel.dart';
import 'package:certify/models/Users.dart';
import 'package:flutter/cupertino.dart';

class CurrentUser {

  static Users user = Users();
  bool signin=false;

  getCurrentUser() async {
    AuthSession use = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: false));
    if (use.isSignedIn) {
      AuthUser us = await Amplify.Auth.getCurrentUser();
      List<Users> u = await Amplify.DataStore.query(Users.classType, where: Users.ID.eq(us.userId));
      user = u.first;
      signin = true;
    }
    return user;
  }

  Users get getUser {
    return user;
  }
  bool get isSignedIn {
    return signin;
  }

  bool get isEmployee {
    return getAccessLevel == AccessLevel.EMPLOYEE;
  }

  bool get isClient {
    return getAccessLevel == AccessLevel.CLIENT;
  }

  bool get isCompany {
    return getAccessLevel == AccessLevel.COMPANY;
  }


  AccessLevel get getAccessLevel {
    return user.Access!;
}
}