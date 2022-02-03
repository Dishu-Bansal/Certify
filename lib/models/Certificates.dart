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

import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Certificates type in your schema. */
@immutable
class Certificates extends Model {
  static const classType = const _CertificatesModelType();
  final String id;
  final String? _Name;
  final String? _IssueDate;
  final String? _ExpiryDate;
  final String? _User;
  final String? _Link;
  final String? _key;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get Name {
    return _Name;
  }
  
  String? get IssueDate {
    return _IssueDate;
  }
  
  String? get ExpiryDate {
    return _ExpiryDate;
  }
  
  String? get User {
    return _User;
  }
  
  String? get Link {
    return _Link;
  }
  
  String? get key {
    return _key;
  }
  
  const Certificates._internal({required this.id, Name, IssueDate, ExpiryDate, User, Link, key}): _Name = Name, _IssueDate = IssueDate, _ExpiryDate = ExpiryDate, _User = User, _Link = Link, _key = key;
  
  factory Certificates({String? id, String? Name, String? IssueDate, String? ExpiryDate, String? User, String? Link, String? key}) {
    return Certificates._internal(
      id: id == null ? UUID.getUUID() : id,
      Name: Name,
      IssueDate: IssueDate,
      ExpiryDate: ExpiryDate,
      User: User,
      Link: Link,
      key: key);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Certificates &&
      id == other.id &&
      _Name == other._Name &&
      _IssueDate == other._IssueDate &&
      _ExpiryDate == other._ExpiryDate &&
      _User == other._User &&
      _Link == other._Link &&
      _key == other._key;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Certificates {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("Name=" + "$_Name" + ", ");
    buffer.write("IssueDate=" + "$_IssueDate" + ", ");
    buffer.write("ExpiryDate=" + "$_ExpiryDate" + ", ");
    buffer.write("User=" + "$_User" + ", ");
    buffer.write("Link=" + "$_Link" + ", ");
    buffer.write("key=" + "$_key");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Certificates copyWith({String? id, String? Name, String? IssueDate, String? ExpiryDate, String? User, String? Link, String? key}) {
    return Certificates(
      id: id ?? this.id,
      Name: Name ?? this.Name,
      IssueDate: IssueDate ?? this.IssueDate,
      ExpiryDate: ExpiryDate ?? this.ExpiryDate,
      User: User ?? this.User,
      Link: Link ?? this.Link,
      key: key ?? this.key);
  }
  
  Certificates.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _Name = json['Name'],
      _IssueDate = json['IssueDate'],
      _ExpiryDate = json['ExpiryDate'],
      _User = json['User'],
      _Link = json['Link'],
      _key = json['key'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'Name': _Name, 'IssueDate': _IssueDate, 'ExpiryDate': _ExpiryDate, 'User': _User, 'Link': _Link, 'key': _key
  };

  static final QueryField ID = QueryField(fieldName: "certificates.id");
  static final QueryField NAME = QueryField(fieldName: "Name");
  static final QueryField ISSUEDATE = QueryField(fieldName: "IssueDate");
  static final QueryField EXPIRYDATE = QueryField(fieldName: "ExpiryDate");
  static final QueryField USER = QueryField(fieldName: "User");
  static final QueryField LINK = QueryField(fieldName: "Link");
  static final QueryField KEY = QueryField(fieldName: "key");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Certificates";
    modelSchemaDefinition.pluralName = "Certificates";
    
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
      key: Certificates.NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Certificates.ISSUEDATE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Certificates.EXPIRYDATE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Certificates.USER,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Certificates.LINK,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Certificates.KEY,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _CertificatesModelType extends ModelType<Certificates> {
  const _CertificatesModelType();
  
  @override
  Certificates fromJson(Map<String, dynamic> jsonData) {
    return Certificates.fromJson(jsonData);
  }
}