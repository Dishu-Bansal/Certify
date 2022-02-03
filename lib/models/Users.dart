/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, file_names, unnecessary_new, prefer_if_null_operators, prefer_const_constructors, slash_for_doc_comments, annotate_overrides, non_constant_identifier_names, unnecessary_string_interpolations, prefer_adjacent_string_concatenation, unnecessary_const, dead_code

import 'ModelProvider.dart';
import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Users type in your schema. */
@immutable
class Users extends Model {
  static const classType = const _UsersModelType();
  final String id;
  final String? _Name;
  final String? _Department;
  final AccessLevel? _Access;
  final String? _Email;
  final String? _Password;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get Name {
    return _Name;
  }
  
  String? get Department {
    return _Department;
  }
  
  AccessLevel? get Access {
    return _Access;
  }
  
  String? get Email {
    return _Email;
  }
  
  String? get Password {
    return _Password;
  }
  
  const Users._internal({required this.id, Name, Department, Access, Email, Password}): _Name = Name, _Department = Department, _Access = Access, _Email = Email, _Password = Password;
  
  factory Users({String? id, String? Name, String? Department, AccessLevel? Access, String? Email, String? Password}) {
    return Users._internal(
      id: id == null ? UUID.getUUID() : id,
      Name: Name,
      Department: Department,
      Access: Access,
      Email: Email,
      Password: Password);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Users &&
      id == other.id &&
      _Name == other._Name &&
      _Department == other._Department &&
      _Access == other._Access &&
      _Email == other._Email &&
      _Password == other._Password;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Users {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("Name=" + "$_Name" + ", ");
    buffer.write("Department=" + "$_Department" + ", ");
    buffer.write("Access=" + (_Access != null ? enumToString(_Access)! : "null") + ", ");
    buffer.write("Email=" + "$_Email" + ", ");
    buffer.write("Password=" + "$_Password");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Users copyWith({String? id, String? Name, String? Department, AccessLevel? Access, String? Email, String? Password}) {
    return Users(
      id: id ?? this.id,
      Name: Name ?? this.Name,
      Department: Department ?? this.Department,
      Access: Access ?? this.Access,
      Email: Email ?? this.Email,
      Password: Password ?? this.Password);
  }
  
  Users.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _Name = json['Name'],
      _Department = json['Department'],
      _Access = enumFromString<AccessLevel>(json['Access'], AccessLevel.values),
      _Email = json['Email'],
      _Password = json['Password'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'Name': _Name, 'Department': _Department, 'Access': enumToString(_Access), 'Email': _Email, 'Password': _Password
  };

  static final QueryField ID = QueryField(fieldName: "users.id");
  static final QueryField NAME = QueryField(fieldName: "Name");
  static final QueryField DEPARTMENT = QueryField(fieldName: "Department");
  static final QueryField ACCESS = QueryField(fieldName: "Access");
  static final QueryField EMAIL = QueryField(fieldName: "Email");
  static final QueryField PASSWORD = QueryField(fieldName: "Password");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Users";
    modelSchemaDefinition.pluralName = "Users";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.PUBLIC,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Users.NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Users.DEPARTMENT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Users.ACCESS,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Users.EMAIL,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Users.PASSWORD,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _UsersModelType extends ModelType<Users> {
  const _UsersModelType();
  
  @override
  Users fromJson(Map<String, dynamic> jsonData) {
    return Users.fromJson(jsonData);
  }
}