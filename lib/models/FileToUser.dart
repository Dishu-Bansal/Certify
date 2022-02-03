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


/** This is an auto generated class representing the FileToUser type in your schema. */
@immutable
class FileToUser extends Model {
  static const classType = const _FileToUserModelType();
  final String id;
  final String? _FileKey;
  final String? _UserID;

  @override
  getInstanceType() => classType;
  
  @override
  String getId() {
    return id;
  }
  
  String? get FileKey {
    return _FileKey;
  }
  
  String? get UserID {
    return _UserID;
  }
  
  const FileToUser._internal({required this.id, FileKey, UserID}): _FileKey = FileKey, _UserID = UserID;
  
  factory FileToUser({String? id, String? FileKey, String? UserID}) {
    return FileToUser._internal(
      id: id == null ? UUID.getUUID() : id,
      FileKey: FileKey,
      UserID: UserID);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FileToUser &&
      id == other.id &&
      _FileKey == other._FileKey &&
      _UserID == other._UserID;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("FileToUser {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("FileKey=" + "$_FileKey" + ", ");
    buffer.write("UserID=" + "$_UserID");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  FileToUser copyWith({String? id, String? FileKey, String? UserID}) {
    return FileToUser(
      id: id ?? this.id,
      FileKey: FileKey ?? this.FileKey,
      UserID: UserID ?? this.UserID);
  }
  
  FileToUser.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _FileKey = json['FileKey'],
      _UserID = json['UserID'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'FileKey': _FileKey, 'UserID': _UserID
  };

  static final QueryField ID = QueryField(fieldName: "fileToUser.id");
  static final QueryField FILEKEY = QueryField(fieldName: "FileKey");
  static final QueryField USERID = QueryField(fieldName: "UserID");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "FileToUser";
    modelSchemaDefinition.pluralName = "FileToUsers";
    
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
      key: FileToUser.FILEKEY,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: FileToUser.USERID,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
  });
}

class _FileToUserModelType extends ModelType<FileToUser> {
  const _FileToUserModelType();
  
  @override
  FileToUser fromJson(Map<String, dynamic> jsonData) {
    return FileToUser.fromJson(jsonData);
  }
}