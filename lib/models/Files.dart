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


/** This is an auto generated class representing the Files type in your schema. */
@immutable
class Files extends Model {
  static const classType = const _FilesModelType();
  final String id;
  final String? _Name;
  final String? _Comment;
  final String? _Link;
  final String? _key;
  final String? _Department;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get Name {
    return _Name;
  }
  
  String? get Comment {
    return _Comment;
  }
  
  String? get Link {
    return _Link;
  }
  
  String? get key {
    return _key;
  }
  
  String? get Department {
    return _Department;
  }
  
  const Files._internal({required this.id, Name, Comment, Link, key, Department}): _Name = Name, _Comment = Comment, _Link = Link, _key = key, _Department = Department;
  
  factory Files({String? id, String? Name, String? Comment, String? Link, String? key, String? Department}) {
    return Files._internal(
      id: id == null ? UUID.getUUID() : id,
      Name: Name,
      Comment: Comment,
      Link: Link,
      key: key,
      Department: Department);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Files &&
      id == other.id &&
      _Name == other._Name &&
      _Comment == other._Comment &&
      _Link == other._Link &&
      _key == other._key &&
      _Department == other._Department;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Files {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("Name=" + "$_Name" + ", ");
    buffer.write("Comment=" + "$_Comment" + ", ");
    buffer.write("Link=" + "$_Link" + ", ");
    buffer.write("key=" + "$_key" + ", ");
    buffer.write("Department=" + "$_Department");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Files copyWith({String? id, String? Name, String? Comment, String? Link, String? key, String? Department}) {
    return Files(
      id: id ?? this.id,
      Name: Name ?? this.Name,
      Comment: Comment ?? this.Comment,
      Link: Link ?? this.Link,
      key: key ?? this.key,
      Department: Department ?? this.Department);
  }
  
  Files.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _Name = json['Name'],
      _Comment = json['Comment'],
      _Link = json['Link'],
      _key = json['key'],
      _Department = json['Department'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'Name': _Name, 'Comment': _Comment, 'Link': _Link, 'key': _key, 'Department': _Department
  };

  static final QueryField ID = QueryField(fieldName: "files.id");
  static final QueryField NAME = QueryField(fieldName: "Name");
  static final QueryField COMMENT = QueryField(fieldName: "Comment");
  static final QueryField LINK = QueryField(fieldName: "Link");
  static final QueryField KEY = QueryField(fieldName: "key");
  static final QueryField DEPARTMENT = QueryField(fieldName: "Department");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Files";
    modelSchemaDefinition.pluralName = "Files";
    
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
      key: Files.NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Files.COMMENT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Files.LINK,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Files.KEY,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: Files.DEPARTMENT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _FilesModelType extends ModelType<Files> {
  const _FilesModelType();
  
  @override
  Files fromJson(Map<String, dynamic> jsonData) {
    return Files.fromJson(jsonData);
  }
}