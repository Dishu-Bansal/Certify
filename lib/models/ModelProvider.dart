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
import 'CertificateTypes.dart';
import 'Certificates.dart';
import 'Departments.dart';
import 'FileToUser.dart';
import 'Files.dart';
import 'Users.dart';

export 'AccessLevel.dart';
export 'CertificateTypes.dart';
export 'Certificates.dart';
export 'Departments.dart';
export 'FileToUser.dart';
export 'Files.dart';
export 'Users.dart';

class ModelProvider implements ModelProviderInterface {

  @override
  String version = "b76b7317f7e653009216e52e4435458a";
  @override
  List<ModelSchema> modelSchemas = [CertificateTypes.schema, Certificates.schema, Departments.schema, FileToUser.schema, Files.schema, Users.schema];
  static final ModelProvider _instance = ModelProvider();

  static ModelProvider get instance => _instance;
  
  ModelType getModelTypeByModelName(String modelName) {
    switch(modelName) {
    case "CertificateTypes": {
    return CertificateTypes.classType;
    }
    break;
    case "Certificates": {
    return Certificates.classType;
    }
    break;
    case "Departments": {
    return Departments.classType;
    }
    break;
    case "FileToUser": {
    return FileToUser.classType;
    }
    break;
    case "Files": {
    return Files.classType;
    }
    break;
    case "Users": {
    return Users.classType;
    }
    break;
    default: {
    throw Exception("Failed to find model in model provider for model name: " + modelName);
    }
    }
  }
}